USE House_Renting;


/*

--UPDATING BEDROOMS DATA--

We are interested only in he numbers.
We will set '9 habitaciones o mas' as '9'. (SON PARA OFICINAS Y SOCIEDADES)
We will set 'Sin habitaciones' as '0'. (SON COMO ESTUDIOS Y LOFTS)


MariaDB [House_Renting]> SELECT bedrooms FROM prueba GROUP BY bedrooms;

+----------------------+
| bedrooms             |
+----------------------+
| 1 habitación         |
| 2 habitaciones       |
| 3 habitaciones       |
| 4 habitaciones       |
| 5 habitaciones       |
| 6 habitaciones       |
| 7 habitaciones       |
| 9 habitaciones o más |
| Sin habitación       |
+----------------------+

*/

UPDATE prueba
SET bedrooms = SUBSTRING_INDEX(bedrooms, ' ', 1);

UPDATE prueba
SET bedrooms = 0 
WHERE bedrooms  LIKE 'Sin%';

/*

--After the updating--

MariaDB [House_Renting]> SELECT bedrooms FROM prueba GROUP BY bedrooms;
+----------+
| bedrooms |
+----------+
| 0        |
| 1        |
| 2        |
| 3        |
| 4        |
| 5        |
| 6        |
| 7        |
| 8        |
| 9        |
+----------+

*/

/*

--UPDATING BATHROOMS--

We do the same for bathrooms, only interested in numbers.

MariaDB [House_Renting]> SELECT bathrooms FROM prueba GROUP BY bathrooms; 
+-----------+
| bathrooms |
+-----------+
| 1 baño    |
| 2 baños   |
| 3 baños   |
| 4 baños   |
| 5 baños   |
| 6 baños   |
| 7 baños   |
| 52 baños  |
+-----------+

*/

UPDATE prueba
SET bathrooms = SUBSTRING_INDEX(bathrooms, ' ', 1);


/*

--After the updating--

MariaDB [House_Renting]> SELECT bathrooms FROM prueba GROUP BY bathrooms;
+-----------+
| bathrooms |
+-----------+
| 1         |
| 2         |
| 3         |
| 4         |
| 5         |
| 52        |
| 6         |
| 7         |
+-----------+

*/

/*

--UPDATING PRICES--

We want to remove the ' ?/mes' from our data set.
And replace '.' with ''. So we aboide future compatibility problems.
Finally conerting it into a int column.

MariaDB [House_renting]> SELECT price FROM prueba WHERE idealista_id = 101033658;
+-------------+
| price       |
+-------------+
| 1.300 ?/mes |
+-------------+

*/

UPDATE prueba 
SET price = SUBSTRING(price, 1, LENGTH(price)-8);

UPDATE prueba 
SET price = REPLACE(price, '.', '');

ALTER TABLE prueba 
ADD COLUMN n_price INT UNSIGNED;

UPDATE prueba
SET n_price = CAST(price AS INT);

ALTER TABLE prueba
DROP COLUMN price;

/*

--After the update--

MariaDB [House_renting]> SELECT n_price FROM prueba WHERE idealista_id = 101033658;
+---------+
| n_price |
+---------+
|  1300   |
+---------+

*/

/*

--UPDATING TERRACE, ELEVATOR, BALCONY, BUILT_IN_WARDROBE, AIR_CONDITIONING,
  SWIMING_POOL, GREEN_ZONE--

The idea is to set 'None' values as 'N'(o),
and set 'Corresponding_name' values as 'Y'(es).
This will generate a bunch of binari columns.

*/

UPDATE prueba
SET terrace = 'N' 
WHERE terrace = 'None';

UPDATE prueba
SET terrace = 'Y' 
WHERE terrace = 'Terraza';

UPDATE prueba
SET balcony = 'N' 
WHERE balcony = 'None';

UPDATE prueba
SET balcony = 'Y' 
WHERE balcony = 'Balcón';

UPDATE prueba
SET built_in_wardrobe = 'N' 
WHERE built_in_wardrobe = 'None';

UPDATE prueba
SET built_in_wardrobe = 'Y' 
WHERE built_in_wardrobe = 'Armarios empotrados';

UPDATE prueba
SET air_conditioning = 'N' 
WHERE air_conditioning = 'None';

UPDATE prueba
SET air_conditioning = 'Y' 
WHERE air_conditioning = 'Aire acondicionado';

UPDATE prueba
SET swimming_pool = 'N' 
WHERE swimming_pool = 'None';

