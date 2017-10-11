/* Formatted on 10/11/2017 10:44:50 AM (QP5 v5.256.13226.35538) */
SELECT *
  FROM gl_ca_je_batches
 WHERE je_batch_id = 291567;

SELECT *
  FROM gl_ca_je_headers
 WHERE je_header_id = 588706;

SELECT *
  FROM gl_ca_je_lines
 WHERE je_header_id = 588681;

SELECT *
  FROM gl_ca_je_line_match
 WHERE je_header_id = 588681;

SELECT * FROM gl_ca_je_match_lock;