###World energy data visualisation - R Shiny Dashboard #######


##Installing required packages
#install.packages("shiny")
library(shiny)
#install.packages("dplyr")
library(dplyr)
#install.packages("gganimate")
library(gganimate)
#install.packages("gifski")
library(gifski)
#install.packages("ggplot2")
library(ggplot2)
library(plotly)
#install.packages("shinythemes")
library(shinythemes)
#install.packages("shinydashboard")
library(shinydashboard)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("reshape2")
library(reshape2)
#install.packages("tmap")
library(tmap)
#install.packages("spData")
library(spData)
#install.packages("treemap")
library(treemap)
#install.packages("ComplexHeatmap")
#install.packages("InteractiveComplexHeatmap")
library(ComplexHeatmap)
library(InteractiveComplexHeatmap)



##Setting working directory


setwd("D:/Git/World Energy Data Visualisation/Dataset")




##Reading the required data sets

##Master data
energy_rawdata = read.csv("World Energy Consumption.csv")

##Continent data
cont_data = read.csv("countryContinent.csv")
#cont_data$country[cont_data$country == "Russian Federation"] ="Russia" 
#cont_data$country[cont_data$country == "United States of America"] ="United States" 

##Co2 data
co2_rawdata = read.csv("CO2_Emissions_1960-2018.csv")
co2data=co2_rawdata

co2data=melt(co2_rawdata, id.vars=c("Country.Name"))
co2data$variable = gsub("X", "", co2data$variable)




#### Subsets for each tabs ####
top_count = c('Nigeria','Egypt','South Africa','Algeria','Morocco','Ethiopia','Kenya','Ghana','Tanzania','Angola','Ivory Coast','Congo','Cameroon','Tunisia','Uganda','Australia','New Zealand','Papua New Guinea','United States','Canada','Brazil','Mexico','Venezuela','Argentina','Colombia','Chile','Peru','Puerto Rico','Cuba','Ecuador','Dominican Republic','Guatemala','Costa Rica','China','Japan','India','South Korea','Indonesia','Saudi Arabia','Taiwan','Thailand','United Arab Emirates','Israel','Philippines','Hong Kong','Singapore','Malaysia','Bangladesh','Germany','United Kingdom','France','Italy','Russia','Spain','Netherlands','Switzerland','Turkey','Poland','Sweden','Belgium','Austria','Ireland','Norway')


########Tab 1#########
energy_data_1 = energy_rawdata
energy_data_1$continent <- cont_data$continent[match(energy_data_1$iso_code, cont_data$code_3)]
energy_sub_1 = energy_data_1 %>% 
  dplyr::select(energy_per_capita, population, continent, year, country,primary_energy_consumption) %>%
  filter(country %in% top_count)%>% 
  filter(year==2015)
energy_sub_1 = na.omit(energy_sub_1)


##########Tab 2 ###########
energy_data_2 = energy_rawdata
energy_data_2$continent <- cont_data$continent[match(energy_data_2$iso_code, cont_data$code_3)]
year_2 = c(1995:2015)
top_count2 = c('Nigeria','Egypt','South Africa','Kenya','Morocco','Australia','New Zealand','Papua New Guinea','United States','Canada','Brazil','Mexico','Venezuela','Argentina','China','Japan','India','South Korea','Indonesia','United Arab Emirates','Israel','Singapore','Bangladesh','Germany','United Kingdom','France','Russia','Sweden','Ireland','Norway')



energy_sub_2 = energy_data_2 %>% 
  dplyr::select(country,year,fossil_cons_per_capita,continent,renewables_energy_per_capita,coal_cons_per_capita, gas_energy_per_capita, oil_energy_per_capita, hydro_energy_per_capita, nuclear_energy_per_capita, other_renewables_energy_per_capita, solar_energy_per_capita, wind_energy_per_capita) %>%
  filter(country %in% top_count2)%>% 
  filter(year %in% year_2)
energy_sub_2 = na.omit(energy_sub_2)

