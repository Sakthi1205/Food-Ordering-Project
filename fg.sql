CREATE database exam_jsp;
INSERT INTO student_details(id,name) VALUES (1,"NEYA" ) , (2,"RAJ");
SELECT * FROM student_details;
INSERT INTO questions(qid,question,op1,op2,ra) VALUES (1,"What is square of 2?","4","8","4" ) , (2,"What is cube of 2?","4","8","8") , (3,"What is square of 3?","9","27","9");
SELECT * FROM questions;
DELETE FROM questions where qid = 3;student_details