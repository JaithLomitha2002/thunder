-- Table to store Organization Units
CREATE TABLE ORGANIZATION_UNIT (
    ID          INTEGER PRIMARY KEY AUTOINCREMENT,
    OU_ID       VARCHAR(36) UNIQUE NOT NULL,
    PARENT_ID   VARCHAR(36),
    HANDLE      VARCHAR(50)        NOT NULL,
    NAME        VARCHAR(50)        NOT NULL,
    DESCRIPTION VARCHAR(255),
    CREATED_AT  TEXT DEFAULT (datetime('now')),
    UPDATED_AT  TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (PARENT_ID) REFERENCES ORGANIZATION_UNIT (OU_ID) ON DELETE CASCADE
);

-- Table to store Users
CREATE TABLE USER (
    ID          INTEGER PRIMARY KEY AUTOINCREMENT,
    USER_ID     VARCHAR(36) UNIQUE NOT NULL,
    OU_ID       VARCHAR(36)        NOT NULL,
    TYPE        TEXT               NOT NULL,
    ATTRIBUTES  TEXT,
    CREDENTIALS TEXT,
    CREATED_AT  TEXT DEFAULT (datetime('now')),
    UPDATED_AT  TEXT DEFAULT (datetime('now'))
);

-- Table to store Groups
CREATE TABLE "GROUP" (
    ID          INTEGER PRIMARY KEY AUTOINCREMENT,
    GROUP_ID    VARCHAR(36) UNIQUE NOT NULL,
    OU_ID       VARCHAR(36)        NOT NULL,
    NAME        VARCHAR(50)        NOT NULL,
    DESCRIPTION VARCHAR(255),
    CREATED_AT  TEXT DEFAULT (datetime('now')),
    UPDATED_AT  TEXT DEFAULT (datetime('now'))
);

-- Table to store Group member assignments
CREATE TABLE GROUP_MEMBER_REFERENCE (
    ID          INTEGER PRIMARY KEY AUTOINCREMENT,
    GROUP_ID    VARCHAR(36) NOT NULL,
    MEMBER_TYPE VARCHAR(7)  NOT NULL,
    MEMBER_ID   VARCHAR(36) NOT NULL,
    CREATED_AT  TEXT DEFAULT (datetime('now')),
    UPDATED_AT  TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (GROUP_ID) REFERENCES "GROUP" (GROUP_ID) ON DELETE CASCADE
);

-- Table to store basic service provider (app) details.
CREATE TABLE SP_APP (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    APP_ID VARCHAR(36) UNIQUE NOT NULL,
    APP_NAME VARCHAR(255) NOT NULL,
    DESCRIPTION VARCHAR(50) NOT NULL,
    AUTH_FLOW_GRAPH_ID VARCHAR(50) NOT NULL,
    REGISTRATION_FLOW_GRAPH_ID VARCHAR(50) NOT NULL
);

-- Table to store OAuth configurations for SP apps.
CREATE TABLE IDN_OAUTH_CONSUMER_APPS (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    CONSUMER_KEY VARCHAR(255) NOT NULL,
    CONSUMER_SECRET VARCHAR(255) NOT NULL,
    APP_ID VARCHAR(36) NOT NULL,
    CALLBACK_URIS VARCHAR(500),
    GRANT_TYPES VARCHAR(255)
);

-- Table to store inbound auth configs (e.g., OAuth, SAML) for SP apps.
CREATE TABLE SP_INBOUND_AUTH (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    INBOUND_AUTH_KEY VARCHAR(255) NOT NULL,
    INBOUND_AUTH_TYPE VARCHAR(50) NOT NULL,
    APP_ID VARCHAR(36) NOT NULL
);

-- Table to store allowed origins for OAuth apps.
CREATE TABLE IDN_OAUTH_ALLOWED_ORIGINS (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ALLOWED_ORIGINS VARCHAR(500) NOT NULL UNIQUE
);