mat_data_2 = as.data.frame.matrix(xtabs(fossil_cons_per_capita ~ country + year, energy_sub_2))
mat_data_2=as.matrix(mat_data_2)
ht = Heatmap(mat_data_2, name = "E (kWh)",
             show_row_names = FALSE, show_column_names = TRUE)
ht = draw(ht)

mat_data_21 = as.data.frame.matrix(xtabs(renewables_energy_per_capita ~ country + year, energy_sub_2))
mat_data_21=as.matrix(mat_data_21)
ht1 = Heatmap(mat_data_21, name = "E (kWh)",
             show_row_names = FALSE, show_column_names = TRUE)
ht1 = draw(ht1)



drp_count= energy_sub_2 %>% select(country)
drp_count = unique(drp_count$country)

#######Tab 4 subset########
energy_data_4 = energy_rawdata
energy_data_4$continent <- cont_data$continent[match(energy_data_4$iso_code, cont_data$code_3)]
energy_sub_4 = energy_data_4 %>% 
  dplyr::select(gdp, energy_per_capita, population, continent, year, country) %>%
  filter(country %in% top_count)%>% 
  filter(year>1970) 
energy_sub_4 =na.omit(energy_sub_4)
energy_sub_4$gdp_per_capita = energy_sub_4$gdp/energy_sub_4$population
ene_4_cont = unique(energy_sub_4$country)


##energy_sub_4 %>% filter(country == "United States") %>% ggplot() + geom_area(aes(x = gdp_per_capita, y = energy_per_capita))

######Tab5 subset##########
energy_data_5 = energy_rawdata
energy_data_5$co2 <- co2data$value[match(energy_data_5$country,co2data$Country.Name) & match(energy_data_5$year,co2data$variable)]
energy_data_5$continent <- cont_data$continent[match(energy_data_5$iso_code, cont_data$code_3)]


year_num = c(1970:2015)
worldcont=unique(cont_data$continent)
discont=unique(cont_data$continent)

energy_sub_5 = energy_data_5 %>% dplyr::select(iso_code,country,year,co2,continent,population,energy_per_capita)



####### Home page info boxes
### No of countries
no_country = length(unique(energy_rawdata$country))

### World population
w_pop = energy_rawdata %>% filter(year == 2015 & country == "World") %>% select(population)

### Global energy per capita in 2015 in kWh
en_pc = energy_rawdata %>% filter(year == 2015 & country == "World") %>% select(primary_energy_consumption)

### Avg Global fossil fuel energy per capita 2015
en_fs = energy_rawdata %>% filter(year == 2015 & country == "World") %>% select(fossil_cons_per_capita)


### Avg Global renewable fuel energy per capita 2015
en_rn = energy_rawdata %>% filter(year == 2015 & country == "World") %>% select(renewables_energy_per_capita)

## Global Co2 release per capita 2015
gl_co2 = co2data %>% filter(variable == 2015 & Country.Name == "World") %>% select(value)
gl_co2 = round(gl_co2$value,2)


###### Interactive map mode######
tmap_mode("view")




#################################################### SHINY APP CODE #################################

########################################################### UI ######################################

