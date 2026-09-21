/* =====================================================================
   Check for duplicate CERT_FILE_ID values in GBQ
   ===================================================================== */

-- taxbibt
SELECT cert_file_id, COUNT(*) AS cnt
FROM `clgx-taxbi-reg-bf03`.taxbibt.las_ada_cert_file
GROUP BY cert_file_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- taxdw
SELECT cert_file_id, COUNT(*) AS cnt
FROM `clgx-taxbi-reg-bf03`.taxdw.las_ada_cert_file
GROUP BY cert_file_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- Expected: 0 rows in both (cert_file_id should be unique)


/* =====================================================================
   Optional - same check scoped only to the backfilled rows
   (cert_ordr_nbr = 0), useful right after running the backfill
   ===================================================================== */

SELECT cert_file_id, COUNT(*) AS cnt
FROM `clgx-taxbi-reg-bf03`.taxbibt.las_ada_cert_file
WHERE cert_ordr_nbr = 0
GROUP BY cert_file_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;


/* =====================================================================
   Also check the merge key itself (CERT_ORDR_NBR + CERT_ORDR_DT_TM)
   for duplicates - this is the actual key the merge script uses to
   match rows, so duplicates here are more likely to cause issues than
   plain cert_file_id duplicates
   ===================================================================== */

SELECT cert_ordr_nbr, cert_ordr_dt_tm, COUNT(*) AS cnt
FROM `clgx-taxbi-reg-bf03`.taxbibt.las_ada_cert_file
WHERE cert_ordr_nbr = 0
GROUP BY cert_ordr_nbr, cert_ordr_dt_tm
HAVING COUNT(*) > 1
ORDER BY cnt DESC;
