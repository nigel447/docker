---- TEST ######
\c postgres
drop database lambda_dev;
create database lambda_dev;
\c lambda_dev
\i schema.sql

\pset format wrapped

-- optional for triggers not needed development, run this twice
\i triggers_dev.sql

