# Coding for Data Science Project: A shiny app to visualize VACCINATION CAMPAIGN
### Andrea Pio Cutrera - Matriculation Number: 965591

This is a shiny app that makes an easy visualization of the **Vaccination Campaign** in Italy.
The App scrapes data from the open repository of the **Civil Protection Department of Italy** (<https://github.com/italia/covid19-opendata-vaccini>).

In the upper left part of the page, there is a side bar panel which allows to select the _Region_ of interest and the particular _Vaccine_.
Once selected, a plot of the distribution between the _Age Range_ is given in output.

```
shiny::runGitHub("shiny_app", "andreacutrera", ref="main")
```



--
title: "Coding for Data Science Project: A shiny app to visualize VACCINATION CAMPAIGN"
author: "Andrea Pio Cutrera - 965591"
date: "4/9/2021"
output: pdf_document
---

## Shiny App for Vaccinations

This is a shiny app that makes an easy visualization of the **Vaccination Campaign in Italy**. The App scrapes data from the open repository of the **Civil Protection Department of Italy** (<https://github.com/italia/covid19-opendata-vaccini>).
There are three sections:

## Section 1 - Age Ranges
### In the upper left part of the page, there is a side bar panel from which you can select:
- the Region of interest;
- the particular Vaccine dose (Pfizer/BionTech)
Once selected, a plot of the distribution between the Age Range is given in output.

##  Section 2 - Best Regions
### Here you can select the number of best-scoring Regions in doses usage
Possibility to choose the *number of Regions* to plot.
An ordered bar chart describe the percentages of doses used on patients as a share of the total doses received.

## Section 3 - Analysis
### Here you can visualize an interactive pie chart
After having selected:
- the Region
- the dose of Vaccine
- the age range
Percentages of doses split between men and woman are plotted in a pie chart.


## How to run the Application
### Specific commands
In order to run this app there are some requirements. If you have not already installed them run the following code lines:
```R
requirements <- c("shiny", "shinythemes", "ggplot2", "plotly", "highcharter")
install.packages(requirements)
```
Once installed, you have all you need to make the app to work on your local pc; 
Execute the following line of code to run the app:
```R
shiny::runGitHub("shiny_app", "andreacutrera", ref="main")
```
