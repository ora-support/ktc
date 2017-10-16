/* Formatted on 10/16/2017 10:31:18 AM (QP5 v5.256.13226.35538) */
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
      tmpvar   NUMBER;
   BEGIN
      tmpvar := p_file_id;
   END;

   FUNCTION read_file (p_request_id IN NUMBER, p_file_id IN NUMBER)
      RETURN ktc_temp_tbl_type
   IS
      l_blob          BLOB;
      --l_blob_len      INTEGER;
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
        FROM FND_LOBS
       WHERE FILE_ID = p_file_id;

      l_clob := BLob_to_CLob (l_blob);

      SELECT LENGTH (l_clob) - LENGTH (REPLACE (l_clob, CHR (13)))
        INTO c_line
        FROM DUAL;

      FOR j IN 1 .. c_line / 350
      LOOP
         c_len :=
            INSTR (l_string,
                   CHR (13),
                   1,
                   10);

         FOR i IN 1 .. c_line
         LOOP
            l_string := SUBSTR (l_clob, c_str, LENGTH (l_clob));
            c_pos := INSTR (l_string, CHR (13));

            l_line_stream := SUBSTR (l_string, 1, c_pos);
            c_str := c_str + c_pos + 1;

            IF i <> 1
            THEN
               l_lines_rec.batch_name :=
                  RTRIM (REGEXP_SUBSTR (l_line_stream,
                                        '[^,]*,',
                                        1,
                                        1),
                         ',');
               l_lines_rec.created_by := 1101;
               l_lines (i - 2) := l_lines_rec;
            END IF;
         END LOOP;
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

         DBMS_LOB.createTemporary (lob_loc => o_clob, cache => FALSE); -- read into buffer cache
         -- write_log('test1', 'line');
         DBMS_LOB.CONVERTTOCLOB (dest_lob       => o_clob,
                                 src_blob       => i_blob,
                                 amount         => DBMS_LOB.LOBMAXSIZE,
                                 dest_offset    => i_dest_Offset,
                                 src_offset     => i_src_Offset,
                                 blob_csid      => DBMS_LOB.DEFAULT_CSID,
                                 lang_context   => i_lang_context,
                                 warning        => i_Warning);
      -- write_log(i_blob, 'line');
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

   PROCEDURE write_log (buff VARCHAR2, which VARCHAR2)
   IS
   BEGIN
      IF UPPER (which) = 'LOG'
      THEN
         fnd_file.put_LINE (FND_FILE.LOG, buff);
      ELSE
         fnd_file.put_line (FND_FILE.OUTPUT, buff);
      END IF;
   --DBMS_OUTPUT.put_line (Pchar);
   END write_log;
END KTC_CA002_LOAD_CARD_PKG;
/