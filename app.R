library(shiny)
library(ggplot2)
#library(plotly)
library(shinythemes)

df <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.csv')
anagrafica <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/anagrafica-vaccini-summary-latest.csv')
summary <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/vaccini-summary-latest.csv')


last_update <- df[nrow(df),1]
df <- subset(df, data_somministrazione == last_update)


#user interface
ui <- fluidPage(
                theme = shinytheme("cerulean"),
  
                titlePanel(paste('Vaccination Campaign in Italy (date of ', last_update, ')')),
     sidebarLayout(
                   sidebarPanel(
                                selectInput("region", h5("Select REGION to visualize"),
                                unique(df$nome_area)),
                                selectInput("vaccine", h5("Select VACCINE to visualize"),
                                unique(df$fornitore)),
                               ),
                   mainPanel(
                             titlePanel(h4('Plot of the absolute numbers')),
                             plotOutput('histogram')
                            )
                  ),
     sidebarLayout(
                   sidebarPanel(
                               selectInput('count', h5('Select the number of regions to plot'),
                               c(1:10), 5)
                               ),
                        
                   mainPanel(
                             titlePanel(h4('Plot of the percentages of used doses')),
                             plotOutput('percentages')
                            )
                  )
               )
#server
server <- function(input, output) {
  output$histogram <- renderPlot(
    ggplot(subset(df, (fornitore==input$vaccine & nome_area==input$region)), aes(x=fascia_anagrafica, y=prima_dose))+
      geom_bar(stat="identity", color='blue', fill='#00abff')+
      geom_text(aes(label=prima_dose), vjust=-0.8, size=4))
  output$percentages <- renderPlot(
    ggplot(summary[order(-summary$percentuale_somministrazione),c(9,2,3,4)][1:input$count,], 
           aes(x=reorder(nome_area,-percentuale_somministrazione), y=percentuale_somministrazione))+
      geom_bar(stat='identity', color='blue', fill='#00abff')+
      theme(axis.text.x = element_text(angle = 15))
    
  )
      
}

#shiny APP
shinyApp(ui = ui, server = server)



