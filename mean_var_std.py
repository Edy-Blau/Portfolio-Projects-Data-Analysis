# Curso: Data Analysis with Python (FreeCodeCamp)
# Fecha: 21/10/2022
# Tema: Proyecto: mean_var_std calculator

import numpy as np

def calculate(list):
    if(len(list) < 9):
      raise ValueError("List must contain nine numbers.")
      
    # Cambio de lista a numpy array
    lst = np.array(list)
    print(lst)
  
    # Lista de promedios
    mean_rows = ([lst[[0,1,2]].mean(), lst[[3,4,5]].mean(), lst[[6,7,8]].mean()])
    mean_cols = ([lst[[0,3,6]].mean(), lst[[1,4,7]].mean(), lst[[2,5,8]].mean()])
  
    # Lista de varianzas
    var_rows = [lst[[0,1,2]].var(), lst[[3,4,5]].var(), lst[[6,7,8]].var()]
    var_cols = [lst[[0,3,6]].var(), lst[[1,4,7]].var(), lst[[2,5,8]].var()]
  
    # Lista de desviaciones estándar
    sd_rows = [lst[[0,1,2]].std(), lst[[3,4,5]].std(), lst[[6,7,8]].std()]
    sd_cols = [lst[[0,3,6]].std(), lst[[1,4,7]].std(), lst[[2,5,8]].std()]
  
    # Lista de máximos
    max_rows = [lst[[0,1,2]].max(), lst[[3,4,5]].max(), lst[[6,7,8]].max()]
    max_cols = [lst[[0,3,6]].max(), lst[[1,4,7]].max(), lst[[2,5,8]].max()]
  
    # Lista de mínimos
    min_rows = [lst[[0,1,2]].min(), lst[[3,4,5]].min(), lst[[6,7,8]].min()]
    min_cols = [lst[[0,3,6]].min(), lst[[1,4,7]].min(), lst[[2,5,8]].min()]
  
    # Lista de sumas
    sum_rows = [lst[[0,1,2]].sum(), lst[[3,4,5]].sum(), lst[[6,7,8]].sum()]
    sum_cols = [lst[[0,3,6]].sum(), lst[[1,4,7]].sum(), lst[[2,5,8]].sum()]
  
    calculations = {
        'mean': [mean_cols, mean_rows, lst.mean()],
        'variance': [var_cols, var_rows, lst.var()],
        'standard deviation': [sd_cols, sd_rows, lst.std()],
        'max': [max_cols, max_rows, lst.max()],
        'min': [min_cols, min_rows, lst.min()],
        'sum': [sum_cols, sum_rows, lst.sum()]
      }
    
    return calculations
