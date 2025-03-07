create or replace TABLE DEVVV_STUDENTS (
	ID NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
	FIRST_NAME VARCHAR(50),
	LAST_NAME VARCHAR(50),
	AGE NUMBER(38,0),
	GRADE VARCHAR(2),
	primary key (ID)
);