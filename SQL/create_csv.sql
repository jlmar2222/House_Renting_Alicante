USE House_Renting;

SELECT * INTO OUTFILE 'C:/Users/jlmar/OneDrive/Escritorio/House_Renting_Alicante/individual.csv'
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM prueba;

