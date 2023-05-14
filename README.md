# House Renting in Alicante

The core of this project is to get a data set based on the real state portal 'idealista.com'.
(This main data is in the 'Alicante_individual.csv' file)

We also show some further research. 

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

We have added a virtual enviroment in the 'env' directory in case you need it.
In orther to start it you have to run the env/Scripts/activate programe. 

### Steps to follow 

In orhter to get the clean csv file with the data you must run the program in the next order:

- 1) Python/Spider.py
- 2) Python/rid_of_urb.py
- 3) SQL/DB_creation.sql
- 4) SQL/prueba.sql
- 5) SQL/Updates.sql7
- 6) SQL/individual.sql
- 7) SQL/create_csv.sql
- 8) Python/last.py


### WARNING


The Spider.py script is a really slow one and requires some action from your part. 
This is because idealista.com has some security measures against the web scrapping.
In orther to bypass them we need to make the 'page surfing' quit slower,
feel free to adjust the time parameters if you think a faster way is possible without getting to much detected. 

Also in order to idealista not to detect you as a bot we needed to log in with our browser account.
So make sure to customize the 'profile' ,'path_to_User_Data' and the 'path_to_driver' variables.

But all of this is not enough and a few captcha will pop, just make sure to solve them (you as a human). 





