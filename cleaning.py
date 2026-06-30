import pandas as pd
import numpy as np

def clean_column_names(df):
    """
    Column names to lowercase, replace spaces with "_",
    and rename "st" to "state".
    """
    df = df.copy()
    df.columns = df.columns.str.lower().str.replace(" ", "_")
    df.rename(columns={"st": "state"}, inplace=True)
    return df


def fix_gender_mapping(df):
    df = df.copy()

    gender_mapping = {
        "female": "F",
        "femal": "F",
        "f": "F",
        "male": "M",
        "m": "M",
    }

    df["gender"] = (
        df["gender"]
        .astype("string")
        .str.lower()
        .str.strip()
        .replace(gender_mapping)
    )

    return df



def fix_state_mapping(df):
    """
    Normalize state names to full names.
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

    df["state"] = df["state"].replace(state_mapping)
    return df


def fix_education_value(df):
    """
    Replace 'Bachelors' with 'Bachelor' in education column.
    """
    df = df.copy()
    df["education"] = df["education"].replace("Bachelors", "Bachelor")
    return df


def clean_customer_lifetime_value(df):
    """
    Remove % from customer_lifetime_value.
    """
    df = df.copy()
    df["customer_lifetime_value"] = (
        df["customer_lifetime_value"]
        .astype(str)
        .str.replace("%", "", regex=False)
    )
    return df


def fix_vehicle_mapping(df):
    """
    Replace specific vehicle classes with 'Luxury'.
    """
    df = df.copy()
    df["vehicle_class"] = df["vehicle_class"].replace({
        "Sports Car": "Luxury",
        "Luxury SUV": "Luxury",
        "Luxury Car": "Luxury"
    })
    return df


def convert_column_type_to_float(df):
    """
    Convert customer_lifetime_value column to float.
    """
    df = df.copy()
    df["customer_lifetime_value"] = df["customer_lifetime_value"].astype("float64")
    return df


def extract_open_complaints(df, column_name="number_of_open_complaints"):
    """
    Extract the middle value from formats like '1/5/00' -> 5.
    Preserves missing values as NaN.
    """
    df = df.copy()

    def extract_middle_value(value):
        if pd.isna(value):
            return np.nan
        parts = str(value).split("/")
        return int(parts[1]) if len(parts) == 3 else int(parts[0])

    df[column_name] = (
        df[column_name]
        .apply(extract_middle_value)
        .astype(float)
    )
    return df


def drop_all_null_rows(df):
    """
    Drop rows where all values are null.
    """
    df = df.copy()
    df = df.dropna(how="all")
    return df


def clean_data(df):
    """
    Run the full cleaning pipeline.
    """
    df = clean_column_names(df)
    df = fix_gender_mapping(df)
    df = fix_state_mapping(df)
    df = fix_education_value(df)
    df = clean_customer_lifetime_value(df)
    df = fix_vehicle_mapping(df)
    df = convert_column_type_to_float(df)
    df = extract_open_complaints(df)
    df = drop_all_null_rows(df)
    return df
