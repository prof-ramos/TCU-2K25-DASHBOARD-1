-- Create custom ENUM types
-- Migration: 00002_create_enums
-- Created: 2025-10-30

-- User role within a tenant
CREATE TYPE user_role AS ENUM ('admin', 'instructor', 'learner');

-- Subscription tiers
CREATE TYPE subscription_tier AS ENUM ('free', 'pro', 'enterprise');

-- Data request types (LGPD)
CREATE TYPE data_request_type AS ENUM ('export', 'delete');

-- Data request status
CREATE TYPE data_request_status AS ENUM ('pending', 'processing', 'completed', 'failed');

-- Consent types
CREATE TYPE consent_type AS ENUM ('terms', 'privacy', 'marketing', 'analytics');

-- Comments
COMMENT ON TYPE user_role IS 'Role of user within a tenant organization';
COMMENT ON TYPE subscription_tier IS 'Subscription plan level for tenants';
COMMENT ON TYPE data_request_type IS 'Type of data request for LGPD compliance';
COMMENT ON TYPE data_request_status IS 'Status of data request processing';
COMMENT ON TYPE consent_type IS 'Type of user consent for LGPD compliance';
