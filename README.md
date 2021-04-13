## Coding for Data Science Project: A shiny app to visualize VACCINATION CAMPAIGN against SARS-CoV-2 in Italy
#### Andrea Pio Cutrera - Matriculation Number: 965591

This is a _Shiny App_ that makes an easy visualization of the **Vaccination Campaign** against **SARS-CoV-2** in Italy started in `27-12-2020`.
The App scrapes data from the open repository of the **Civil Protection Department of Italy** (<https://github.com/italia/covid19-opendata-vaccini>), which makes a daily update of detailed data at regional level.

There are three sections accessible in the upper panel, and they are named (in order from the left to the right): `Age Ranges`, `Best Regions` and `Analysis`.

### Section 1 - Age Ranges

In this section in the upper left part of the page, there is a side bar panel from which you can select:
- the Region of interest (`19 Regions` and `2 Autonomous Provinces`)
- the particular Vaccine dose (`Pfizer/BionTech` - `VaxRevia-(AstraZeneca)` - `Moderna`)
- the variable of interest (absolute numbers of `Males`, `Females`, `First Doses`, `Second Doses`)

The output plot shows the absolute numbers of vaccine doses submitted in the last day of update (update occurs usually at 05:00 p.m. ...)in the group ages from `16` to `90+`.

### Section 2 - Best Regions
Here you can select the number of `best-scoring Regions` in doses usage, and an ordered bar chart in output describes the percentages of doses used on patients as a share of the total doses received.

### Section 3 - Analysis
Here you can visualize an interactive pie chart in which you can select:
- the Region of interest
- the particular Vaccine dose (_Pfizer/BionTech - Vaxzevria (AstraZeneca) - Moderna_)
- the age range

Percentages of doses, split between `Men` and `Women`, are plotted in a pie chart.

### How to run the Application
#### Specific commands
In order to run this app execute the following line on your console:
```
shiny::runGitHub("shiny_app", "andreacutrera", ref="main")
```
### References
- <https://www.who.int/emergencies/diseases/novel-coronavirus-2019>
- <https://www.who.int/health-topics/vaccines-and-immunization#tab=tab_1>
- <https://www.ema.europa.eu/en/human-regulatory/overview/public-health-threats/coronavirus-disease-covid-19/treatments-vaccines/vaccines-covid-19/covid-19-vaccines-key-facts>
- <https://www.iss.it/vaccini-covid-19>








