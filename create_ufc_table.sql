-- Drop existing tables
DROP TABLE IF EXISTS fight_data;
DROP TABLE IF EXISTS ufc_country;
DROP TABLE IF EXISTS ufc_weight_class;

-- Recreate tables
CREATE TABLE ufc_country (
    country_code VARCHAR(10) PRIMARY KEY,
    country_name VARCHAR(255)
);

CREATE TABLE ufc_weight_class (
    weight_class VARCHAR(10) PRIMARY KEY,
    weight_class_name VARCHAR(50)
);

CREATE TABLE fight_data (
    R_fighter VARCHAR(255),
    B_fighter VARCHAR(255),
    R_odds INTEGER,
    B_odds INTEGER,
    R_ev FLOAT,
    B_ev FLOAT,
    date DATE,
    location VARCHAR(255),
    country_code VARCHAR(10),
    FOREIGN KEY (country_code) REFERENCES ufc_country (country_code),
    Winner VARCHAR(255),
    title_bout BOOLEAN,
    weight_class VARCHAR(10),
    FOREIGN KEY (weight_class) REFERENCES ufc_weight_class (weight_class),
    gender VARCHAR(50),
    no_of_rounds INTEGER,
    B_losses INTEGER,
    B_wins INTEGER,
    B_Stance VARCHAR(50),
    B_Height_cms FLOAT,
    B_Reach_cms FLOAT,
    B_Weight_lbs INTEGER,
    R_losses INTEGER,
    R_wins INTEGER,
    R_age INTEGER,
    B_age INTEGER,
    total_fight_time_secs FLOAT,
    R_Stance VARCHAR(50),
    R_Height_cms FLOAT,
    R_Reach_cms FLOAT,
    R_Weight_lbs INTEGER,
    City VARCHAR(255),
    State VARCHAR(255)
);
