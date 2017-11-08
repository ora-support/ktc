/* Formatted on 11/8/2017 10:10:32 PM (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PACKAGE BODY APPS.KTC_CA002_LOAD_CARD_PKG
AS
   /******************************************************************************
      NAME:       KTC_CA002_LOAD_CARD_PKG
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/11/2017      spw@ice       1. Created this package body.
   ******************************************************************************/

   PROCEDURE start_up (errbuf      IN OUT NOCOPY VARCHAR2,
                       errcode     IN OUT NOCOPY INTEGER,
                       p_file_id   IN            NUMBER)
   IS
      g_user_id            PLS_INTEGER := fnd_global.user_id;
      g_login_id           PLS_INTEGER := fnd_global.login_id;
      g_conc_req_id        PLS_INTEGER := fnd_global.conc_request_id;

      l_lines              ktc_ca002_load_card_pkg.ktc_temp_tbl_type;

      l_insert_temp_flag   BOOLEAN := FALSE;
      l_validation_flag    BOOLEAN := FALSE;
   BEGIN
      write_log ('USER_ID :' || g_user_id, 'LOG');
      write_log ('USER_LOGIN_ID :' || g_login_id, 'LOG');
      write_log ('REQUEST_ID :' || g_conc_req_id, 'LOG');
      write_log ('P_FILE_ID :' || p_file_id || CHR (10), 'LOG');
      write_log (
         '==============================================================',
         'LOG');

      write_log (
            '*Call read_file('
         || g_conc_req_id
         || ', '
         || p_file_id
         || ') at: '
         || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'),
         'LOG');
      l_lines := read_file (g_conc_req_id, p_file_id);

      IF l_lines IS NOT NULL
      THEN
         l_insert_temp_flag := insert_rec_to_temp (l_lines);
      END IF;

      IF (l_insert_temp_flag)
      THEN
         l_validation_flag := validation_data (g_conc_req_id);
      END IF;
   END;

   FUNCTION read_file (p_request_id IN NUMBER, p_file_id IN NUMBER)
      RETURN ktc_temp_tbl_type
   IS
      l_blob          BLOB;
      l_blob_fnme     VARCHAR2 (200);
      l_line_stream   VARCHAR2 (32767);
      l_string        VARCHAR2 (32767);
      l_clob          CLOB;
      c_line          NUMBER;
      c_str           NUMBER := 1;
      c_len           NUMBER;
      c_pos           NUMBER;

      l_lines         ktc_ca002_load_card_pkg.ktc_temp_tbl_type;
      l_lines_rec     ktc_ca002_load_card_pkg.ktc_temp_rec_type;
   BEGIN
      SELECT file_name, file_data
        INTO l_blob_fnme, l_blob
        FROM fnd_lobs
       WHERE file_id = p_file_id;

      write_log ('  - File name : ' || l_blob_fnme, 'LOG');
      l_clob := BLob_to_CLob (l_blob);

      SELECT LENGTH (l_clob) - LENGTH (REPLACE (l_clob, CHR (13)))
        INTO c_line
        FROM DUAL;

      FOR i IN 1 .. c_line
      LOOP
         l_string := SUBSTR (l_clob, c_str, LENGTH (l_clob));
         c_pos := INSTR (l_string, CHR (13));

         l_line_stream := SUBSTR (l_string, 1, c_pos);
         c_str := c_str + c_pos + 1;

         IF i <> 1
         THEN
            l_lines_rec.file_id := p_file_id;
            l_lines_rec.file_name := l_blob_fnme;
            l_lines_rec.request_id := p_request_id;
            l_lines_rec.batch_name :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     1),
                      ',');
            l_lines_rec.journal_name :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     2),
                      ',');
            l_lines_rec.category_name :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     3),
                      ',');
            l_lines_rec.gl_date :=
               TO_DATE (RTRIM (REGEXP_SUBSTR (l_line_stream || ',',
                                              '[^,]*,',
                                              1,
                                              4),
                               ','),
                        'DD-MON-YY');
            l_lines_rec.journal_desc :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     5),
                      ',');
            l_lines_rec.currency_code :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     6),
                      ',');
            l_lines_rec.journal_line :=
               TO_NUMBER (RTRIM (REGEXP_SUBSTR (l_line_stream,
                                                '[^,]*,',
                                                1,
                                                7),
                                 ','));
            l_lines_rec.company :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     8),
                      ',');
            l_lines_rec.rc :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     9),
                      ',');
            l_lines_rec.basel :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     10),
                      ',');
            l_lines_rec.account :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     11),
                      ',');
            l_lines_rec.product :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     12),
                      ',');
            l_lines_rec.intercompany :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     13),
                      ',');

            l_lines_rec.tax_code :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     14),
                      ',');
            l_lines_rec.reserve :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     15),
                      ',');
            l_lines_rec.allocation :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     16),
                      ',');
            l_lines_rec.entered_dr :=
               TO_NUMBER (RTRIM (REGEXP_SUBSTR (l_line_stream,
                                                '[^,]*,',
                                                1,
                                                17),
                                 ','));
            l_lines_rec.entered_cr :=
               TO_NUMBER (RTRIM (REGEXP_SUBSTR (l_line_stream,
                                                '[^,]*,',
                                                1,
                                                18),
                                 ','));
            l_lines_rec.reference_no :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     19),
                      ',');
            l_lines_rec.statement_no :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     20),
                      ',');
            l_lines_rec.line_desc :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     21),
                      ',');
            l_lines_rec.voucher_no_out :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     22),
                      ',');
            l_lines_rec.line_no_out :=
               RTRIM (REGEXP_SUBSTR (l_line_stream,
                                     '[^,]*,',
                                     1,
                                     23),
                      ',');
            l_lines_rec.error_flag := 'N';
            l_lines_rec.user_login_id := fnd_global.login_id;
            l_lines_rec.created_by := fnd_global.user_id;
            l_lines_rec.last_updated_by := fnd_global.user_id;
            l_lines (i - 2) := l_lines_rec;
         END IF;
      END LOOP;

      RETURN l_lines;
   END;

   FUNCTION BLob_to_CLob (i_blob IN BLOB)
      RETURN CLOB
   AS
      o_clob           CLOB;
      i_dest_offset    NUMBER (15) := 1;
      i_src_offset     NUMBER (15) := 1;
      i_lang_context   NUMBER (15) := DBMS_LOB.DEFAULT_LANG_CTX;
      i_Warning        NUMBER (15);
   BEGIN
      IF i_blob IS NOT NULL
      THEN
         IF LENGTH (i_blob) = 0
         THEN
            RETURN EMPTY_CLOB ();
         END IF;

         DBMS_LOB.createTemporary (lob_loc => o_clob, cache => FALSE);
         DBMS_LOB.CONVERTTOCLOB (dest_lob       => o_clob,
                                 src_blob       => i_blob,
                                 amount         => DBMS_LOB.LOBMAXSIZE,
                                 dest_offset    => i_dest_Offset,
                                 src_offset     => i_src_Offset,
                                 blob_csid      => DBMS_LOB.DEFAULT_CSID,
                                 lang_context   => i_lang_context,
                                 warning        => i_Warning);
      ELSE
         o_clob := NULL;
         write_log ('clob is null.', 'line');
      END IF;

      RETURN o_clob;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END BLob_to_CLob;

   FUNCTION insert_rec_to_temp (p_lines_in IN ktc_temp_tbl_type)
      RETURN BOOLEAN
   IS
   BEGIN
      IF (NVL (p_lines_in.LAST, 0) > 0)
      THEN
         FOR i IN p_lines_in.FIRST .. p_lines_in.LAST
         LOOP
            write_log ('Insert to temp ' || p_lines_in (i).batch_name, 'OUT');

            INSERT INTO APPS.ktc_ca002_load_card_temp (transaction_id,
                                                       request_id,
                                                       file_id,
                                                       file_name,
                                                       batch_name,
                                                       journal_name,
                                                       category_name,
                                                       gl_date,
                                                       journal_desc,
                                                       currency_code,
                                                       journal_line,
                                                       company,
                                                       rc,
                                                       basel,
                                                       account,
                                                       product,
                                                       intercompany,
                                                       tax_code,
                                                       reserve,
                                                       allocation,
                                                       entered_dr,
                                                       entered_cr,
                                                       reference_no,
                                                       statement_no,
                                                       line_desc,
                                                       voucher_no_out,
                                                       line_no_out,
                                                       created_by,
                                                       last_updated_by,
                                                       user_login_id,
                                                       error_flag,
                                                       error_message)
                 VALUES (p_lines_in (i).transaction_id,
                         p_lines_in (i).request_id,
                         p_lines_in (i).file_id,
                         p_lines_in (i).file_name,
                         p_lines_in (i).batch_name,
                         p_lines_in (i).journal_name,
                         p_lines_in (i).category_name,
                         p_lines_in (i).gl_date,
                         p_lines_in (i).journal_desc,
                         p_lines_in (i).currency_code,
                         p_lines_in (i).journal_line,
                         p_lines_in (i).company,
                         p_lines_in (i).rc,
                         p_lines_in (i).basel,
                         p_lines_in (i).account,
                         p_lines_in (i).product,
                         p_lines_in (i).intercompany,
                         p_lines_in (i).tax_code,
                         p_lines_in (i).reserve,
                         p_lines_in (i).allocation,
                         p_lines_in (i).entered_dr,
                         p_lines_in (i).entered_cr,
                         p_lines_in (i).reference_no,
                         p_lines_in (i).statement_no,
                         p_lines_in (i).line_desc,
                         p_lines_in (i).voucher_no_out,
                         p_lines_in (i).line_no_out,
                         p_lines_in (i).created_by,
                         p_lines_in (i).last_updated_by,
                         p_lines_in (i).user_login_id,
                         p_lines_in (i).error_flag,
                         p_lines_in (i).error_message);
         END LOOP;
      END IF;

      COMMIT;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END;

   FUNCTION validation_data (p_request_id IN NUMBER)
      RETURN BOOLEAN
   IS
      CURSOR c_batchs (l_request_id NUMBER)
      IS
           SELECT tmp.request_id,
                  tmp.file_id,
                  tmp.file_name,
                  tmp.batch_name,
                  tmp.gl_date
             FROM ktc_ca002_load_card_temp tmp
            WHERE tmp.request_id = l_request_id
         GROUP BY tmp.request_id,
                  tmp.file_id,
                  tmp.file_name,
                  tmp.batch_name,
                  tmp.gl_date;

      v_valid_batch    BOOLEAN := FALSE;
      v_valid_header   BOOLEAN := TRUE;
      v_valid_line     BOOLEAN := TRUE;
      v_messege        VARCHAR2 (1000);

      l_batch_row      ktc_ca002_load_card_temp%ROWTYPE;
      l_insert_batch   BOOLEAN;
      o_je_batch_id    NUMBER;
   BEGIN
      IF (validate_batches (p_request_id, v_messege))
      THEN
         v_valid_batch := TRUE;
      ELSE
         v_valid_batch := FALSE;
      END IF;

      IF (v_valid_batch AND v_valid_header AND v_valid_line)
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN FALSE;
   END;

   FUNCTION validate_batches (p_request_id IN NUMBER, o_msg VARCHAR2)
      RETURN BOOLEAN
   IS
      CURSOR c_batchs (l_request_id NUMBER)
      IS
           SELECT tmp.request_id,
                  tmp.file_id,
                  tmp.file_name,
                  tmp.batch_name,
                  tmp.gl_date
             FROM ktc_ca002_load_card_temp tmp
            WHERE tmp.request_id = l_request_id
         GROUP BY tmp.request_id,
                  tmp.file_id,
                  tmp.file_name,
                  tmp.batch_name,
                  tmp.gl_date;

      v_temp       ktc_ca002_load_card_temp%ROWTYPE;
      v_msg        VARCHAR2 (1000);
      v_err_flag   CHAR (1);
   BEGIN
      write_log (
            '*Start Validation BATCHES at: '
         || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'),
         'LOG');

      FOR v_cur IN c_batchs (p_request_id)
      LOOP
         v_temp := NULL;
         v_msg := '';
         v_err_flag := 'N';

         write_log ('    - Duplicate Batches.', 'LOG');

         BEGIN
            SELECT name
              INTO v_temp.batch_name
              FROM gl_ca_je_batches
             WHERE name = TRIM (v_cur.batch_name);

            IF v_temp.batch_name IS NOT NULL
            THEN
               v_err_flag := 'Y';

               IF v_msg IS NOT NULL
               THEN
                  v_msg :=
                        v_msg
                     || CHR (10)
                     || 'Batch : '''
                     || v_temp.batch_name
                     || ''' was duplicate.';
               ELSE
                  v_msg :=
                     'Batch : ''' || v_temp.batch_name || ''' was duplicate.';
               END IF;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_err_flag := 'N';
            WHEN OTHERS
            THEN
               v_err_flag := 'Y';

               IF v_msg IS NOT NULL
               THEN
                  v_msg := v_msg || CHR (10) || 'Invalid Batch :' || SQLERRM;
               ELSE
                  v_msg := 'Invalid Batch :' || SQLERRM;
               END IF;
         END;

         IF (v_err_flag = 'Y')
         THEN
            keep_errors (v_cur.batch_name, v_msg);
         END IF;
      END LOOP;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         write_log ('[Validate Batches] : ' || SQLERRM, 'LOG');
         RETURN FALSE;
   END;

   FUNCTION insert_batches (
      p_temp_row          ktc_ca002_load_card_temp%ROWTYPE,
      o_je_batch_id   OUT NUMBER)
      RETURN BOOLEAN
   IS
      --v_seq_batches      NUMBER;
      g_user_id          PLS_INTEGER := fnd_global.user_id;
      g_login_id         PLS_INTEGER := fnd_global.login_id;
      g_set_of_book_id   PLS_INTEGER
                            := fnd_profile.VALUE ('GL_SET_OF_BKS_ID');
   BEGIN
      SELECT gl_ca_je_batches_s.NEXTVAL INTO o_je_batch_id FROM DUAL;

      INSERT INTO gl_ca_je_batches (je_batch_id,
                                    set_of_books_id,
                                    name,
                                    status,
                                    budgetary_control_status,
                                    default_period_name,
                                    description,
                                    running_total_dr,
                                    running_total_cr,
                                    running_total_accounted_dr,
                                    running_total_accounted_cr,
                                    created_by,
                                    creation_date,
                                    last_update_login,
                                    last_updated_by,
                                    last_update_date)
           VALUES (o_je_batch_id,
                   g_set_of_book_id,
                   p_temp_row.batch_name,
                   'P',
                   'Y',
                   TO_CHAR (p_temp_row.gl_date, 'MON-YY'),
                   p_temp_row.batch_name,
                   0,
                   0,
                   0,
                   0,
                   g_user_id,
                   SYSDATE,
                   g_login_id,
                   g_user_id,
                   SYSDATE);

      COMMIT;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_je_batch_id := 0;
         write_log ('[Insert Batch] :' || SQLERRM, 'LOG');
         RETURN FALSE;
   END;

   PROCEDURE update_entered_batch (p_batch_id            NUMBER,
                                   p_batch_entered_dr    NUMBER,
                                   p_batch_entered_cr    NUMBER)
   IS
   BEGIN
      UPDATE gl_ca_je_batches
         SET running_total_dr = p_batch_entered_dr,
             running_total_cr = p_batch_entered_cr,
             running_total_accounted_dr = p_batch_entered_dr,
             running_total_accounted_cr = p_batch_entered_cr
       WHERE je_batch_id = p_batch_id;
   END update_entered_batch;

   PROCEDURE keep_errors (p_batch_name VARCHAR2, p_msg VARCHAR2)
   IS
      v_msg           VARCHAR2 (3000) := NULL;
      g_conc_req_id   PLS_INTEGER := fnd_global.conc_request_id;
   BEGIN
      FOR r
         IN (SELECT *
               FROM ktc_ca002_load_card_temp
              WHERE     request_id = g_conc_req_id
                    AND UPPER (TRIM (batch_name)) =
                           UPPER (TRIM (p_batch_name)))
      LOOP
         IF (   LENGTH (TRIM (r.error_message)) <> 0
             OR r.error_message IS NOT NULL)
         THEN
            SELECT DECODE (r.error_message, NULL, CHR (10))
              INTO v_msg
              FROM DUAL;

            v_msg := p_msg;
         ELSIF r.error_message IS NULL
         THEN
            v_msg := p_msg;
         END IF;


         UPDATE ktc_ca002_load_card_temp
            SET error_flag = 'Y', error_message = v_msg
          WHERE transaction_id = r.transaction_id;
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         write_log ('[Keep errors] : ' || SQLERRM, 'LOG');
   END;

   PROCEDURE write_log (buff VARCHAR2, which VARCHAR2)
   IS
   BEGIN
      IF UPPER (which) = 'LOG'
      THEN
         fnd_file.put_LINE (FND_FILE.LOG, buff);
      ELSE
         fnd_file.put_line (FND_FILE.OUTPUT, buff);
      END IF;
   END write_log;
END KTC_CA002_LOAD_CARD_PKG;
/