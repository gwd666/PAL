SET SCHEMA PAL;

-- PAL setup

CREATE TYPE PAL_T_DTP_DATA AS TABLE (ID INTEGER, POLICY VARCHAR(10), AGE INTEGER, AMOUNT INTEGER, OCCUPATION VARCHAR(10));
CREATE TYPE PAL_T_DTP_PREDICT AS TABLE (ID INTEGER, FRAUD VARCHAR(10));

CREATE COLUMN TABLE PAL_DTP_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
INSERT INTO PAL_DTP_SIGNATURE VALUES (1, 'PAL.PAL_T_DTP_DATA', 'in');
INSERT INTO PAL_DTP_SIGNATURE VALUES (2, 'PAL.PAL_T_DT_PARAMS', 'in');
INSERT INTO PAL_DTP_SIGNATURE VALUES (3, 'PAL.PAL_T_DT_MODEL_JSON', 'in');
INSERT INTO PAL_DTP_SIGNATURE VALUES (4, 'PAL.PAL_T_DTP_PREDICT', 'out');

CALL SYSTEM.AFL_WRAPPER_GENERATOR ('PAL_DTP', 'AFLPAL', 'PREDICTWITHDT', PAL_DTP_SIGNATURE);

-- app setup

CREATE COLUMN TABLE DTP_DATA LIKE PAL_T_DTP_DATA;
CREATE COLUMN TABLE DTP_PARAMS LIKE PAL_T_DT_PARAMS;
CREATE COLUMN TABLE DTP_PREDICT LIKE PAL_T_DTP_PREDICT;

INSERT INTO DTP_DATA VALUES (1, 'Travel', 56, 350, 'IT');
INSERT INTO DTP_DATA VALUES (2, 'Vehicle', 26, 6230, 'Marketing');
INSERT INTO DTP_DATA VALUES (3, 'Home', 55, 2300, 'Marketing');
INSERT INTO DTP_DATA VALUES (4, 'Vehicle', 31, 2134, 'Marketing');
INSERT INTO DTP_DATA VALUES (5, 'Home', 37, 2900, 'Sales');

INSERT INTO DTP_PARAMS VALUES ('THREAD_NUMBER', 2, null, null);

-- app runtime

TRUNCATE TABLE DTP_PREDICT;

CALL _SYS_AFL.PAL_DTP (DTP_DATA, DTP_PARAMS, DT_MODEL_JSON, DTP_PREDICT) WITH OVERVIEW;

SELECT d.*, p.FRAUD 
 FROM DTP_DATA d
 INNER JOIN DTP_PREDICT p ON (p.ID=d.ID)
 ;
