
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

"""
Hello Kart, you need to modify the line 17, to replace the 'your_file' with the path to your data file.
And you need to modify line 43, to replace the 'your_metric_name' with the name of the metric you want to plot.

"""



### Read the data
# import all metrics. If your data file is not excel, you can change it to `pd.read_csv`, or other formats
all_metrics = pd.read_excel('your_file', sheet_name='Sheet1')


# define a function to plot
def violin_plotting(data, x, y):
    """
    Parameters:
        data: the dataframe you imported
        x: the column name of the x-axis (e.g. 'group')
        y: the column name of the y-axis (e.g. 'metric1')
    """
    # Set the figure size
    plt.figure(figsize=(15, 10), dpi=100)
    # Plot the violinplot
    sns.violinplot(data = data, x=x, y = y, inner=None, bw=.4, linewidth=3, alpha = 1)
    # Also plot individual points
    sns.stripplot(data = data, x=x, y=y, edgecolor="black", linewidth=2, alpha = 0.7, zorder=1)
    # Set x-labels to the group names
    plt.xticks(ticks=range(len(data.group.unique())), labels=data.group.unique())
    # I will also plot the mean value for each group
    sns.pointplot(data=data, x = x, y=y, estimator=np.mean, color="red", errorbar = None, join=True, linestyles='--', markers='s')
    # Show the plot
    plt.show()


violin_plotting(all_metrics, 'group', "your_metric_name")