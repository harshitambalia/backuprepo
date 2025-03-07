create or replace view A_GRADE_STUDENTS_VIEW(
	FIRST_NAME,
	LAST_NAME,
	AGE
) as
SELECT first_name, last_name, age
FROM PUBLIC.dev_students
WHERE grade = 'A';