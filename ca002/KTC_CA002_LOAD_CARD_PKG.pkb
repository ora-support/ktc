/* Formatted on 10/11/2017 11:23:36 AM (QP5 v5.256.13226.35538) */
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
      TmpVar   NUMBER;
   BEGIN
      TmpVar := p_file_name;
   END;
END KTC_CA002_LOAD_CARD_PKG;
/