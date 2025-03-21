CREATE OR REPLACE PROCEDURE "CALL_CHATBOT"("PROMPT" VARCHAR)
RETURNS TABLE ("CHATBOT_RESPONSE" VARCHAR, "SQL_STATEMENT" VARCHAR, "QUERY_RESULT" VARCHAR)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python','pandas')
HANDLER = 'process_user_input'
EXECUTE AS OWNER
AS '
import json
import pandas as pd
from snowflake.snowpark import Session
import _snowflake

API_ENDPOINT = "/api/v2/cortex/analyst/message"
API_TIMEOUT = 50000  # in milliseconds

def get_analyst_response(prompt):
    request_body = {
        "messages": [{"role": "user", "content": [{"type": "text", "text": prompt}]}],
        "semantic_model_file": "@MY_DBT_EXPERIMENT_DB.PUBLIC.TEMP_STAGE/revenue_timeseries_updated.yaml",
    }

    response = _snowflake.send_snow_api_request(
        "POST",
        API_ENDPOINT,
        {},  # headers
        {},  # params
        request_body,
        None,  # request_guid
        API_TIMEOUT,
    )

    parsed_response = json.loads(response["content"])

    # Extract chatbot''s textual response
    text_response = "\\n".join(
        part["text"] for part in parsed_response["message"]["content"] if "text" in part
    )

    # Extract SQL query
    sql_statement = None
    for part in parsed_response["message"]["content"]:
        if part.get("type") == "sql" and "statement" in part:
            sql_statement = part["statement"]
            break  # Take the first SQL statement found

    return text_response, sql_statement

def execute_sql_query(session, sql_query):
    """Executes the SQL query in Snowflake and returns results."""
    try:
        df = session.sql(sql_query).to_pandas()
        if df.empty:
            return "Query executed successfully, but no data was returned."
        return df.to_json(orient="records")  # Convert result to JSON
    except Exception as e:
        return f"Error executing SQL: {str(e)}"

def process_user_input(session: Session, prompt: str):
    """Calls chatbot API, extracts SQL, executes query, and returns results as a Snowpark DataFrame."""
    text_response, sql_query = get_analyst_response(prompt)

    # If no SQL query is generated, return chatbot''s interpretation alone
    query_result = "No SQL query generated"
    if sql_query:
        query_result = execute_sql_query(session, sql_query)

    # Return both chatbot response, SQL query, and its execution result
    return session.create_dataframe([(text_response, sql_query, query_result)], schema=["chatbot_response", "sql_statement", "query_result"])
';