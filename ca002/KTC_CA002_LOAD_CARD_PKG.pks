/* Formatted on 10/16/2017 9:01:06 AM (QP5 v5.256.13226.35538) */
CREATE OR REPLACE PACKAGE APPS.KTC_CA002_LOAD_CARD_PKG
AS
   /******************************************************************************
      NAME:       KTC_CA002_LOAD_CARD_PKG
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        10/11/2017      spw@ice       1. Created this package.
   ******************************************************************************/

   PROCEDURE start_up (errbuf        IN OUT NOCOPY VARCHAR2,
                       errcode       IN OUT NOCOPY INTEGER,
                       p_file_name   IN            NUMBER);

   FUNCTION BLob_to_CLob (i_blob IN BLOB)
      RETURN CLOB;

   PROCEDURE write_log (buff VARCHAR2, which VARCHAR2);
END KTC_CA002_LOAD_CARD_PKG;
/