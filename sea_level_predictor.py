# Curso: Data Analysis with Python (FreeCodeCamp)
# Fecha: 24/10/2022
# Tema: Proyecto: sea_level_predictor

import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import linregress

def draw_plot():
    # Read data from file
    df = pd.read_csv("epa-sea-level.csv")
    x = df["Year"]
    y = df["CSIRO Adjusted Sea Level"]

    # Create scatter plot
    fig, ax = plt.subplots()
    plt.scatter(x, y)

    # Create first line of best fit
    reg_mod = linregress(x, y)
    x_pred = pd.Series([i for i in range(1880, 2051)])
    # Ec. de la recta: y = mx + b
    y_pred = reg_mod.slope * x_pred + reg_mod.intercept
    plt.plot(x_pred, y_pred, "b")
  
    # Create second line of best fit
    df2 = df.loc[df["Year"] >= 2000]
    x2 = df2["Year"]
    y2 = df2["CSIRO Adjusted Sea Level"]
    reg_mod2 = linregress(x2, y2)
    x_pred2 = pd.Series([i for i in range(2000, 2051)])
    y_pred2 = reg_mod2.slope * x_pred2 + reg_mod2.intercept
    plt.plot(x_pred2, y_pred2, "r")
  
    # Add labels and title
    ax.set_xlabel("Year")
    ax.set_ylabel("Sea Level (inches)")
    ax.set_title("Rise in Sea Level")
    
    # Save plot and return data for testing (DO NOT MODIFY)
    plt.savefig('sea_level_plot.png')
    return plt.gca()