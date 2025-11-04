-- Enable required PostgreSQL extensions
-- Migration: 00001_enable_extensions
-- Created: 2025-10-30

-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Cryptography functions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Case-insensitive text
CREATE EXTENSION IF NOT EXISTS "citext";

-- Comments
COMMENT ON EXTENSION "uuid-ossp" IS 'Generate UUIDs';
COMMENT ON EXTENSION "pgcrypto" IS 'Cryptographic functions for data encryption';
COMMENT ON EXTENSION "citext" IS 'Case-insensitive text type';
