--liquibase formatted sql

--changeset mbessarab:3_CREATE_table_public_keys
--comment: Create users public keys table
CREATE TABLE IF NOT EXISTS public_keys (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    public_key TEXT UNIQUE NOT NULL,
    device_name VARCHAR(255),
    added_at BIGINT DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
    last_used BIGINT DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT
);

COMMENT ON TABLE public_keys IS 'Users public keys for authentication';
COMMENT ON COLUMN public_keys.id IS 'Unique key identifier';
COMMENT ON COLUMN public_keys.user_id IS 'Reference to user';
COMMENT ON COLUMN public_keys.public_key IS 'Public key in Base64 format';
COMMENT ON COLUMN public_keys.device_name IS 'Device name';
COMMENT ON COLUMN public_keys.added_at IS 'Key added date';
COMMENT ON COLUMN public_keys.last_used IS 'Last used date';

--rollback DROP TABLE IF EXISTS public_keys;

--changeset mbessarab:3_CREATE_index_public_keys_user_id
--comment: Index for fast lookup of keys by user_id
CREATE INDEX IF NOT EXISTS idx_public_keys_user_id ON public_keys(user_id);

--rollback DROP INDEX IF EXISTS idx_public_keys_user_id;

--changeset mbessarab:3_CREATE_index_public_keys_public_key
--comment: Index for fast lookup by public key
CREATE INDEX IF NOT EXISTS idx_public_keys_public_key ON public_keys(public_key);

--rollback DROP INDEX IF EXISTS idx_public_keys_public_key;

