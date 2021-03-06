STATE <- "CALIFORNIA"   # needed this here with CDPH Shiny Server but not otherwise?


# https://coolors.co


# funtion used as "short-cut" when making criteria for conditionals below
fC <- function(vec) {
  tRep <- length(vec)-1
  paste("input.ID == ",vec,    c(rep("|",tRep),""), collapse="")
}

myButtonSty     <- "height:22px; padding-top:0px; margin-top:-5px; float:right; color: #fff; background-color: #337ab7; border-color: #2e6da4"
myHelpButtonSty <- "background-color: #694D75;font-size:14px;"

myBoxSty <- "cursor:pointer;border: 3px solid blue;padding-right:0px;padding-left:0px;"

#-----------------------------------------------------------------------------------------------------------------------------

shinyUI(fluidPage(theme = "bootstrap.css",
                   
                  # 
                  # tags$head(tags$style(HTML('
                  #               .skin-blue .main-header .logo {
                  #                           background-color: #3c8dbc;
                  #                           }
                  #                           .skin-blue .main-header .logo:hover {
                  #                           background-color: #3c8dbc;
                  #                           }
                  #                           .main-header .logo {
                  #                           font-family: Tahoma, Geneva, sans-serif;
                  #                           font-weight: bold;
                  #                           font-size: 20px;
                  #                           }
                  #                           ')),
                  # 
                  
                  
                  tags$head(
                    tags$style(HTML("
                                    @import url('//fonts.googleapis.com/css?family=Open+Sans');
                                    
                                    * {
                                    font-family: 'Open Sans';
                                    line-height: 1.5;
                                    }

                                    a {text-decoration: none; color: #0000EE;}
                                    
                                    "))),
                  
                 
                 #a:link { color: blue; }
                  
                  #tags$style(type='text/css', "* {font-family: 'Open Sans', Georgia; }"),
                  tags$style(type = "text/css", ".irs-grid-pol.small {height: 0px;}"),   # removes ticks between years
                  tags$h3(mTitle),                                                       # title supplied from Global
  
sidebarPanel(width=3, 
 
  conditionalPanel(condition = fC(c(22,23)), actionButton("mapTab",           "Tab Help",style=myHelpButtonSty),br(),br()),
  conditionalPanel(condition = fC(c(33)),    actionButton("conditionTab",     "Tab Help",style=myHelpButtonSty),br(),br()),
  conditionalPanel(condition = fC(c(45)),    actionButton("conditionTableTab","Tab Help",style=myHelpButtonSty),br(),br()),
  conditionalPanel(condition = fC(c(34)),    actionButton("conditionSexTab",  "Tab Help",style=myHelpButtonSty),br(),br()),
  conditionalPanel(condition = fC(c(44)),    actionButton("rankGeoTab",       "Tab Help",style=myHelpButtonSty),br(),br()),
  conditionalPanel(condition = fC(c(55)),    actionButton("trendTab",         "Tab Help",style=myHelpButtonSty),br(),br()),
  conditionalPanel(condition = fC(c(66)),    actionButton("sdohTab",          "Tab Help",style=myHelpButtonSty),br(),br()),
  
  conditionalPanel(condition = fC(c(1)),    actionButton("sdohTab",          "Tab Help",style=myHelpButtonSty),br(),br()),
  
  
  
  
 conditionalPanel(condition = fC(c(22,23,44,55,66)),    actionButton("causeHelp", "?",style=myButtonSty) , 
                                                        selectInput("myCAUSE", HTML("Cause:"), choices=causeNum36, selected="0")
    #    selectInput("myCAUSE", HTML(paste("Cause:",a("(Cause List Info)",target="_blank",href="gbd.ICD.MapIMAGE.pdf"))), choices=causeNum36, selected="0")            
                                                       ),  # size=30 selectize = F, size=3,
 conditionalPanel(condition = fC(c(22,23,33,44,45,55)),selectInput("myLHJ","County/State:",choices=lList,selected=STATE)  ),
 
 conditionalPanel(condition = fC(c(22,23,66)),          selectInput("myGeo","Geographic Level:",choices=c("County","Community","Census Tract"))),

 conditionalPanel(condition =paste(
                             "(!(input.myGeo == 'Community' | input.myGeo == 'Census Tract') && (", fC(c(22,23)),") ) 
                               | (", fC(c(33,34,45,44)),")"  
                             ),                         sliderInput("myYear","Year:",value=2017,min=2001,max=2017,animate = TRUE,round=TRUE,sep="",step=1)  ),

 conditionalPanel(condition = fC(c(22,23,33,44,66)), radioButtons( "mySex",      "Sex:", choices=c("Total","Female","Male"))),
 
 conditionalPanel(condition = fC(c(33,34)),                checkboxGroupInput("myLev", "Levels to show:",c("Top Level" = "lev1","Public Health" = "lev2","Detail" = "lev3"),"lev1")),
 conditionalPanel(condition = fC(c(22,23)),             actionButton("statecutHelp", "?",style=myButtonSty) ,
                                                        checkboxInput("myStateCut", "State-based cutpoints", value=TRUE)),
 conditionalPanel(condition = fC(c(33,34)),             numericInput( "myN",        "How Many:", value=10,min=1,max=50)),
 conditionalPanel(condition = fC(c(22,23,34,44,55,66)), actionButton( "measureHelp", "?",style=myButtonSty) ,
                                                        radioButtons(  "myMeasure",  "Measure:", choices=lMeasures,selected="YLL.adj.rate")),
 conditionalPanel(condition = fC(c(33)),                #actionButton( "measureHelp", "?",style=myButtonSty) ,
                                                        selectInput(  "myMeasureShort",  "Measure Sort Order:", choices=lMeasuresShort)),
 conditionalPanel(condition = fC(c(22,23)),             actionButton("cutmethodHelp", "?",style=myButtonSty) ,
                                                        radioButtons( "myCutSystem","Cut-point method:", choices=c("quantile","fisher"))),   # pretty
 conditionalPanel(condition = fC(c(23)),                checkboxInput("myLabName",  "Place Names", value=FALSE)),
 conditionalPanel(condition = paste(
                              "(",fC(c(44)),") &&",
                              "( (input.myMeasure == 'cDeathRate') | (input.myMeasure == 'YLLper') | (input.myMeasure == 'aRate'))"),
                                                        checkboxInput("myCI",       "95% CIs?", value=FALSE)),
 
 conditionalPanel(condition = fC(c(44)),                checkboxInput("myRefLine",  "Reference Line", value=FALSE)),
 
 
 
 conditionalPanel(condition = fC(c(66)),                selectInput(  "myX",        "Socal Determinant of Health Variable:", choices=sdohVec)),
 
# HOME PAGE SIDE BAR PANNEL
  conditionalPanel(condition = fC(c(11)), 
                  
 HTML('<left><img src="CDPH.gif" height="125" width="150"></left>'),  # 85  100
 br(),br(),               
 
   
 helpText(h4("Welcome  to the Beta-Test Version of the CCB!"),style="color:green",align="left"),
 helpText(h5("Beta-testing in progress October-November 2018"),style="color:green"),
 br(),
 
 h4(tags$a(href="https://www.surveymonkey.com/r/2N2JSTV","Report 'bugs' HERE!")),
 h4(tags$a(href="https://www.surveymonkey.com/r/ZH9LSR8","Share your feedback HERE!")),
 helpText(textIntroA,style="color:black"), br(),
 helpText(textIntroC,style="color:black"), br(),
 
 if (whichData == "real") { helpText(textNote.real,style="color:black")},
 if (whichData == "fake") { helpText(textNote.fake,style="color:red")},
 
 br(),
 actionButton("newsUse",          "News and Updates",style=myHelpButtonSty),
 
 
 br(),br(),
 icon("envelope-o"),tags$a(href = "mailto:michael.samuel@cdph.ca.gov","Questions?  Want to Help?"),
 br(), 
 tags$a(href="https://shiny.rstudio.com/","Developed in R-Shiny"),
 br(),
 tags$a(href="https://github.com/mcSamuelDataSci/CACommunityBurden","GitHub Site")
 

),


conditionalPanel(condition = "input.ID !=  11 ",
                 
helpText('Note: YLL is "Years of Life Lost"',style="color:green"),
helpText('Note: "0" values appearing in charts or tables may be true 0 or may be any value <11',style="color:green;font-weight: bold;"),
HTML('<left><img src="CDPH.gif" height="125" width="150"></left>')

),
                 
helpText(h4(VERSION),style="color:green")

# https://stackoverflow.com/questions/35025145/background-color-of-tabs-in-shiny-tabpanel
# works: h5("Home Page",style="color:red")

),


useShinyjs(),

mainPanel(
   
  tabsetPanel(type = "tab",id="ID",
 
          tabPanel("Home Page",  br(),align='center',
    
          
        h4(HTML(above1),align="left"),
  #         fluidRow(
  #         # column(width=3,img(id="map1I",src="mapx.jpeg",width="100%",height=200,style= myBoxSty)),
  #         column(width=3,img(id="map1I",src="MapInt2.png",width="100%",style= myBoxSty)),
  #         column(width=3,img(id="map2I",src="MapStat2.png",width="100%",style = myBoxSty)),
  #         column(width=3,img(id="trendI",src="trends2.png",width="100%",style = myBoxSty)),
  #         column(width=3,img(id="scatterI",src="SDOH2.png",width="100%", style = myBoxSty))),
  #       
  # br(),
  # fluidRow(
  #     column(width=4,img(id="rankgeoI",src="rankGeo2.png",width="100%",style = myBoxSty)),
  # column(width=4,img(id="ranktableI",src="rankPlot2-save.png",width="100%",style = myBoxSty)),
  # column(width=4,img(id="rankcauseI",src="rankPlot2.png",width="100%",style = myBoxSty))),
  # 
  # 
  
  fluidRow(
    column(width=3,img(id="map1I",src="mapInt.png",width="100%",onmouseout="this.src='mapInt.png'", onmouseover="this.src='mapInt2.png'",style = myBoxSty)),
    column(width=3,img(id="map2I",src="mapStat.png",width="100%",onmouseout="this.src='mapStat.png'", onmouseover="this.src='mapStat2.png'",style = myBoxSty)),
    column(width=3,img(id="trendI",src="trends.png",width="100%",onmouseout="this.src='trends.png'", onmouseover="this.src='trends2.png'",style = myBoxSty)),
    column(width=3,img(id="scatterI",src="SDOH.png",width="100%", onmouseout="this.src='SDOH.png'", onmouseover="this.src='SDOH2.png'",style = myBoxSty))), 
  br(),
  fluidRow(
    column(width=4,img(id="rankgeoI",src="rankGeo.png",width="100%",onmouseout="this.src='rankGeo.png'", onmouseover="this.src='rankGeo2.png'",style = myBoxSty)),
    column(width=4,img(id="ranktableI",src="rankTable.png",width="100%",onmouseout="this.src='rankTable.png'", onmouseover="this.src='rankTable2.png'",style = myBoxSty)),
    column(width=4,img(id="rankcauseI",src="rankPlot.png",width="100%", onmouseout="this.src='rankPlot.png'", onmouseover="this.src='rankPlot2.png'",style = myBoxSty))),
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
h5(HTML(below1),align="left"),
value = 11),          


   tabPanel("INTERACTIVE MAP",         br(), htmlOutput("map_title")  ,
                                         leafletOutput("cbdMapTL",  width=700,height=700),        value = 22),
   tabPanel("STATIC MAP",              plotOutput("cbdMapTS",  height=700,width="100%"),        value = 23),
   tabPanel("RANK BY CAUSE [PLOT]",           br(), plotOutput("rankCause", width="100%",height=700),  value = 33),
   tabPanel("RANK BY CAUSE [TABLE]",     dataTableOutput("rankCauseT"),                           value = 45),   #DT::
 #  tabPanel("RANK BY CAUSE AND SEX",    plotOutput("rankCauseSex", width="100%",height=700),     value = 34),
   tabPanel("RANK BY GEOGRAPHY", plotOutput("rankGeo",width="100%",height=1700),          value = 44),
   tabPanel("Trend",                     br(), plotOutput("trend",     width="100%",height=700),  value = 55),
   tabPanel("SOCIAL DETERMINANTS",         br(), plotlyOutput("scatter",             height=700),   value = 66),
   tabPanel("Technical",                 br(), includeMarkdown("technical.md"),                   value = 77)
  )       ) 
 

))


# convert Markdown doc to Work if needed forediting
# https://cloudconvert.com/md-to-docx




# END -----------------------------------------------------------------------------------------------------------------

# NOTES etc. :
# tags$style(type = "text/css", ".irs-grid-pol.small {height: 0px;}"), # removes ticks between years
# https://stackoverflow.com/questions/44474099/removing-hiding-minor-ticks-of-a-sliderinput-in-shiny


# "BETTER" drop down list look
# https://stackoverflow.com/questions/40513153/shiny-extra-white-space-in-selectinput-choice-display-label



#library(shinythemes)
# shinyUI(fluidPage(theme = "bootstrap.css",
#                  #shinythemes::themeSelector(),

# wellPanel
# navBarPanel 
                  
# work on customizing help button
# actionButton("causeHelp", "?",style=" height:22px; padding-top:0px; margin-top:-5px; float:right; color: #fff; background-color: #337ab7; border-color: #2e6da4") 
# selectizeInput("myCAUSE", "Cause:", choices=causeNum36, selected="A",options = list(maxOptions = 10000),width='50%')),# size=30 selectize = F, size=3,
#width:100px;
  # https://shiny.rstudio.com/reference/shiny/latest/selectInput.html
  # https://shiny.rstudio.com/articles/selectize.html
  # https://www.w3schools.com/html/html_form_elements.asp
  #  https://www.w3schools.com/css/css3_buttons.asp


# Junk:

#tabPanel("Map (static)",      plotOutput(      "cbdMap1",   width=700,height=700),   value =  3),
#tabPanel("Map (interactive)", 
#htmlOutput(      "map_title"                      ),
#                             leafletOutput(   "cbdMap0",             height=700),   value =  1),