UPDATE prueba
SET swimming_pool = 'Y' 
WHERE swimming_pool = 'Piscina';

UPDATE prueba
SET elevator = 'N' 
WHERE elevator = 'None';

UPDATE prueba
SET elevator = 'Y' 
WHERE elevator = 'Con ascensor';

UPDATE prueba
SET green_zone = 'N' 
WHERE green_zone  NOT LIKE '%onas%';

UPDATE prueba
SET green_zone = 'Y' 
WHERE green_zone LIKE '%onas%';

/*

--UPDATING FURNISHED--

Just for make it more easy,
we are going to set 'Amueblada y cocina equipato' 
to 'Cocina equipada y casa amueblada'.
Then we will separete the string into two.
And insert the corresponding into two new columns.
Finally transforming each column in binari values, as we did previously. 

MariaDB [House_Renting]> SELECT furnished FROM prueba GROUP BY furnished;
+----------------------------------------+
| furnished                              |
+----------------------------------------+
| Amueblado y cocina equipada            |
| Cocina equipada y casa sin amueblar    |
| Cocina sin equipar y casa sin amueblar |
| None                                   |
+----------------------------------------+

*/

UPDATE prueba
SET furnished = 'Cocina equipada y casa amueblada'
WHERE furnished = 'Amueblado y cocina equipada';

ALTER TABLE prueba
ADD COLUMN furnished_ VARCHAR(255),
ADD COLUMN equiped_kitchen VARCHAR(255);

UPDATE prueba
SET equiped_kitchen = SUBSTRING_INDEX(furnished, 'y', 1), furnished_ = TRIM(SUBSTRING_INDEX(furnished, 'y', -1));

UPDATE prueba
SET equiped_kitchen = 'N' 
WHERE equiped_kitchen = 'None';

UPDATE prueba
SET equiped_kitchen = 'N' 
WHERE equiped_kitchen = 'Cocina sin equipar';

UPDATE prueba
SET equiped_kitchen = 'Y' 
WHERE equiped_kitchen = 'Cocina equipada';

UPDATE prueba
SET furnished_ = 'N' 
WHERE furnished_ = 'None' OR furnished_ = 'casa sin amueblar';

UPDATE prueba
SET furnished_ = 'Y' 
WHERE furnished_ = 'casa amueblada';

ALTER TABLE prueba
DROP COLUMN furnished;

/*

--After updating--

MariaDB [House_Renting]> SELECT furnished FROM prueba GROUP BY furnished;
+----------------------------------------+
| furnished                              |
+----------------------------------------+
| Cocina equipada y casa amueblada       |
| Cocina equipada y casa sin amueblar    |
| Cocina sin equipar y casa sin amueblar | 
| None                                   |
+----------------------------------------+

MariaDB [House_Renting]> SELECT equiped_kitchen, furnished_ FROM prueba WHERE idealista_id = 101033658;                          
+------------------+----------------+
| equiped_kitchen  | furnished_     |
+------------------+----------------+
| Cocina equipada  | casa amueblada |
+------------------+----------------+

MariaDB [House_Renting]> SELECT equiped_kitchen, furnished_ FROM prueba WHERE idealista_id = 101033658; 
+-----------------+------------+
| equiped_kitchen | furnished_ |
+-----------------+------------+
| Y               | Y          |
+-----------------+------------+

*/

/*

--UPDATING LOCATION--

Idea is to separate by the delimiter '/' the hole string.
And indexing each substring into three diferent columns:
'Street', 'Neightborhood' and 'District'

MariaDB [House_Renting]> SELECT location FROM prueba WHERE idealista_id = 101033658;
+-----------------------------------------------------------------------+
| location                                                              |
+-----------------------------------------------------------------------+
| Calle de Álvarez Sereix***Barrio Centro Tradicional***Distrito Centro |
+-----------------------------------------------------------------------+

*/

ALTER TABLE prueba
ADD COLUMN street VARCHAR(255),
ADD COLUMN neighborhood VARCHAR(255),
ADD COLUMN district VARCHAR(255);

UPDATE prueba 
SET street = SUBSTRING_INDEX(location, '***', 1);

UPDATE prueba 
SET neighborhood = SUBSTRING_INDEX((SUBSTRING_INDEX(location,'***', 2)),'***',-1);

UPDATE prueba 
SET district = SUBSTRING_INDEX(location, '***', -1);

UPDATE prueba
SET street = NULL
WHERE street = ''; 

