-- Insert dummy data
INSERT INTO fixture_library.fixture_type (name)
VALUES
('DMX');

INSERT INTO fixture_library.manufacturer (name)
VALUES
('Cameo'),
('Blue Sea'),
('ADJ'),
('Martin');

INSERT INTO fixture_library.power_connector (name)
VALUES
('True1'),
('Powercon'),
('IEC');

INSERT INTO fixture_library.channel_content (name)
VALUES
('Intensity'),
('Red'),
('Green'),
('Blue'),
('Pan'),
('Tilt');

INSERT INTO fixture_library.fixture (manufacturer_id, fixture_type_id, name, power_usage_watt, power_connector_id, has_power_link) VALUES 
(
    '9', '3', 'Thunder Wash 600 RGBW', '160', '8', TRUE
),
(
    '10', '3', '19pcs 15w LED Wash Zoom', '230', '8', TRUE
),
(
    '11', '3', 'Vizi Beam CMY', '400', '7', TRUE
),
(
    '11', '3', 'Inno Color Beam Z7', '230', '9', TRUE
),
(
    '12', '3', 'Atomic 3000', '650', '7', TRUE
),
(
    '10', '3', 'LED Par 18x18 IP', '230', '7', TRUE
),
(
    '10', '3', '250W Beam Moving Head Light', '250', '8', TRUE
),
(
    '9', '3', 'CL PixBar 600 Pro', '300', '8', TRUE
),
(
    '10', '3', '200W LED Spotlight', '210', '8', TRUE
);