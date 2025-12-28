--liquibase formatted sql

--changeset mbessarab:5_CREATE_table_challenges
--comment: Create authentication challenges table
CREATE TABLE IF NOT EXISTS challenges (
    id VARCHAR(64) PRIMARY KEY,
    challenge TEXT NOT NULL,
    nonce VARCHAR(64) NOT NULL,
    public_key TEXT,
    action VARCHAR(32) NOT NULL,
    domain VARCHAR(255),
    created_at BIGINT NOT NULL,
    expires_at BIGINT NOT NULL,
    used BOOLEAN DEFAULT FALSE
);

COMMENT ON TABLE challenges IS 'Challenges for cryptographic authentication';
COMMENT ON COLUMN challenges.id IS 'Unique challenge identifier';
COMMENT ON COLUMN challenges.challenge IS 'Challenge text to sign';
COMMENT ON COLUMN challenges.nonce IS 'One-time random identifier';
COMMENT ON COLUMN challenges.public_key IS 'Public key (optional)';
COMMENT ON COLUMN challenges.action IS 'Action type: register, login, recovery';
COMMENT ON COLUMN challenges.domain IS 'Domain the challenge was created for';
COMMENT ON COLUMN challenges.created_at IS 'Creation timestamp (Unix ms)';
COMMENT ON COLUMN challenges.expires_at IS 'Expiration timestamp (Unix ms)';
COMMENT ON COLUMN challenges.used IS 'Challenge used flag';

--rollback DROP TABLE IF EXISTS challenges;

--changeset mbessarab:5_CREATE_index_challenges_nonce
--comment: Index for fast lookup of challenge by nonce
CREATE INDEX IF NOT EXISTS idx_challenges_nonce ON challenges(nonce);

--rollback DROP INDEX IF EXISTS idx_challenges_nonce;

