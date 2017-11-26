#https://michaelcoursera.shinyapps.io/vehicle_compare/
library(shiny)

# Define UI 
if(interactive())
{
	shinyUI(fluidPage(
	  
	  # Application title
	  titlePanel("Differences in Miles per Gallon (MPG) and CO2 Emissions Between Two Vehicles"),
	  
	  # Sidebar with a input selectors
	  sidebarLayout(
	    sidebarPanel(
	    				selectInput('Choose_Year_Current', label = 'Choose Year', choices = "1900")
	    				,selectInput('Choose_Make_Current',label = "Choose Make", choices = "None")
	    				,selectInput('Choose_Model_Current',label = "Choose Model", choices = "None")
	    				,p("--------------------------------------")
	    				,p("Compared to:")
	    				,selectInput('Choose_Year_New', label = 'Choose Year', choices = "1900")
	    				,selectInput('Choose_Make_New',label = "Choose Make", choices = "None")
	    				,selectInput('Choose_Model_New',label = "Choose Model", choices = "None")
	    			),
	    
	    # Show a plot of the generated distribution
	    mainPanel(
	      		fluidRow("Differences in Miles per Gallon (MPG) and CO2 Emissions Between Two Vehicles")
	    		,fluidRow("Select two vehicles on the left")
	    		,fluidRow("-------------------------------")
	      		,fluidRow(
	      			column(width = 6, plotOutput("plotmpg"))
	      			,column(width = 6, plotOutput("plotco2"))
	      			)
	      		,fluidRow("Difference in MPG: ")
	      		,fluidRow(textOutput("diff_MPG"))
	      		,fluidRow("Difference in CO2: ")
	      		,fluidRow(textOutput("diff_CO2"))
	      		,fluidRow("Data Source: http://www.fueleconomy.gov")
	      		)
	  )
	))
}