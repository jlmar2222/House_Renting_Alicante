USE House_Renting;

DROP TABLE IF EXISTS individual;

CREATE TABLE individual (
    idealista_id INT UNSIGNED,
    bedrooms INT UNSIGNED,
    bathrooms INT UNSIGNED,
    floor VARCHAR(255),  
    elevator ENUM("Y", "N"),
    terrace ENUM("Y", "N"), 
    balcony ENUM("Y", "N"),
    garaje ENUM("Y", "N"), 
    built_in_wardrobe ENUM("Y", "N"), 
    air_conditioning ENUM("Y", "N"), 
    swimming_pool ENUM("Y", "N"), 
    green_zone ENUM("Y", "N"),
    price INT UNSIGNED,
    furnished ENUM("Y","N"),
    equiped_kitchen ENUM("Y", "N"),
    street VARCHAR(255),
    neighborhood VARCHAR(255),
    district VARCHAR(255),
    m2_builded INT UNSIGNED,
    m2_habitable INT UNSIGNED
);
 
 
LOAD DATA INFILE 'C:/Users/jlmar/OneDrive/Escritorio/House_Renting_Alicante/individual.csv'
INTO TABLE individual 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


ALTER TABLE individual
ADD id INT AUTO_INCREMENT PRIMARY KEY ;

