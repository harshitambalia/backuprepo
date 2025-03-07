create or replace view A_GRADE_STUDENTS_VIEW(
	FIRST_NAME,
	LAST_NAME,
	GRADE
) as
SELECT first_name, last_name, grade
FROM MY_SCHEMA.what_is_student
WHERE grade = 'B';