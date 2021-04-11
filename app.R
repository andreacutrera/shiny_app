library(shiny)
library(shinythemes)
library(ggplot2)
library(plotly)
library(highcharter)

df <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.csv')
anagrafica <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/anagrafica-vaccini-summary-latest.csv')
summary <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/vaccini-summary-latest.csv')

last_update <- df[nrow(df),1]
data <- df
data$total <- data$sesso_maschile + data$sesso_femminile
data$Male <- round((data$sesso_maschile/data$total)*100, digits = 2)
data$Female <- round((data$sesso_femminile/data$total)*100, digits = 2)
data$First <- round((data$prima_dose/data$total)*100, digits = 2)
data$Second <- round((data$seconda_dose/data$total)*100, digits = 2)
data <- data[,c(1,2,4,19,21,22,23,24)]
data <- subset(data, data_somministrazione==last_update)


df <- subset(df, data_somministrazione == last_update)


#user interface
ui <- navbarPage(
                theme = shinytheme("cerulean"),
  
                paste('Vaccination Campaign in Italy (date of', last_update, ')'),
     tabPanel('Age Ranges',
    
     sidebarLayout(
                   sidebarPanel(
                                selectInput("region", h5("Select REGION to visualize"),
                                unique(df$nome_area)),
                                selectInput("vaccine", h5("Select VACCINE to visualize"),
                                unique(df$fornitore)),
                               ),
                   mainPanel(
                             titlePanel(h4('Plot of the absolute numbers')),
                             highchartOutput('histogram')
                            )
                  )),
     tabPanel('Best Regions',
     sidebarLayout(
                   sidebarPanel(
                               selectInput('count', h5('Select the number of regions to plot'),
                               c(1:10), 5)
                               ),
                        
                   mainPanel(
                             titlePanel(h4('Plot of the percentages of used doses')),
                             highchartOutput('percentages')
                            )
                  )),
     tabPanel('Analysis',
              sidebarLayout(
                sidebarPanel(
                  selectInput('regions', h5('Select the REGION to plot:'),
                              unique(df$nome_area)),
                  selectInput('dose', h5('Select the DOSE:'),
                              unique(df$fornitore)),
                  selectInput('age', h5('Select the Age Range:'),
                              unique(df$fascia_anagrafica))
                ),
                
                mainPanel(
                  titlePanel(h4('Plot of the percentages of used doses')),
                  highchartOutput('pie', height = "300px")
                )
              )
            )
               )
#server
server <- function(input, output) {
  
  
  output$pie <- renderHighchart(
    (data.frame('sex'=c('Male', 'Female'), 'values'=c(subset(data, (nome_area==input$regions & fornitore==input$dose & fascia_anagrafica==input$age))[,5],subset(data, (nome_area==input$regions & fornitore==input$dose & fascia_anagrafica==input$age))[,6])))%>%
      hchart(
        "pie", hcaes(x = sex, y = values),
        name = "Percentage of doses received"
      )%>% 
      hc_add_theme(hc_theme_ffx()))
  
  output$histogram <- renderHighchart(
    df[(df$data_somministrazione==last_update & df$fornitore==input$vaccine & df$nome_area==input$region),] %>% 
      hchart(type = 'column', hcaes(x = fascia_anagrafica, y = sesso_maschile))%>%
      hc_title(text = paste(input$vaccine,"doses used in", input$region, last_update),
               style = list(fontWeight = "bold", fontSize = "20px"),
               align = "center")%>% 
      
      hc_add_theme(hc_theme_ffx())
  )
  
  output$percentages <- renderHighchart(
    summary[order(-summary$percentuale_somministrazione),c(9,2,3,4)][1:input$count,] %>% 
      hchart(type = 'column', hcaes(x = reorder(nome_area,-percentuale_somministrazione), y = percentuale_somministrazione)) %>%
      hc_title(text = paste("Vaccine doses used in", last_update),
               style = list(fontWeight = "bold", fontSize = "20px"),
               align = "center")%>% 
      
      hc_add_theme(hc_theme_ffx())
    
  )
      
}

#shiny APP
shinyApp(ui = ui, server = server)



