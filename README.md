# Coding for Data Science Project: A shiny app to visualize VACCINATION CAMPAIGN against SARS-CoV-2
### Andrea Pio Cutrera - Matriculation Number: 965591

This is a shiny app that makes an easy visualization of the **Vaccination Campaign against SARS-CoV-2** in Italy started in 27-12-2020.
The App scrapes data from the open repository of the **Civil Protection Department of Italy** (<https://github.com/italia/covid19-opendata-vaccini>), which makes a daily update of detailed data at regional level.
There are three sections accessible in the upper panel, and they are in order from the left to the right:
### Section 1 - Age Ranges
In the upper left part of the page, there is a side bar panel from which you can select:
- the Region of interest
- the particular Vaccine dose (_Pfizer/BionTech - VaxRevia-(AstraZeneca) - Moderna_)
Once selected, a plot of the distribution between the Age Range is given in output.
### Section 2 - Best Regions
Here you can select the number of best-scoring Regions in doses usage, and an ordered bar chart in output describe the percentages of doses used on patients as a share of the total doses received.
### Section 3 - Analysis
Here you can visualize an interactive pie chart in which you can select:
- the Region of interest
- the particular Vaccine dose (_Pfizer/BionTech - Vaxzevria (AstraZeneca) - Moderna_)
- the age range
Percentages of doses, split between men and woman, are plotted in a pie chart.
### How to run the Application
#### Specific commands
In order to run this app there are some **requirements**. 
```R
requirements <- c("shiny", "shinythemes", "ggplot2", "plotly", "highcharter")
```
If you have NOT already installed them, run the following code lines to install them on your local device:
```R
requirements <- c("shiny", "shinythemes", "ggplot2", "plotly", "highcharter")
install.packages(requirements)
```
Once installed, you have all you need to make the app to work on your local pc; 
Execute the following line on your console to run the app:
```
shiny::runGitHub("shiny_app", "andreacutrera", ref="main")
```









