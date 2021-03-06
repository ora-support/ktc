DROP TABLE APPS.GL_CA_JE_BATCHES_TEMP CASCADE CONSTRAINTS;

CREATE TABLE APPS.GL_CA_JE_BATCHES_TEMP
(
  REQUEST_ID                  NUMBER,
  JE_BATCH_ID                 NUMBER(15)        NOT NULL,
  SET_OF_BOOKS_ID             NUMBER(15)        NOT NULL,
  NAME                        VARCHAR2(100 BYTE) NOT NULL,
  STATUS                      VARCHAR2(1 BYTE),
  BUDGETARY_CONTROL_STATUS    VARCHAR2(1 BYTE),
  DEFAULT_PERIOD_NAME         VARCHAR2(15 BYTE),
  DESCRIPTION                 VARCHAR2(240 BYTE),
  SHOW_BATCH_STATUS           VARCHAR2(100 BYTE),
  SHOW_BC_STATUS              VARCHAR2(100 BYTE),
  RUNNING_TOTAL_DR            NUMBER,
  RUNNING_TOTAL_CR            NUMBER,
  RUNNING_TOTAL_ACCOUNTED_DR  NUMBER,
  RUNNING_TOTAL_ACCOUNTED_CR  NUMBER,
  CREATED_BY                  NUMBER(15),
  CREATION_DATE               DATE,
  LAST_UPDATE_LOGIN           NUMBER(15),
  LAST_UPDATED_BY             NUMBER(15),
  LAST_UPDATE_DATE            DATE,
  ERROR_FLAG                  CHAR(1 BYTE),
  ERROR_MESSAGE               VARCHAR2(3000 BYTE)
)
TABLESPACE APPS_TS_TX_DATA
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE OR REPLACE TRIGGER APPS.GL_CA_JE_BATCHES_TEMP_TRG
   BEFORE INSERT OR UPDATE
   ON APPS.GL_CA_JE_BATCHES_TEMP
   FOR EACH ROW
BEGIN
   IF UPDATING
   THEN
      :NEW.LAST_UPDATE_DATE := SYSDATE;
   END IF;

   IF INSERTING
   THEN      
      :NEW.LAST_UPDATE_DATE := SYSDATE;
      :NEW.CREATION_DATE := SYSDATE;
   END IF;
END;
/
