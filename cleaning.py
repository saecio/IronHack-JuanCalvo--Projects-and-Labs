import pandas as pd
import numpy as np

def clean_column_names (df):
    """
    column names to lowercase, replaces spaces per "_" and the column "st" is changed per "state" one
    """
    df = df.copy()
    df.columns = df.columns.str.lower().str.replace(" ", "_")
    df.rename(columns={"st": "state"}, inplace=True)
    return df

def fix_gender_mapping (df):
    """
    There are several values in column gender. This one replaces all values per M or F
    """
    df = df.copy()
    gender_mapping = {
    "female": "F",
    "femal": "F",
    "male": "M",
    "f": "F",
    "m": "M"}
    df["gender"] = (
    df["gender"]
    .str.strip()          # remove spaces
    .str.lower()          # normalize case
    .map(gender_mapping)  # standardize
    )
    return df

def fix_state_mapping(df):
    """
    There are several values in column state. This one normalizes it into long names. i.e.: California instead of Cali or CA
    """
    df = df.copy()
    state_mapping = {
    "WA": "Washington",
    "AZ": "Arizona",
    "Cali": "California",
    "Washington": "Washington",
    "California": "California",
    "Arizona": "Arizona",
    "Oregon": "Oregon",
    "Nevada": "Nevada"
    }

    # Use map() with fillna() to keep original values when no mapping exists
    df["state"] = (
        df["state"]
        .map(state_mapping)
        .fillna(df["state"])  # Keep original if not in mapping
        )
    return df

def fix_education_value (df):
    """
    In education, "Bachelors" could be replaced by "Bachelor"
    """
    df = df.copy()
    df["education"] = df["education"].replace("Bachelors","Bachelor")
    return df

def customer_lifetime_value (df):
    """
    Deletes the % character
    """
    df = df.copy()
    df["customer_lifetime_value"] = (
    df["customer_lifetime_value"]
    .str.replace("%", "", regex=False)
    )
    return df

def fix_vehicle_mapping(df):
    """
    "Sports Car", "Luxury SUV" and "Luxury Car" are replaced by "Luxury"
    """
    df = df.copy()
    df["vehicle_class"] = df["vehicle_class"].replace(
    {"Sports Car": "Luxury",
     "Luxury SUV" : "Luxury",
     "Luxury Car": "Luxury"}
    )
    return df

def convert_column_type_to_float(df):
    df = df.copy()
    df['customer_lifetime_value'] = df['customer_lifetime_value'].astype('float64')
    print(f"Customer_lifetime_value column is now {df['customer_lifetime_value'].dtype}")
    return df

def extract_open_complaints(df, column_name='number_of_open_complaints'):
    """
    Extract the middle value from the column.
    Format: '1/5/00' -> 5.
    Preserves missing values as NaN.
    """
    df = df.copy()
    
    def extract_middle_value(value):
        if pd.isna(value):
            return float('nan')
        parts = str(value).split('/')
        return int(parts[1]) if len(parts) == 3 else int(parts[0])
    
    df[column_name] = (
        df[column_name]
        .apply(extract_middle_value)
        .astype(float)
    )
    return df

def drop_all_null_rows(df):
    """
    Drop rows where ALL values are null.
    """
    df = df.copy()
    
    # Check how many rows are all-null
    all_null_count = df.isna().all(axis=1).sum()
    print(f"Found {all_null_count} rows with all null values")
    
    # Drop them
    df = df.dropna(how='all')
    
    print(f"Shape after dropping all-null rows: {df.shape}")
    return df
