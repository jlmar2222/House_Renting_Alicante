#For structural reason we want at most trhee location values: street, neighborhood and district.
#Some houses add the 'urbanización', we don't want it. So we will get rid of it through this script.

import csv
import re 
import os 
        
regex = r"\*{3}Urb\.(.*?)(?=\*{3})"

with open(r'C:\Users\jlmar\OneDrive\Escritorio\House_Renting_Alicante\h_rentings.csv', mode='r', encoding='utf-8') as input_file:
    
    with open('output_file.csv', mode='w', newline='',encoding='utf-8') as output_file:
        
        reader = csv.reader(input_file, delimiter=';')
        writer = csv.writer(output_file, delimiter = ';')
    
        for row in reader:

            try:
                if re.search(regex, row[6]):
                    row[6] = re.sub(regex,'',row[6])
        
                writer.writerow(row)
            except:
                continue


