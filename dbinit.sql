CREATE USER kestra WITH PASSWORD 'kestra';
CREATE DATABASE kestra OWNER kestra;
GRANT ALL PRIVILEGES ON DATABASE kestra TO kestra;

CREATE USER carica WITH PASSWORD 'carica';
CREATE DATABASE carica OWNER carica;
GRANT ALL PRIVILEGES ON DATABASE carica TO carica;
