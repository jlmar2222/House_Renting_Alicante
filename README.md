# House Renting in Alicante

The core of this project is to get a dataset based on the real state portal 'idealista.com'.
(This main data is in the 'Alicante_individual.csv' file)

We also show some further research. 

## Data Base

Columns:

id => Our auto increment Primary Key.

idealista_id => the “idealista.com” house identifier. 

m2_builded => total square meters of the house.

m2_habitable => square meters of the house that are habitable.

bedrooms => number of bedrooms.

bathrooms => number of bathrooms.

floor => the number of the floor in which the house is.

price => the actual price.

street => the street where it is.

neighborhood => the neighborhood where it is.

district => the district where it belongs.

The rest of the variables are binaries; the two possible values are “Y” or “N”.
That would manifest if the house does or does not have it.

terrace, balcony, garaje, built_in_wardrobe, air_conditioning, swimming_poll, green_zone, furnished, equiped_kitchen


## Do the research

As we mention we let the 'Alicante_individual.csv' file so you can start working on it.
The Vis.ipynb file is a jupyter notebook with some examples of graphs coded with the matplotlib librarie.
We also let in the 'img' directory some of the pictures of this graphs.

## IN CASE YOU ARE INTERESTED IN GETTING YOURSELF THE DATA 

### Prerequisites

Almost the hole project runs in Python, although the CRUD part is in SQL.

So the external Python libraries that we'll be using are the following:

- Selenium
- Undetected Chromedriver
- Pandas
- Matplotlib

### Steps to follow 

In orhter to get the clean csv file with the data you must run the program in the next order:

- Python/Spider.py
- Python/rid_of_urb.py
- SQL/DB_creation.sql
- SQL/prueba.sql
- SQL/Updates.sql
- SQL/create_csv.sql
- SQL/individual.sql (optional; in case you want in your SQL DB)
- Python/last.py


### WARNING


The Spider.py script is a really slow one and requires some action from your part. 
This is because idealista.com has some security measures against the web scrapping.
In orther to bypass them we need to make the 'page surfing' quit slower,
feel free to adjust the time parameters if you think a faster way is possible without getting to much detected. 

Also in order to idealista not to detect you as a bot we needed to log in with our browser account.
So make sure to customize the 'profile' ,'path_to_User_Data' and the 'path_to_driver' variables.

But all of this is not enough and a few captcha will pop, just make sure to solve them (you as a human). 





