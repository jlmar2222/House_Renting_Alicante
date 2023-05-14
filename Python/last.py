# After creating the las csv file we need to change some details,
# in order to prevent some compatibility problems.

import os 


# Change the '\N' for 'NULL' 

columns = '"idealista_id";"bedrooms";"bathrooms";"floor";"elevator";"terrace";"balcony";"garaje";"built_in_wardrobe";"air_conditioning";"swimming_pool";"green_zone";"price";"furnished";"equiped_kitchen";"street";"neighborhood";"district";"m2_builded";"m2_habitable"'

with open('individual.csv' , 'r', encoding='utf-8') as file:

    file = ''.join([i for i in file]).replace(r"\N", "NULL")

    with open('Alicante_individual.csv' , 'w', encoding='utf-8') as new_file:

        #Write headers
        new_file.writelines(f'{columns}\n')

        #Write rest of the rows
        new_file.writelines(file)


if os.path.exists('output_file.csv'):
    os.remove('output_file.csv')

if os.path.exists('individual.csv'):
    os.remove('individual.csv')

        

