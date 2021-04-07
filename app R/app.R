library(shiny)
library(ggplot2)
library(plotly)
library(shinythemes)
library(shinyWidgets)

df <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.csv')
anagrafica <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/anagrafica-vaccini-summary-latest.csv')
summary <- read.csv('https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/vaccini-summary-latest.csv')


last_update <- df[nrow(df),1]
df <- subset(df, data_somministrazione == last_update)

ages <- anagrafica$fascia_anagrafica
a <- anagrafica[,c(1,2,3,4)]

#user interface
ui <- fluidPage(
                theme = shinytheme("cerulean"),
  
                titlePanel('Vaccination Campaign in Italy'),
  
                sidebarPanel(
                             selectInput("region", "Select region to visualize",
                              unique(df$nome_area)),
                             selectInput("vaccine", "Select vaccine to visualize",
                              unique(df$fornitore))
                             ),
  
                mainPanel(
                          titlePanel('Plot of the absolute numbers'),
                          plotOutput('histogram')
                         )
  
               )
#server
server <- function(input, output) {
  output$histogram <- renderPlot(
    ggplot(subset(df, (fornitore==input$vaccine & nome_area==input$region)), aes(x=fascia_anagrafica, y=sesso_maschile))+
      geom_bar(stat="identity", color='blue', fill='#00abff')+
      geom_text(aes(label=sesso_maschile), vjust=-0.8, size=4)
      )
}

#shiny APP
shinyApp(ui = ui, server = server)



