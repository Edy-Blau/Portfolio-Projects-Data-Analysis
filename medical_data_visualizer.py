# Curso: Data Analysis with Python (FreeCodeCamp)
# Fecha: 24/10/2022
# Tema: Proyecto: medical_data_visualizer

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Import data
df = pd.read_csv("medical_examination.csv")

# Add 'overweight' column
ovw = (df["weight"] / ((df["height"] / 100) ** 2 ) > 25).astype(int)
df['overweight'] = ovw

# Normalize data by making 0 always good and 1 always bad. If the value of 'cholesterol' or 'gluc' is 1, make the value 0. If the value is more than 1, make the value 1.
df.loc[df["cholesterol"] == 1, "cholesterol"] = 0
df.loc[df["cholesterol"] > 1, "cholesterol"] = 1
df.loc[df["gluc"] == 1, "gluc"] = 0
df.loc[df["gluc"] > 1, "gluc"] = 1

# Draw Categorical Plot
def draw_cat_plot():
    # Create DataFrame for cat plot using `pd.melt` using just the values from 'cholesterol', 'gluc', 'smoke', 'alco', 'active', and 'overweight'.
    df_cat = pd.melt(df, id_vars = ["cardio"], value_vars = ['cholesterol', 'gluc', 'smoke', 'alco', 'active', 'overweight'])

    # Group and reformat the data to split it by 'cardio'. Show the counts of each feature. You will have to rename one of the columns for the catplot to work correctly.
    df_cat["total"] = 1
    df_cat = df_cat.groupby(["cardio", "variable", "value"], as_index = False).count()
    
    # Draw the catplot with 'sns.catplot()'
    fig = sns.catplot(x = "variable", y = "total", data = df_cat, hue = "value", kind = "bar", col = "cardio").fig

    # Do not modify the next two lines
    fig.savefig('catplot.png')
    return fig


# Draw Heat Map
def draw_heat_map():
    # Sección basada en: https://replit.com/@HoracioRomo/boilerplate-medical-data-visualizer-4#medical_data_visualizer.py
    ap_mask = df['ap_lo'] <= df['ap_hi']
    ht_mask = (df['height'] >= df['height'].quantile(0.025)) & (df['height'] <= df['height'].quantile(0.975))
    wt_mask = (df['weight'] >= df['weight'].quantile(0.025)) & (df['weight'] <= df['weight'].quantile(0.975))
    clean_mask = ap_mask & ht_mask & wt_mask
    df_heat = df[clean_mask]
    corr = df_heat.corr()
    mask = np.zeros_like(corr)
    mask[np.triu_indices_from(mask)] = True
    fig, ax = plt.subplots(figsize=(12, 12))
    graph = sns.heatmap(corr,
                        center=0,
                        mask=mask,
                        annot=True,
                        square=True,
                        fmt=".1f",
                        vmax=0.30,
                        linewidths=1,
                        linecolor='white',
                        cbar_kws={'shrink': 0.5})
    cbar = graph.collections[0].colorbar
    cbar.set_ticks(np.linspace(-0.08, 0.24, 5))
    fig = graph.figure

    # Do not modify the next two lines
    fig.savefig('heatmap.png')
    return fig