ALTER TABLE prueba
DROP COLUMN location;

/*

MariaDB [House_Renting]> SELECT street, neighborhood, district from prueba idealista_id = 101033658;  
+-------------------------+---------------------------+-----------------+
| street                  | neighborhood              | district        |
+-------------------------+---------------------------+-----------------+
| Calle de Álvarez Sereix | Barrio Centro Tradicional | Distrito Centro |
+-------------------------+---------------------------+-----------------+

*/

/*

--UPDATE M2_--

We are going to separate the total square meters and the useful ones.
Some of the useful square meters data is measing so we will let it as NULL.
Also we will remove the 'm² construidos' and 'm² útiles' from both columns.
Also removing the dots (.) so avoiding compatibility problems when transforming to INT.

*/

ALTER TABLE prueba
ADD COLUMN m2_constructed VARCHAR(255),
ADD COLUMN m2_useful VARCHAR(255);

UPDATE prueba
SET m2_constructed = SUBSTRING_INDEX(m2_, ',', 1);

UPDATE prueba
SET m2_useful = SUBSTRING_INDEX(m2_, ',', -1);

UPDATE prueba
SET m2_useful = NULL
WHERE m2_constructed = m2_useful;

ALTER TABLE prueba 
DROP COLUMN m2_;

UPDATE prueba 
SET m2_constructed = SUBSTRING_INDEX(m2_constructed, ' ', 1);

UPDATE prueba 
SET m2_useful = SUBSTRING_INDEX(m2_useful, ' ', 2);

UPDATE prueba 
SET m2_constructed = REPLACE(m2_constructed, '.', '');

UPDATE prueba 
SET m2_useful = REPLACE(m2_useful, '.', '');

/*

--After updating--

MariaDB [House_Renting]> SELECT m2_constructed, m2_useful FROM prueba WHERE idealista_id = 101033658; 
+--------------------+-----------+
| m2_constructed     | m2_useful |
+--------------------+-----------+
| 140                | NULL      |
+--------------------+-----------+

*/

/*

--UPDATING GARAJE--

We eant to make a binari value out of this column.
The evident problem, is that there are more than two values.

MariaDB [House_Renting]> SELECT garaje FROM prueba GROUP BY garaje;
+-------------------------------------------+
| garaje                                    |
+-------------------------------------------+
| None                                      |
| Plaza de garaje incluida en el precio     |
| Plaza de garaje por 100 ?/mes adicionales |
| Plaza de garaje por 120 ?/mes adicionales |
| Plaza de garaje por 130 ?/mes adicionales |
| Plaza de garaje por 50 ?/mes adicionales  |
| Plaza de garaje por 60 ?/mes adicionales  |
| Plaza de garaje por 70 ?/mes adicionales  |
| Plaza de garaje por 80 ?/mes adicionales  |
| Plaza de garaje por 82 ?/mes adicionales  |
+-------------------------------------------+

It looks like some lessors offer garaje but just if the lessee pay an extra amount by month.
So it is optional.
In orther to solve this problem we decided to split each of this 'garaje optionals houses' into two houses.
One with the normal price but without garaje.
And the other with the extra amount added but with garaje.

*/
INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+100, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 100%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+120, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 120%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+130, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 130%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+50, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 50%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+60, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 60%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+70, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 70%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+80, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 80%';

INSERT INTO prueba (bedrooms, bathrooms, floor, n_price, elevator, terrace, balcony, garaje, built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful)
SELECT bedrooms, bathrooms, floor, n_price+82, elevator, terrace, balcony, 'Y', built_in_wardrobe,air_conditioning, swimming_pool, green_zone, furnished_, equiped_kitchen, street, neighborhood, district, m2_constructed, m2_useful
FROM prueba 
WHERE garaje LIKE '%por 82%';

UPDATE prueba
SET garaje = 'N'
WHERE garaje = 'None';

UPDATE prueba
SET garaje = 'N'
WHERE garaje LIKE '%por%';

UPDATE prueba
SET garaje = 'Y'
WHERE garaje = 'Plaza de garaje incluida en el precio';

/*

--After updating--

MariaDB [House_Renting]> SELECT garaje FROM prueba GROUP BY garaje; 
+--------+
| garaje |
+--------+
| N      |
| Y      |
+--------+

*/


/* 

Correcting some errors

*/

UPDATE prueba
SET swimming_pool = 'Y'
WHERE idealista_id = 101047665;