/* Formatted on 10/16/2017 10:20:01 AM (QP5 v5.256.13226.35538) */
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

   TYPE ktc_temp_rec_type IS RECORD
   (
      transaction_id     ktc_ca002_load_card_temp.transaction_id%TYPE,
      file_id            ktc_ca002_load_card_temp.file_id%TYPE,
      file_name          ktc_ca002_load_card_temp.file_name%TYPE,
      batch_name         ktc_ca002_load_card_temp.batch_name%TYPE,
      journal_name       ktc_ca002_load_card_temp.journal_name%TYPE,
      category_name      ktc_ca002_load_card_temp.category_name%TYPE,
      gl_date            ktc_ca002_load_card_temp.gl_date%TYPE,
      journal_desc       ktc_ca002_load_card_temp.journal_desc%TYPE,
      currency_code      ktc_ca002_load_card_temp.currency_code%TYPE,
      journal_line       ktc_ca002_load_card_temp.journal_line%TYPE,
      company            ktc_ca002_load_card_temp.company%TYPE,
      rc                 ktc_ca002_load_card_temp.rc%TYPE,
      basel              ktc_ca002_load_card_temp.basel%TYPE,
      account            ktc_ca002_load_card_temp.account%TYPE,
      product            ktc_ca002_load_card_temp.product%TYPE,
      intercompany       ktc_ca002_load_card_temp.intercompany%TYPE,
      tax_code           ktc_ca002_load_card_temp.tax_code%TYPE,
      reserve            ktc_ca002_load_card_temp.reserve%TYPE,
      allocation         ktc_ca002_load_card_temp.allocation%TYPE,
      entered_dr         ktc_ca002_load_card_temp.entered_dr%TYPE,
      entered_cr         ktc_ca002_load_card_temp.entered_cr%TYPE,
      reference_no       ktc_ca002_load_card_temp.reference_no%TYPE,
      statement_no       ktc_ca002_load_card_temp.statement_no%TYPE,
      line_desc          ktc_ca002_load_card_temp.line_desc%TYPE,
      voucher_no_out     ktc_ca002_load_card_temp.voucher_no_out%TYPE,
      line_no_out        ktc_ca002_load_card_temp.line_no_out%TYPE,
      creation_date      ktc_ca002_load_card_temp.creation_date%TYPE,
      created_by         ktc_ca002_load_card_temp.created_by%TYPE,
      last_update_date   ktc_ca002_load_card_temp.last_update_date%TYPE,
      last_updated_by    ktc_ca002_load_card_temp.last_updated_by%TYPE,
      error_flag         ktc_ca002_load_card_temp.error_flag%TYPE,
      error_message      ktc_ca002_load_card_temp.error_message%TYPE
   );

   TYPE ktc_temp_tbl_type IS TABLE OF ktc_temp_rec_type
      INDEX BY BINARY_INTEGER;

   PROCEDURE start_up (errbuf        IN OUT NOCOPY VARCHAR2,
                       errcode       IN OUT NOCOPY INTEGER,
                       p_file_id   IN            NUMBER);


   FUNCTION read_file (p_request_id IN NUMBER, p_file_id IN NUMBER)
      RETURN ktc_temp_tbl_type;

   FUNCTION BLob_to_CLob (i_blob IN BLOB)
      RETURN CLOB;

   PROCEDURE write_log (buff VARCHAR2, which VARCHAR2);
END ktc_ca002_load_card_pkg;
/