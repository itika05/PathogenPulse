import pandas as pd
import os

# regular samples
df = pd.read_csv("samples_input.csv")
df['sample'] = df['sample'].str.split('_L00').str[0]
df["sample"].to_list()
print(df['sample'].value_counts())

df.to_csv("samples_input.csv", index=False)

# water
df = pd.read_csv("water_input.csv")
df['sample'] = df['sample'].str.split('_L00').str[0]
df["sample"].to_list()
print(df['sample'].value_counts())

df.to_csv("water_input.csv", index=False)

# water
df = pd.read_csv("ww_input.csv")
df['sample'] = df['sample'].str.split('_L00').str[0]
df["sample"].to_list()
print(df['sample'].value_counts())

df.to_csv("ww_input.csv", index=False)
