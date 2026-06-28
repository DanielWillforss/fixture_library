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
    '5', '2', 'Thunder Wash 600 RGBW', '160', '5', TRUE
),
(
    '6', '2', '19pcs 15w LED Wash Zoom', '230', '5', TRUE
),
(
    '7', '2', 'Vizi Beam CMY', '400', '4', TRUE
),
(
    '7', '2', 'Inno Color Beam Z7', '230', '6', TRUE
),
(
    '8', '2', 'Atomic 3000', '650', '4', TRUE
),
(
    '6', '2', 'LED Par 18x18 IP', '230', '4', TRUE
),
(
    '6', '2', '250W Beam Moving Head Light', '250', '5', TRUE
),
(
    '5', '2', 'CL PixBar 600 Pro', '300', '5', TRUE
),
(
    '6', '2', '200W LED Spotlight', '210', '5', TRUE
);