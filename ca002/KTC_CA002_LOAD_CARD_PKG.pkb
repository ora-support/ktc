/* Formatted on 10/16/2017 9:01:11 AM (QP5 v5.256.13226.35538) */
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

   PROCEDURE start_up (errbuf        IN OUT NOCOPY VARCHAR2,
                       errcode       IN OUT NOCOPY INTEGER,
                       p_file_name   IN            NUMBER)
   IS
      tmpvar   NUMBER;
   BEGIN
      tmpvar := p_file_name;
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