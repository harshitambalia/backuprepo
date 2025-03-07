create or replace TABLE WHAT_IS_STUDENT (
	ID NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
	FIRST_NAME VARCHAR(50),
	LAST_NAME VARCHAR(50),
	AGE NUMBER(38,0),
	GRADE VARCHAR(2),
	EMAIL VARCHAR(100),
	primary key (ID)
);