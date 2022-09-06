# Data-Visualisation-in-R
Visualisation of world energy consumption dataset using R Shiny Dashboard. 
The visualisation for this data was performed using R programming language version 4.1.1, implementing a Shiny application dashboard.


**Introduction**

Energy as a form is extremely significant in today's world for all human needs. Everything takes energy in some form or another, from powering our homes to moving around in automobiles. If the globe is without energy for a day, it might have disastrous consequences.

The aim of this project is to look through the world's energy data and visualise the key takeaways in order to get valuable insights.


**Introduction to the datasets**

**Primary Dataset**
The primary dataset used in this dashboard is World Energy Consumption from Kaggle which is a collection key metrics from our world in data. The dataset comprises 122 variables that detail the different types of energy produced and consumed by different countries over the last century.
Only a few variables are utilized in this visualisation, and only data from 1970 to 2015 was investigated.

**Secondary datasets**
The analysis depends on two secondary datasets: one that has per capita carbon-dioxide emission statistics for each country during the last five decades, and the other that contains information on country and continent mapping.



**Dashboard Structure**

**Home Page**
The home screen provides few interesting datapoints, in the form of info box, from the data set that the dashboard was developed upon like number of countries, total world population, CO2 emission level excreta.


![](Images/HomeScreen.png)

**Tab 1**

The potential of a country to grow is largely determined by how well it is energised, and how self-sufficient it is in terms of energizing its citizens homes, industries excreta. “A 1% increase in energy consumption increases real GDP by 0.59%”. 

The first graph is an interactive scatter plot between per capita GDP and get capita energy consumption of the past five decades. The time-series representation proves the point of the dependency between the variables.
The plot 2 is a static scatter plot visualising the same variables country-wise.

![](Images/Tab1.png)


**Tab 2**

Detail about the total energy consumption by different countries, this is visualised by treemaps. Treemaps are used for representing hierarchal data of multiple datapoints. It comprises of two graphs, one showing overall energy consumption of various countries and the other showing per capita energy consumption of the same countries. 
The continent is the initial layer in the Treemap, with countries inside. The size of the square indicates the country's population, and the colour of the square symbolizes energy usage, along with a numerical figure.

![](Images/Tab2.png)


**Tab 3**

Fossil and renewable are two types of energy sources, with fossil being the most used and renewable is what the world is thriving to move towards in the future.
Two subtabs visualised the same in a world-wide and country wise view. Heatmaps are used to represent the data, the X axis depicts the year and Y countries. The colour of the colour variation shows the energy consumption in kWh. If any region within the heatmap is selected that are is sub plotted in the next box and if any cell is selected the detail of the cell is highlighted in the next box.

![](Images/Tab3.png)


**Tab 4**

First, a scatter plot depicts the annual change in the forms of energy, followed by pie chart that explains the distribution of energy.

![](Images/Tab4.png)


**Tab 5**

The CO2 emissions are visualized in a geographical map in this section of the dashboard. The CO2 emission level is represented by the colour of the country, while the population size is shown by the size of the bubbles, which hold numerical details of population and energy per capita. The interactive mode also allows you to choose the year and specifically a specific continent.

The graph implies that some parts of the world are reducing their carbon footprint at a faster rate than others, which can be linked to the adoption of renewable energy sources. CO2 emissions must be lowered in order to meet the historic Paris climate pact's core goal of "limiting global warming to well below 2°C."

![](Images/Tab5.png)


**Tab 6**

The future of energy is shifting toward renewables, with solar playing a significant part. In this page videos are embedded in the Shiny Dashboard, one of which features Elon Musk outlining the importance of solar about a decade ago, and the other of which features the world's largest solar power plant.

![](Images/Tab7.png)
