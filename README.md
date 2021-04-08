# shiny_app
## Andrea Pio Cutrera - Matriculation Number: 965591

This is a shiny app that makes an easy visualization of the _Vaccination Campaign_ in Italy.
The APP scrapes data from the open repository of the Civil Protection Department of Italy (https://github.com/italia/covid19-opendata-vaccini).

In the upper left part of the page, there is a side bar panel which allows to select the _Region_ of interest and the particular _Vaccine_.
Once selected, a plot of the distribution between the _Age Range_ is given in output.

'''R
shiny::runGitHub("shiny_app", "andreacutrera", ref="main")
'''R