ui <- dashboardPage(
  dashboardHeader(title = "Energisation"),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Home", tabName = "Home"),
      menuItem("Energy_vs_GDP", tabName = "Energy_vs_GDP"),
      menuItem("Regional_Energy", tabName = "Regional_Energy"),
      menuItem("Renewable vs Fossil", tabName = "Renewable vs Fossil",
               menuSubItem("World-View","World-View"),
               menuSubItem("Country-Wise","Country-Wise")),
      menuItem("CO2_Emission", tabName = "CO2_Emission"),
      menuItem("The_Future", tabName = "The_Future")
    )

  ),
  dashboardBody(
    tabItems(
      
      ######## Tab Home code ##########
      
      tabItem(
        tabName = "Home",
        h1(strong("How the world is energised")),
        box(width = "100%", background = "light-blue",
            strong(style = "font-size:25px;","The dashboard Energisation is about how the world is being powered. How do different regions produce and consume energy for various requirements, ranging from fossil to renewable."),
            p(style = "font-size:22px;","Because energy is a basic human requirement, it is extremely crucial in our daily life. Not only do we utilize energy to heat, but we also use it to cool our man-made structures. It's also required in large quantities for a variety of modern inventions to function.")),
        box(collapsed = FALSE, collapsible = TRUE,width = "100%" ,solidHeader = TRUE, status = "primary",title = "Global Data Snippets - 2015",box( 
                               valueBox(no_country, "Regions", icon = icon("list"), color = "yellow"),
        valueBox(w_pop, "World Population", icon = icon("list"),color = "blue"),
        valueBox(en_pc, "World Energy Consumption (TWh)", icon = icon("list"),color = "green")),
        box(valueBox(en_fs, "Fossil energy consumption per capita (kWh)", icon = icon("list"), color = "red"),
        valueBox(en_rn, "Renewable energy consumption per capita (kWh)", icon = icon("list"),color = "purple"),
        valueBox(gl_co2, "CO2 emission per capita (kt)", icon = icon("list"),color = "maroon")
        )),
        
        box(width = "100%", background = "green",
            strong(style = "font-size:18px;","Navigation through the dashboard:"),
            p(style = "font-size:15px;","The contents of the dashboard can be accessed  through the side-bar menu"),
            p(style = "font-size:15px;",">Energy vs GDP - Visualisation showing how an economy is influenced by energy."),
            p(style = "font-size:15px;",">Regional Energy - Primary energy consumption country-wise"),
            p(style = "font-size:15px;",">Renewable vs Fossil - Global and regional comparision."),
            p(style = "font-size:15px;",">CO2 Emission - Map view of global CO2 emisison"),
            p(style = "font-size:15px;",">The Future - What lies ahead in the future!!"))),
      
      
      
    
      #### Tab 1 tremap code ####
      
      tabItem(
        tabName = "Regional_Energy",
        h1("Total Energy Consumption"),
        fluidRow(
          box(title = "Overall vs per capita energy consumption", status = "primary", solidHeader = TRUE, width = "100%",
          box(imageOutput("myImage")),
          box(imageOutput("myImage2"))
          )
          ))
        ,
      
      
      
      
      ## Tab 2 heatmap code######
      
      tabItem(
        tabName = "World-View",
        h1("Energy Consumption - Renewable vs Fossil"),
        fluidRow(
          box(width = '100%',title = "Fossil energy consumption - per capita",
              box(title = "Complete Heatmap", width = 4, solidHeader = TRUE, status = "primary", originalHeatmapOutput("ht", title = NULL)),
              box(title = "Selected Region", width = 4, solidHeader = TRUE, status = "primary",subHeatmapOutput("ht", title = NULL)),
              box(title = "Datapoints of select cell", width = 4, solidHeader = TRUE, status = "primary",HeatmapInfoOutput("ht", title = NULL))
              ),
          box(width = '100%',title = "Renewable energy - per capita",
              box(title = "Complete Heatmap", width = 4, solidHeader = TRUE, status = "primary", originalHeatmapOutput("ht1", title = NULL)),
              box(title = "Selected Region", width = 4, solidHeader = TRUE, status = "primary",subHeatmapOutput("ht1", title = NULL)),
              box(title = "Datapoints of select cell", width = 4, solidHeader = TRUE, status = "primary",HeatmapInfoOutput("ht1", title = NULL))
          )
          )),
      
      
      
      tabItem(
        tabName = "Country-Wise",h1("Energy consumption distribution (Country-wise)"),
        fluidRow(
          
          box(width = '100%', 
              selectInput(inputId = "Contselect",label="Select a continent:",choices=worldcont, selected = "Select Continent"),
              selectInput(inputId = "countryselect",label="Select a Country:",choices=drp_count, selected = "")
              ),
          
          box( title = "World-View of energisation", status = "primary", solidHeader = TRUE,
            plotOutput("plot22_1"),
            plotOutput("plot22_2")),
          
          box( title = "Country and year-wise View of energisation", status = "primary", solidHeader = TRUE,
               selectInput(inputId = "yearselect2",label="Select a year:",choices=year_2, selected = "2015"),
                 plotOutput("plot22_3", width = "80%"),
                 plotOutput("plot22_4", width = "80%")
              )
        

        )),
      
      
      
    
      ##### Tab 4 Scatter plot code#########
      
      tabItem(
        h1("The effect of energy"),
        tabName = "Energy_vs_GDP",
      
        fluidRow(
          box(width = 12 ,title = "Importance of Energy", status = "primary", solidHeader = TRUE,background = "green",collapsed = FALSE, collapsible = TRUE,
              p(style = "font-size:20px;","A study states that an increase of 1% in energy consumption boosts real GDP by 0.59 percent"),
              p(style = "font-size:20px;","The below global representation proves the same, development of any country looks linear with respect to more energy consumption"),
              p(style = "font-size:20px;","Global View: "),
              p(style = "font-size:20px;","> Drag the year scroll bar or click play for a time-series representation"),
              p(style = "font-size:20px;","> Hover over the bubbles to know the country name"),
              p(style = "font-size:20px;","> Click on the continent names from the legend to select de-select "),
              p(style = "font-size:20px;","Country-wise:"),
              p(style = "font-size:20px;","Select any country to view the gdp vs energy growth")
              
              
              ),
          box(collapsed = FALSE, collapsible = TRUE,title = "Energy vs GDP per capita - Global view", status = "primary", solidHeader = TRUE,plotlyOutput("plot1", height = "600px", width = "700px")),
          box(collapsed = FALSE, collapsible = TRUE,title = "Energy vs GDP per capita : country-wise", status = "primary", solidHeader = TRUE,
              selectInput(inputId = "cont_4",label="Select a country:",choices=ene_4_cont, selected = "China"),
              plotOutput("plot42",height = "500px", width = "700px")),
                 
                 )
        ),
      
      

      
      #### Tab 5 tmap code  ########
      
      tabItem(
        tabName = "CO2_Emission", h1("CO2 Emisssion"),
        
        fluidRow(
          box(
            selectInput(inputId = "yearselect",label="Select a year:",choices=year_num, selected = "2015"),
            checkboxInput("type", "Select Continent", FALSE),
            conditionalPanel("input.type", selectInput(inputId = "contselect",label="Select a continent:",choices=discont)), height = "200px", width = "200px"),
          box(tmapOutput("my_tmap", height = "600px", width = "800px")),
          
          
          #### Boxes with only text ###
          box(width = 4, background = "light-blue", style = "font-size:18px;",
              p("The Paris Agreement sets out a global framework to avoid dangerous climate change by limiting global warming to well below 2°C and pursuing efforts to limit it to 1.5°C. It also aims to strengthen countries’ ability to deal with the impacts of climate change and support them in their efforts."),
              p("The primary objective is to reduce the CO2 emission by each country. At present the global average of CO2 emission is around 4.5 Per capita in metric tons.")),
          
          box(width = 4, background = "light-blue",style = "font-size:18px;",
              p("The world map represents CO2 emission of each country in metric tons per capita between 1970 and 2015"),
              p("Select the year from the dropdown to know the detail for any particular year"),
              p("Check the box 'select a continent' to view details for any particular continent alone"),
              p("Country names can be known by hovering over the regions"),
              p("Click on any country to know the CO2 emission and click bubble to know the respective population and per capita energy consuptions"))
          )),
      
      ##Tab6 The_Future
      tabItem( tabName = "The_Future", h1("Renewable Energy - The way forward"),
               fluidRow(
                 box(
                   width = 5,style = "font-size:18px;", status = "primary", solidHeader = TRUE,
                   title = "An Ambitious thought",
                   HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/HiOLan8J0cE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'),
                   p("Video of Elon Musk depicts the ambitious future that the world is heading towards.")
                   ),
                 box(
                   width = 5,style = "font-size:18px;", status = "primary", solidHeader = TRUE,
                   title = "The worlds largest solar plant",
                   HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/VyTY1M66mUc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'),
                   p("Video about the worlds largest solar powerplant")
                 ),
                 box(width = 12 ,style = "font-size:20px;", status = "primary", solidHeader = TRUE, title = "Why Renewable..???", background = "green",
                     p("Natural gas, coal, and other fossil fuels have a far higher carbon footprint than renewable energy sources. Switching to renewable energy sources for energy production will benefit the environment by slowing and reversing climate change."),
                     p("Why Solar? Each second, the Sun sends enough energy to Earth to meet the whole human energy demand for more than two hours. Solar power is an appealing source of energy since it is both easily available and renewable."))
               ))
      )))





