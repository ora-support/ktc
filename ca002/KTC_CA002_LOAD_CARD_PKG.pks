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
END KTC_CA002_LOAD_CARD_PKG;
/