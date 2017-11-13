DROP PROCEDURE IF EXISTS avs_be.publisherPointsNPVR;
DELIMITER $$
CREATE PROCEDURE avs_be.publisherPointsNPVR()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP3') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT3_PCTV }}' WHERE name = 'PP3';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('PCTV', 'PP3', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT3_PCTV }}', 100, 'NPVR', '');
  END IF;
  
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP6') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT6_STB_IPTV }}' WHERE name = 'PP6';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('STB_IPTV', 'PP6', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT6_STB_IPTV }}', 100, 'NPVR', 'AKAMAI');
  END IF;
  
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP25') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT25_IPAD }}' WHERE name = 'PP25';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('IPAD', 'PP25', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT25_IPAD }}', 100, 'NPVR', '');
  END IF;

  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP26') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT26_ANDROID }}' WHERE name = 'PP26';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('ANDROID', 'PP26', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT26_ANDROID }}', 100, 'NPVR', '');
  END IF;  

  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP27') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT27_CONNECTED }}' WHERE name = 'PP27';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('CONNECTED', 'PP27', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT27_CONNECTED }}', 100, 'NPVR', '');
  END IF;  
  
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP28') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT28_XBOX }}' WHERE name = 'PP28';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('XBOX', 'PP28', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT28_XBOX }}', 100, 'NPVR', '');
  END IF;   
 
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP29') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT29_DOWNLOAD }}' WHERE name = 'PP29';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('DOWNLOAD', 'PP29', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT29_DOWNLOAD }}', 100, 'NPVR', '');
  END IF; 
 
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP30') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT30_PLAYREADY }}' WHERE name = 'PP30';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('PLAYREADY', 'PP30', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT30_PLAYREADY }}', 100, 'NPVR', '');
  END IF; 
  
  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP31') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT31_OTTSTB }}' WHERE name = 'PP31';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('OTTSTB', 'PP31', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT31_OTTSTB }}', 100, 'NPVR', '');
  END IF;

  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP32') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT32_PLAYSTATION }}' WHERE name = 'PP32';
  ELSE 
    INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('PLAYSTATION', 'PP32', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT32_PLAYSTATION }}', 100, 'NPVR', '');
  END IF;  

  IF EXISTS (SELECT * FROM avs_be.publisher_point WHERE name = 'PP33') THEN
    UPDATE avs_be.publisher_point SET base_url= '{{ NPVR_PUBLISHERPOINT33_CHROMECAST }}' WHERE name = 'PP33';
  ELSE 
	INSERT INTO avs_be.publisher_point (platform, name, description, base_url, selector, type, cdn_type)
	VALUES ('CHROMECAST', 'PP33', 'GetUrlForNPVR', '{{ NPVR_PUBLISHERPOINT33_CHROMECAST }}', 100, 'NPVR', '');
  END IF;   
  
COMMIT; 
END $$
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
call avs_be.publisherPointsNPVR();
SET SQL_SAFE_UPDATES = 1;
DROP PROCEDURE IF EXISTS avs_be.publisherPointsNPVR;