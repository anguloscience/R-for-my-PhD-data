# R-for-my-PhD-data
R scripts that I have written to analyse my datasets, make graphics, and organize my data.

###### Output example: ggplot graphics - PWs vs LnCS

![PW_1](https://user-images.githubusercontent.com/80077181/159200750-429f360e-a372-426f-bf40-49841dd1dc49.jpeg)


newMedians file:
Calculating new medians for .fcsv files obtained using 7 different templates in 3D Slicer - MALPACA module. 
Input: medians + 7csv files (1 for each template)
Output: 1 .fcsv file with the new calculated medians (after anaizing outliers)
Packages used: "SlicerMorphR", "dplyr", "readxl", "janitor", "tidyverse"
