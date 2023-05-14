import undetected_chromedriver as uc
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time
import random
import numpy as np
import pandas as pd
import os 


#SELENIUM SET UP

options = Options()

    #Oppening the automated browser from your real google chrome account
    
profile = 'chose_profile'
path_to_User_Data = 'C:/Users/user/AppData/Local/Google/Chrome/User Data/'

options.add_argument(f'--profile-directory={profile}') 
options.add_argument(f'--user-data-dir={path_to_User_Data}')

    #Select chrome driver path, and options
path_to_driver = 'C:/Users/user/Downloads/chromedriver_win32/chromedriver.exe'
driver = uc.Chrome(executable_path=path_to_driver, options=options)

#WEB SCRPPING


#Functions

def get_list(xpath):

    elemento1 = driver.find_elements(By.XPATH, xpath)
    lista = []

    for e in elemento1:
        lista.append(e.text)
    
    return lista



#Get number of pages

driver.get('https://www.idealista.com/alquiler-viviendas/alicante-alacant-alicante/')
houses = int(driver.find_element(By.XPATH, '//*[@id="main"]/div/div[1]/ul/li[4]/span[3]').text)

n_pages = int(houses/30)

    #If the division is not exact it means there is a one more page with less than 30 houses,
    #we need to take this page too.
if houses%30 != 0:
    n_pages = int(n_pages + 1)



#Getting the hauses ids

id_s = []

for n in range(1,n_pages+1):

    driver.get(f'https://www.idealista.com/alquiler-viviendas/alicante-alacant-alicante/pagina-{n}.htm')

        #Wait, making harder for the web page to detect us a boot.
    n_r = random.randint(5,10)
    time.sleep(n_r)

    raw = driver.find_elements(By.XPATH, '//*[@id="main-content"]/section[1]//div/a')

    lista = []
    sublista =  []
    elements = []

    # getting the <a href="/inmueble/101333672/" </a>
    for r in raw:
        lista.append(r.get_attribute('href')) 

    try:
        #dividing by '/' 
        for l in lista:
            sub = l.split('/')
            sublista.append(sub)

        #filtering the none ids href and selecting the id = 101333672
        #[https:, , www.idealista.com, inmueble, 101333672, ]
        for s in sublista:      
            if len(s) == 6:
                elements.append(s[4])
    except:
        continue 

    id_s.append(elements)


#Creating the ids list

almost_list = []

    #Now we have a list of list of id nubres, divided by pages
    #We create a unique list
for id in id_s: 
    for n in range(len(id)):
        almost_list.append(id[n])

    #Rejecting duplicates  ids 
id_list = np.unique(almost_list)


#Actuall Scrapping

