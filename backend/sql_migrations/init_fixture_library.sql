--CREATE DATABASE stage_control;

--DROP TABLE fixture_library.mode_channel;
--DROP TABLE fixture_library.fixture_mode;
--DROP TABLE fixture_library.fixture;
--DROP TABLE fixture_library.channel_content;
--DROP TABLE fixture_library.channel_type;
--DROP TABLE fixture_library.power_connector;
--DROP TABLE fixture_library.manufacturer;
--DROP TABLE fixture_library.fixture_type;
--DROP SCHEMA fixture_library CASCADE;


CREATE SCHEMA fixture_library;

-- Create fixture_type table
CREATE TABLE fixture_library.fixture_type (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Create manufacturer table
CREATE TABLE fixture_library.manufacturer (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Create power_connector table
CREATE TABLE fixture_library.power_connector (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Create channel_content table
CREATE TABLE fixture_library.channel_content (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Create fixture table
CREATE TABLE fixture_library.fixture (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    fixture_type_id INTEGER NOT NULL
        REFERENCES fixture_library.fixture_type(id)
        ON DELETE RESTRICT,

    name TEXT NOT NULL,
    manufacturer_id INTEGER NOT NULL 
        REFERENCES fixture_library.manufacturer(id)
        ON DELETE RESTRICT,

    power_usage_watt INTEGER NOT NULL,
    power_connector_id INTEGER NOT NULL
        REFERENCES fixture_library.power_connector(id)
        ON DELETE RESTRICT,
    has_power_link BOOLEAN NOT NULL,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    version INTEGER NOT NULL DEFAULT 1,

    UNIQUE (manufacturer_id, name)
);

-- Create mode table
CREATE TABLE fixture_library.mode (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    fixture_id INTEGER NOT NULL 
        REFERENCES fixture_library.fixture(id)
        ON DELETE CASCADE,

    name TEXT NOT NULL,
    channel_count INTEGER NOT NULL,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    version INTEGER NOT NULL DEFAULT 1
);

-- Create channel table
CREATE TABLE fixture_library.channel (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    mode_id INTEGER NOT NULL 
        REFERENCES fixture_library.mode(id)
        ON DELETE CASCADE,

    channel_number INTEGER NOT NULL,
    channel_content_id INTEGER NOT NULL
        REFERENCES fixture_library.channel_content(id)
        ON DELETE RESTRICT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    version INTEGER NOT NULL DEFAULT 1,

    UNIQUE (mode_id, channel_number)
);