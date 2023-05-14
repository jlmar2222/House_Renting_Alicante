/* 

Before creating the actual 'individual' table we rader create a intermedia table 'prueba',
in orther to make the neccesary CRUD. 

*/


USE House_Renting;

DROP TABLE IF EXISTS prueba;

CREATE TABLE prueba (
    idealista_id INT UNSIGNED,
    m2_ VARCHAR(255),
    bedrooms VARCHAR(255),
    bathrooms VARCHAR(255),
    floor VARCHAR(255),
    price VARCHAR(255),
    location VARCHAR(255),
    elevator VARCHAR(255),
    terrace VARCHAR(255), 
    balcony VARCHAR(255),
    garaje VARCHAR(255), 
    built_in_wardrobe VARCHAR(255), 
    furnished VARCHAR(255), 
    air_conditioning VARCHAR(255), 
    swimming_pool VARCHAR(255), 
    green_zone VARCHAR(255) 
);

LOAD DATA INFILE 'C:/Users/jlmar/OneDrive/Escritorio/House_Renting_Alicante/output_file.csv'
INTO TABLE prueba 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;










