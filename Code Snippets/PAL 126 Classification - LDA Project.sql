-- cleanup
DROP TYPE "T_DATA";
DROP TYPE "T_RESULTS";
DROP TABLE "SIGNATURE";
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_DROP"('DEVUSER', 'P_LDAPROJECT');
DROP VIEW "V_DATA";
DROP TABLE "RESULTS";

-- procedure setup
CREATE TYPE "T_DATA" AS TABLE ("ID" INTEGER, "ATTR1" DOUBLE, "ATTR2" DOUBLE, "ATTR3" DOUBLE, "ATTR4" DOUBLE);
CREATE TYPE "T_RESULTS" AS TABLE ("ID" INTEGER, "COMP1" DOUBLE, "COMP2" DOUBLE);
CREATE COLUMN TABLE "SIGNATURE" ("POSITION" INTEGER, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO "SIGNATURE" VALUES (1, 'DEVUSER', 'T_DATA', 'IN');
INSERT INTO "SIGNATURE" VALUES (2, 'DEVUSER', 'T_PROJECTION_MODEL', 'IN');
INSERT INTO "SIGNATURE" VALUES (3, 'DEVUSER', 'T_PARAMS', 'IN');
INSERT INTO "SIGNATURE" VALUES (4, 'DEVUSER', 'T_RESULTS', 'OUT');
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_CREATE"('AFLPAL', 'LDAPROJECT', 'DEVUSER', 'P_LDAPROJECT', "SIGNATURE");

-- data & view setup
CREATE VIEW "V_DATA" AS SELECT "ID", "ATTR1", "ATTR2", "ATTR3", "ATTR4" FROM "PAL"."CLASSIFICATION";
CREATE COLUMN TABLE "RESULTS" LIKE "T_RESULTS";

-- runtime
DROP TABLE "#PARAMS";
CREATE LOCAL TEMPORARY COLUMN TABLE "#PARAMS" LIKE "T_PARAMS";
--INSERT INTO "#PARAMS" VALUES ('MAX_COMPONENTS', 2, null, null);

TRUNCATE TABLE "RESULTS";

CALL "P_LDAPROJECT" ("V_DATA", "PROJECTION_MODEL", "#PARAMS", "RESULTS") WITH OVERVIEW;

SELECT * FROM "RESULTS";