-- Table to store identity providers.
CREATE TABLE IDP (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    IDP_ID VARCHAR(36) UNIQUE NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    DESCRIPTION VARCHAR(500),
    CREATED_AT TEXT DEFAULT (datetime('now')),
    UPDATED_AT TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IDP_PROPERTY (
    IDP_ID VARCHAR(36) REFERENCES IDP(IDP_ID) ON DELETE CASCADE,
    PROPERTY_NAME VARCHAR(255) NOT NULL,
    PROPERTY_VALUE VARCHAR(500) NOT NULL,
    IS_SECRET CHAR(1) DEFAULT '0',
    PRIMARY KEY (IDP_ID, PROPERTY_NAME)
);

-- Table to store notification senders.
CREATE TABLE NOTIFICATION_SENDER (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NAME VARCHAR(255) NOT NULL,
    SENDER_ID VARCHAR(36) UNIQUE NOT NULL,
    DESCRIPTION VARCHAR(500),
    TYPE VARCHAR(20) NOT NULL,
    PROVIDER VARCHAR(20) NOT NULL,
    CREATED_AT TEXT DEFAULT (datetime('now')),
    UPDATED_AT TEXT DEFAULT (datetime('now'))
);

-- Table to store notification sender properties.
CREATE TABLE NOTIFICATION_SENDER_PROPERTY (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    SENDER_ID INTEGER NOT NULL REFERENCES NOTIFICATION_SENDER(SENDER_ID) ON DELETE CASCADE,
    PROPERTY_NAME VARCHAR(255) NOT NULL,
    PROPERTY_VALUE VARCHAR(500),
    IS_SECRET CHAR(1) DEFAULT '0',
    UNIQUE (SENDER_ID, PROPERTY_NAME)
);

-- Insert sample data into the tables.
INSERT INTO SP_APP (APP_NAME, APP_ID, DESCRIPTION, AUTH_FLOW_GRAPH_ID, REGISTRATION_FLOW_GRAPH_ID) VALUES ('Test SPA', '550e8400-e29b-41d4-a716-446655440000', 'Initial testing App', 'auth_flow_config_basic', 'registration_flow_config_basic');

INSERT INTO IDN_OAUTH_CONSUMER_APPS (CONSUMER_KEY, CONSUMER_SECRET, APP_ID, CALLBACK_URIS, GRANT_TYPES)
VALUES ('client123', 'secret123', '550e8400-e29b-41d4-a716-446655440000', 'https://localhost:3000', 'client_credentials,authorization_code');

INSERT INTO SP_INBOUND_AUTH (INBOUND_AUTH_KEY, INBOUND_AUTH_TYPE, APP_ID)
VALUES ('client123', 'oauth2', '550e8400-e29b-41d4-a716-446655440000');

INSERT INTO IDN_OAUTH_ALLOWED_ORIGINS (ALLOWED_ORIGINS) VALUES ('https://localhost:3000,https://localhost:9001');

INSERT INTO USER (USER_ID, OU_ID, TYPE, ATTRIBUTES, CREATED_AT, UPDATED_AT)
VALUES (
           '550e8400-e29b-41d4-a716-446655440000', '456e8400-e29b-41d4-a716-446655440001', 'person',
           '{"age": 30, "roles": ["admin", "user"], "address": {"city": "Colombo", "zip": "00100"}}',
           datetime('now'), datetime('now')
       );

INSERT INTO IDP (IDP_ID, NAME, DESCRIPTION, CREATED_AT, UPDATED_AT)
VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Local', 'Local Identity Provider', datetime('now'), datetime('now')),
('550e8400-e29b-41d4-a716-446655440001', 'Github', 'Login with Github', datetime('now'), datetime('now')),
('550e8400-e29b-41d4-a716-446655440002', 'Google', 'Login with Google', datetime('now'), datetime('now'));

INSERT INTO IDP_PROPERTY (IDP_ID, PROPERTY_NAME, PROPERTY_VALUE, IS_SECRET)
VALUES
('550e8400-e29b-41d4-a716-446655440001', 'client_id', 'client1', '0'),
('550e8400-e29b-41d4-a716-446655440001', 'client_secret', 'secret1', '1'),
('550e8400-e29b-41d4-a716-446655440001', 'redirect_uri', 'https://localhost:3000', '0'),
('550e8400-e29b-41d4-a716-446655440001', 'scopes', 'user:email,read:user', '0'),
('550e8400-e29b-41d4-a716-446655440002', 'client_id', 'client2', '0'),
('550e8400-e29b-41d4-a716-446655440002', 'client_secret', 'secret2', '1'),
('550e8400-e29b-41d4-a716-446655440002', 'redirect_uri', 'https://localhost:3000', '0'),
('550e8400-e29b-41d4-a716-446655440002', 'scopes', 'openid,email,profile', '0');

-- Insert sample organization units
INSERT INTO ORGANIZATION_UNIT (OU_ID, PARENT_ID, HANDLE, NAME, DESCRIPTION, CREATED_AT, UPDATED_AT)
VALUES
('456e8400-e29b-41d4-a716-446655440001', NULL, 'root', 'Root Organization', 'Root organization unit', datetime('now'), datetime('now')),
('456e8400-e29b-41d4-a716-446655440002', '456e8400-e29b-41d4-a716-446655440001', 'engineering', 'Engineering', 'Engineering department', datetime('now'), datetime('now')),
('456e8400-e29b-41d4-a716-446655440003', '456e8400-e29b-41d4-a716-446655440001', 'sales', 'Sales', 'Sales department', datetime('now'), datetime('now')),
('456e8400-e29b-41d4-a716-446655440004', '456e8400-e29b-41d4-a716-446655440002', 'frontend', 'Frontend Team', 'Frontend development team', datetime('now'), datetime('now'));
