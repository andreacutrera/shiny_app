################################################################################
########          Coding for Data Science: Shiny-App Project        ############
########                                                            ############
########      An App to visualize Vaccination Campaign in Italy     ############
########                                                            ############
########               Andrea Pio Cutrera: 965591                   ############
################################################################################

#   package "pacman" to load (and install) all the requirements for the correct 
#   execution of the app  


if (!require("pacman")) install.packages("pacman")
pacman::p_load(shiny, ggplot2, plotly, shinythemes, shinyWidgets, highcharter)

##   scrape data from Open Data GitHub: 
##   https://github.com/italia/covid19-opendata-vaccini

df <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.csv')
anagrafica <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/anagrafica-vaccini-summary-latest.csv')
summary <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/vaccini-summary-latest.csv')

#   last data in our dataset
last_update <- df[nrow(df),1]

#   some manipulation to have the percentages of Male-Female submission
#   and First-Second dose submission
data <- df
data$total <- data$sesso_maschile + data$sesso_femminile
data$Male <- round((data$sesso_maschile/data$total)*100, digits = 2)
data$Female <- round((data$sesso_femminile/data$total)*100, digits = 2)
data$First <- round((data$prima_dose/data$total)*100, digits = 2)
data$Second <- round((data$seconda_dose/data$total)*100, digits = 2)
data <- data[,c(1,2,4,19,21,22,23,24)]
data <- subset(data, data_somministrazione==last_update)


df <- subset(df, data_somministrazione == last_update)


#   UI - user interface definition
ui <- navbarPage(
  
                 paste('Vaccination Campaign in Italy (date of', paste0(last_update, ')')),
                 theme = shinytheme("cerulean"),
                 
                 
                 
                 tabPanel('Age Ranges',
    
                          sidebarLayout(
                                        sidebarPanel(
                                                     selectInput("region", h5("Select REGION to visualize"),
                                                                 unique(df$nome_area), selected='Lombardia'
                                                                 ),
                                                     helpText("Regions in Italy (19) and Autonomous Provinces (2)"
                                                              ),
                                                     selectInput("vaccine", h5("Select VACCINE to visualize"),
                                                                 unique(df$fornitore), selected='Pfizer/BioNTech'
                                                                 ),
                                                     helpText("Producers of vaccine doses admitted by EMA agency (Europen Medicine Agency)"
                                                              ),
                                                     selectInput('variable', h5('Select the variable to visualize'),
                                                                 c('sesso_maschile', 'sesso_femminile', "prima_dose",
                                                                 "seconda_dose"), selected='sesso_maschile'),
                                                     helpText("Note: you can plot the absolute numbers of the people vaccinated
                                                              selecting the dose and the region for the variable of interest
                                                              (Males, Females, First dose, Second dose)"
                                                              )
                                                     
                                                    ),
                                        mainPanel(
                                                  titlePanel(h4('Plot of the absolute numbers')),
                                                  highchartOutput('histogram')
                                                 )
                                        )
                          ),
                tabPanel('Best Regions',
                         sidebarLayout(
                                       sidebarPanel(
                                                    sliderInput('count', h5('Select the number of regions to plot'),
                                                                min=1, max=21, value=5)
                                                    ),
                        
                                        mainPanel(
                                                  titlePanel(h4('Plot of the percentages of used doses')),
                                                  highchartOutput('percentages')
                                                  )
                                      )
                         ),
               tabPanel('Analysis',
                        sidebarLayout(
                                      sidebarPanel(
                                                   selectInput('regions', h5('Select the REGION to plot:'),
                                                               unique(df$nome_area), selected='Lombardia'
                                                               ),
                                                   selectInput('dose', h5('Select the DOSE:'),
                                                               unique(df$fornitore), selected ='Pfizer/BioNTech'
                                                               ),
                                                   selectInput('age', h5('Select the Age Range:'),
                                                               unique(df$fascia_anagrafica), selected='60-69'
                                                               )
                                                   ),
                
                                      mainPanel(
                                                titlePanel(h4('Plot of the percentages of used doses')),
                                                highchartOutput('pie', height = "300px")
                                               )
                                     )
                       )
               )

#   Server building
server <- function(input, output) {
  
  var <- reactive({
    if ("sesso_maschile" %in% input$variable) return(df[(df$data_somministrazione==last_update & df$fornitore==input$vaccine & df$nome_area==input$region),]$sesso_maschile)
    if ("sesso_femminile" %in% input$variable) return(df[(df$data_somministrazione==last_update & df$fornitore==input$vaccine & df$nome_area==input$region),]$sesso_femminile)
    if ("prima_dose" %in% input$variable) return(df[(df$data_somministrazione==last_update & df$fornitore==input$vaccine & df$nome_area==input$region),]$prima_dose)
    if ("seconda_dose" %in% input$variable) return(df[(df$data_somministrazione==last_update & df$fornitore==input$vaccine & df$nome_area==input$region),]$seconda_dose)
    
    
  })
  
  lab_var <- reactive({
    if ('sesso_maschile' %in% input$variable) return("Males")
    if ('sesso_femminile' %in% input$variable) return("Females")
    if ('prima_dose' %in% input$variable) return("First doses")
    if ('seconda_dose' %in% input$variable) return("Second doses")
    
  })
  
  
  pie_chart <- reactive({
    male_pct <- subset(data, (nome_area==input$regions & fornitore==input$dose & fascia_anagrafica==input$age))[,5]
    female_pct <- subset(data, (nome_area==input$regions & fornitore==input$dose & fascia_anagrafica==input$age))[,6]
    if (!(length(male_pct)==0 | length(female_pct)==0)) {
      data.frame('sex'=c('Male', 'Female'), 'values'=c(male_pct,female_pct)) }
  })
  
  output$pie <- renderHighchart({
    if (is.null(pie_chart())) return() 
    pie_chart() %>% 
     hchart(
        "pie", hcaes(x = sex, y = values),
        name = "Percentage"
      )%>% 
      hc_add_theme(hc_theme_ffx())})
  
  output$histogram <- renderHighchart(
    df[(df$data_somministrazione==last_update & df$fornitore==input$vaccine & df$nome_area==input$region),] %>%
      mutate(var=var())%>%
      hchart(type = 'column', hcaes(x = fascia_anagrafica, y = var),
             name = "People vaccinated")%>%
      hc_title(text = paste(input$vaccine,"doses used in", input$region, last_update),
               style = list(fontWeight = "bold", fontSize = "20px"),
               align = "center")%>% 
      hc_yAxis(
        title=list(text=paste(lab_var())))%>%
      hc_xAxis(
        title=list(text=paste('Age Ranges')))%>%
      
      hc_add_theme(hc_theme_ffx())
  )
  
  output$percentages <- renderHighchart(
    summary[order(-summary$percentuale_somministrazione),c(9,2,3,4)][1:input$count,] %>% 
      hchart(type = 'column', hcaes(x = reorder(nome_area,-percentuale_somministrazione), y = percentuale_somministrazione),
             name = "Percentage") %>%
      hc_title(text = paste("Vaccine doses used in", last_update),
               style = list(fontWeight = "bold", fontSize = "20px"),
               align = "center")%>% 
      hc_yAxis(
        title=list(text=paste('Percentages')))%>%
      hc_xAxis(
        title=list(text=paste('Regions')))%>%
      
      hc_add_theme(hc_theme_ffx())
    
  )
      
}

#shiny APP
shinyApp(ui = ui, server = server)



