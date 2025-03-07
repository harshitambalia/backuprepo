create or replace view A_GRADE_STUDENTS_VIEW_FOR_NEW_DB(
	FIRST_NAME,
	LAST_NAME,
	GRADE,
	FULL_NAME,
	GRADE_STATUS
) as
SELECT 
    first_name, 
    last_name, 
    grade,
    CONCAT(first_name, ' ', last_name) AS full_name,  -- New column: full name
    CASE 
        WHEN grade = 'A' THEN 'Excellent'
        WHEN grade = 'B' THEN 'Good'
        ELSE 'Average'
    END AS grade_status  -- New column: grade status
FROM MY_SCHEMA.what_is_student
WHERE grade = 'A';