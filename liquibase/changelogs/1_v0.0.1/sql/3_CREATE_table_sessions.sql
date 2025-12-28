--liquibase formatted sql

--changeset mbessarab:4_CREATE_table_sessions
--comment: Create users sessions table
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    public_key_id VARCHAR(64) NOT NULL,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
    expires_at BIGINT NOT NULL,
    invalidated BOOLEAN DEFAULT FALSE
);

COMMENT ON TABLE sessions IS 'Active user sessions';
COMMENT ON COLUMN sessions.id IS 'Unique session identifier';
COMMENT ON COLUMN sessions.user_id IS 'Reference to user';
COMMENT ON COLUMN sessions.public_key_id IS 'ID of the public key used to sign in';
COMMENT ON COLUMN sessions.created_at IS 'Session creation date';
COMMENT ON COLUMN sessions.expires_at IS 'Session expiration date';
COMMENT ON COLUMN sessions.invalidated IS 'Session invalidation flag (logout)';

--rollback DROP TABLE IF EXISTS sessions;

--changeset mbessarab:4_CREATE_index_sessions_user_id
--comment: Index for fast lookup of sessions by user_id
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions(user_id);

--rollback DROP INDEX IF EXISTS idx_sessions_user_id;