for number in id_list:
    
    #Setting lists

    id = []
    m_2 = []
    bedrooms = []
    bathrooms = []
    floor = []
    price = []
    c_location = []
    elevator = []
    terrace = []
    balcony = []
    garaje = []
    built_in_wardrobe = []
    furnished = []
    air_conditioning = []
    swimming_pool = []
    green_zones = []

    
    columns = [id, m_2, bedrooms, bathrooms, floor, price, c_location, elevator,
                terrace, balcony, garaje, built_in_wardrobe,
                furnished, air_conditioning, swimming_pool, green_zones]

    try :

        driver.get(f'https://www.idealista.com/inmueble/{number}/')
        
            #Wait, making harder for the web page to detect us a boot.
        n_r = random.randint(6,10)
        time.sleep(n_r)

            #We get the html data by the Xpath method.
            #There are diferrents modes of pages, this solution embrace all of them.
        
        basico = get_list('//*[@id="details"]/div[4]/div[1]/div[1]/ul/li')
        basico2 = get_list('//*[@id="details"]/div[3]/div[1]/div[1]/ul/li')
        basico3 = get_list('//*[@id="details"]/div[5]/div[1]/div[1]/ul/li')

        edificio = get_list('//*[@id="details"]/div[4]/div[1]/div[2]/ul/li')
        edificio2 = get_list('//*[@id="details"]/div[5]/div[1]/div[2]/ul/li')
        edificio3 = get_list('//*[@id="details"]/div[3]/div[1]/div[2]/ul/li')
                
        equipamiento = get_list('//*[@id="details"]/div[4]/div[2]/div[1]/ul/li')
        equipamiento2 = get_list('//*[@id="details"]/div[5]/div[2]/div[1]/ul/li')
        equipamiento3 = get_list('//*[@id="details"]/div[3]/div[2]/div[1]/ul/li')

        precio = get_list('//*[@id="mortgages"]/div[2]/div/article/section/p[1]/strong')
        location = get_list('//*[@id="headerMap"]/ul/li')

            #We create a single list with all the information
        mains = basico + basico2 + basico3 + edificio + edificio2 + edificio3 + equipamiento + equipamiento2 + equipamiento3 + precio


            #Lists Fill
        
                #ids
        id.append(number)

                #Main features 
        for main in mains:          
           
            #We kind of separate by words, in order to make the key words search
            sub = main.split(' ')
            
                #No we filter all the list and get the data based on a bunch of key works.
                #(Look how is the 'idealista.com' houses presentation for more details)
            for n in range(len(sub)):
                
                if sub[n] in ['construidos,' , 'construidos']:
                    m_2.append(main)
                    break
                elif sub[n] in ['habitacion', 'habitación', 'habitacioneses', 'Habitación', 'Habitaciones']:
                    bedrooms.append(main)
                    break
                elif sub[n] in ['baño', 'baños', 'Baño', 'Baños']:
                    bathrooms.append(main)
                    break
                elif sub[n] in ['Amueblado', 'Amueblada','amueblada', 'cocina', 'Cocina', 'amueblar']:
                    furnished.append(main)
                    break      
                elif sub[n] in ['Garaje', 'garaje']:
                    garaje.append(main)
                    break   
                elif sub[n] in ['terraza', 'Terraza']:
                    terrace.append(main)
                    break 
                elif sub[n] in ['Balcon', 'balcon', 'Balcón', 'balcón']:
                    balcony.append(main)
                    break
                elif sub[n] in ['Armario', 'armario', 'Armarios', 'armarios']:
                    built_in_wardrobe.append(main)
                    break
                elif sub[n] in ['Planta','planta', 'Bajo', 'Entreplanta']:
                    floor.append(main)
                    break
                elif sub[n] in ['Con','con']:
                    elevator.append(main)
                    break
                if sub[n] in ['piscina', 'Piscina']:
                    swimming_pool.append(main)
                    break
                elif sub[n] in ['Zonas', 'verdes']:
                    green_zones.append(main)
                    break
                elif sub[n] in ['Aire', 'aire', 'acondicionado']:
                    air_conditioning.append(main)
                    break
                elif sub[n] in ['€/mes']:
                    price.append(main)
                    break
                
                else: 
                    continue

                #Location list
        location.pop()
        location.pop()
        ub = '***'.join(location)
        c_location.append(ub)
        

        #Fill blanks with 'None'

        for column in columns:
            if not column:
                column.append('None')


        #Creating the dictionary

        h_rentings = {
            
            'id' : id,
            'm_2' : m_2,
            'bedrooms' : bedrooms,
            'bathrooms' : bathrooms,
            'floor' : floor,
            'price' : price,
            'location' : c_location,
            'elevator' : elevator,
            'terrace' : terrace,
            'balcony' : balcony,
            'garaje' : garaje,
            'built_in_wardrobe' : built_in_wardrobe,
            'furnished' : furnished,
            'air_conditioning' : air_conditioning,
            'swimming_pool' : swimming_pool,
            'green_zones' : green_zones,    
        }
        
        
        #Creating the database

        df = pd.DataFrame(h_rentings)

        #Printing in a csv file

        if os.path.exists('h_rentings.csv'):
        
            df.to_csv('h_rentings.csv', sep=';',mode='a', header = False, index=False)

        
        else:

            df.to_csv('h_rentings.csv', sep=';', index=False)
    
    except:
        continue


driver.quit()    