#################################################### SERVER #################################

myserver = function(input,output,session){
  
  
  
  ######## Tab 2 interactive heatmap code##############
  
  makeInteractiveComplexHeatmap(input, output, session, ht, "ht")
  makeInteractiveComplexHeatmap(input, output, session, ht1, "ht1")
    
    
    observeEvent(input$Contselect,
                 {
                   x <<- input$Contselect
                   updateSelectInput(session, "countryselect",
                                     choices =unique(energy_sub_2[energy_sub_2$continent == input$Contselect, ]$country),#selected = tail(x, 1)
                   )
                 })
    
    output$plot22_1 <- renderPlot(
      {
        energy_sub_2 %>% dplyr::filter(continent == input$Contselect) %>% dplyr::filter(country == input$countryselect) %>%
          ggplot(aes(x = year, y = fossil_cons_per_capita)) + geom_col(fill = "light green") + geom_line() +
          labs(title = "Fossil energy consumption per capita", subtitle = "E in kWh")
        }
    )
    output$plot22_2 <- renderPlot(
      {
        energy_sub_2 %>% dplyr::filter(continent == input$Contselect) %>% dplyr::filter(country == input$countryselect) %>%
          ggplot(aes(x = year, y = renewables_energy_per_capita)) + geom_col(fill = "light blue") + geom_line() +
          labs(
            title = "Renewable energy consumption per capita",
            subtitle = "E in kWh")
      }
    )
    
    output$plot22_3 <- renderPlot(
      {
        fossil_energy = energy_sub_2  %>% filter(year == input$yearselect2) %>% dplyr::filter(continent == input$Contselect) %>% dplyr::filter(country == input$countryselect) %>%  select(coal_cons_per_capita, gas_energy_per_capita, oil_energy_per_capita) %>%
          pivot_longer(cols = names(.)) 
        labels <- c('coal_cons_per_capita', 'gas_energy_per_capita', 'oil_energy_per_capita')
        rownames(fossil_energy) <- NULL
        pie(fossil_energy$value, labels = fossil_energy$value, col = c('light green','red','light blue'), main = "Distribution of fossil fuel consumption - E/PC (kWh)")
        legend("topleft", c('coal_cons_per_capita', 'gas_energy_per_capita', 'oil_energy_per_capita'), cex = 0.8, fill = c('light green','red','light blue'))
        
      }
    )
    
    
    output$plot22_4 <- renderPlot(
      {
      ren_energy = energy_sub_2 %>% filter(year == input$yearselect2) %>% filter(continent == input$Contselect) %>% filter(country == input$countryselect) %>%  select(hydro_energy_per_capita, nuclear_energy_per_capita, other_renewables_energy_per_capita, solar_energy_per_capita, wind_energy_per_capita) %>%
        pivot_longer(cols = names(.)) 
      labels <- c('hydro_energy_per_capita','nuclear_energy_per_capita','other_renewables_energy_per_capita','solar_energy_per_capita','wind_energy_per_capita')
      pie(ren_energy$value, labels = ren_energy$value, col = c('light green','red','light blue','purple','yellow'), main = "Distribution of renewable consumption - E/PC (kWh)")
      legend("topleft", c('hydro_energy_per_capita','nuclear_energy_per_capita','other_renewables_energy_per_capita','solar_energy_per_capita','wind_energy_per_capita'), cex = 0.7, fill = c('light green','red','light blue','purple','yellow'))
    })
    ###### Tab 4 interactive Scatter plot code#########################
    
    output$plot1 <- renderPlotly({
      fig = energy_sub_4 %>% plot_ly(x = ~gdp_per_capita, y = ~energy_per_capita, span = ~population, color = ~continent,frame = ~year ,text = ~country, hoverinfo = "text", type = 'scatter', mode = 'markers')
      fig
    })
    
    output$plot42 <- renderPlot({
      ene_4 = energy_sub_4 %>% dplyr::filter(country == input$cont_4)
      ggplot(ene_4, aes(x=energy_per_capita, y = gdp_per_capita))+ geom_point()
    })
    
    
    #### Tab 1 treemap code ####
    output$myImage <- renderImage({
      energy_sub_1$label <- paste(energy_sub_1$country,energy_sub_1$primary_energy_consumption , sep = ", ")
      outfile <- tempfile(fileext = '.png')
      png(outfile, width = 400, height = 300)
      treemap(energy_sub_1, index=c("continent","label"), vSize = "population",  vColor= "primary_energy_consumption",
              type="value", palette = "Blues", title="Primary energy consumption (terawatt-hours)", fontsize.title = 15)
      dev.off()
      list(src = outfile,
           contentType = 'image/png',
           width = 800,
           height = 700,
           alt = "This is alternate text")
    }, deleteFile = TRUE)
    
    output$myImage2 <- renderImage({
      energy_sub_1$label <- paste(energy_sub_1$country,energy_sub_1$energy_per_capita , sep = ", ")
      outfile <- tempfile(fileext = '.png')
      png(outfile, width = 400, height = 300)
      treemap(energy_sub_1, index=c("continent","label"), vSize = "population",  vColor= "energy_per_capita",
              type="value", palette = "Blues", title="Energy consumption per capita (kWh)", fontsize.title = 15)
      dev.off()
      list(src = outfile,
           contentType = 'image/png',
           width = 800,
           height = 700,
           alt = "This is alternate text")
    }, deleteFile = TRUE)
    
    
    
    
    ###### Tab 5 tmap code########
    
    output$my_tmap = renderTmap({
      
      if(input$type == FALSE){
        energy_sub_5 = energy_sub_5 %>% filter(year==input$yearselect) 
        
        world_data=left_join(world,energy_sub_5, by = c("name_long" = "country"))
        
        map_rend = tm_shape(world_data) +
          tm_polygons("co2", palette="-Reds", contrast=.7, id="name_long", title="CO2 Emission",breaks = c(0,1,2,4,6,8,10,15,20,25,30,40,45))+
          tm_shape(world_data) + tm_bubbles("population",col = "energy_per_capita",border.col = "black", border.alpha = .5)
        map_rend  
      }
      
      else{
        energy_sub_5 = energy_data_5 %>% 
          dplyr::select(iso_code,country,year,co2,continent,population,energy_per_capita) %>% 
          filter(year==input$yearselect & continent == input$contselect) 
        
        world_data=left_join(world,energy_sub_5, by = c("name_long" = "country")) 
        
        map_rend = tm_shape(world_data) +
          tm_polygons("co2", palette="-Reds", contrast=.7, id="name_long", title="CO2 Emission",breaks = c(0,1,2,4,6,8,10,15,20,25,30,40,45)) +
          tm_shape(world_data) + tm_bubbles("population",col = "energy_per_capita",border.col = "black", border.alpha = .5)
        map_rend
      }
    })

  

  }
  

shinyApp(ui, myserver)
