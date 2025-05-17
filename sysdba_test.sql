SELECT owner, table_name
FROM dba_tables
ORDER BY owner, table_name;

SELECT *
FROM dba_pdbs
ORDER BY pdb_id;

SELECT name, dbid, created
FROM v$database;


SELECT *
FROM v$services
