--liquibase formatted sql

--changeset mbessarab:2_CREATE_table_users
--comment: Create SeedKey users table
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(64) PRIMARY KEY,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
    last_login BIGINT
);

COMMENT ON TABLE users IS 'SeedKey Auth users table';
COMMENT ON COLUMN users.id IS 'Unique user identifier (SHA-256 of the public key)';
COMMENT ON COLUMN users.created_at IS 'Record creation date and time';
COMMENT ON COLUMN users.last_login IS 'Last login date and time';

--rollback DROP TABLE IF EXISTS users;

