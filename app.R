library(shiny)
library(ggplot2)
library(plotly)
#library(plotly)
library(shinythemes)
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
     tabPanel('Plots of age ranges',
    
     sidebarLayout(
                   sidebarPanel(
                                selectInput("region", h5("Select REGION to visualize"),
                                unique(df$nome_area)),
                                selectInput("vaccine", h5("Select VACCINE to visualize"),
                                unique(df$fornitore)),
                               ),
                   mainPanel(
                             titlePanel(h4('Plot of the absolute numbers')),
                             plotlyOutput('histogram')
                            )
                  )),
     tabPanel('Best Regions in using doses',
     sidebarLayout(
                   sidebarPanel(
                               selectInput('count', h5('Select the number of regions to plot'),
                               c(1:10), 5)
                               ),
                        
                   mainPanel(
                             titlePanel(h4('Plot of the percentages of used doses')),
                             plotlyOutput('percentages')
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
                  highchartOutput('pie', height = "800px")
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
        name = "Fruit consumption"
      ))
  
  output$histogram <- renderPlotly(
    ggplot(subset(df, (fornitore==input$vaccine & nome_area==input$region)), aes(x=fascia_anagrafica, y=prima_dose))+
      geom_bar(stat="identity", color='blue', fill='#00abff')+
      geom_text(aes(label=prima_dose), vjust=2.8, size=4)+
      labs(x='Age Ranges', y='Vaccine done'))
  
  output$percentages <- renderPlotly(
    ggplot(summary[order(-summary$percentuale_somministrazione),c(9,2,3,4)][1:input$count,], 
           aes(x=reorder(nome_area,-percentuale_somministrazione), y=percentuale_somministrazione))+
      geom_bar(stat='identity', color='blue', fill='#00abff')+
      theme(axis.text.x = element_text(angle = 15))+
      geom_text(aes(label=percentuale_somministrazione), vjust=2.8, size=4)+
      labs(x='Regions', y='Percentage Usage of doses')
    
  )
      
}

#shiny APP
shinyApp(ui = ui, server = server)



