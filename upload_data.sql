COPY ufc_country 
FROM 'D:\SAJAL\new_project\UFC_data_analysis\CSV_files\country_codes.csv' 
DELIMITER ',' CSV HEADER;



COPY ufc_weight_class 
FROM 'D:\SAJAL\new_project\UFC_data_analysis\CSV_files\weight_class_codes.csv' 
DELIMITER ',' CSV HEADER;



COPY fight_data 
FROM 'D:\SAJAL\new_project\UFC_data_analysis\CSV_files\UFC.csv' 
DELIMITER ',' CSV HEADER;
