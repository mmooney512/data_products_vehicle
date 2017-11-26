library(dplyr)
library(ggplot2)
library(shiny)

#
vs <- readRDS("vs.rds")

# Define server logic to draw the two plots
shinyServer(function(input, output, session) 
{
	#init default values for the data frame
	plot_df <- data.frame(vehicle = c("Vehicle 1" , "Vehicle 2")
						  ,mpg = c(20, 30)
						  ,co2 = c(350, 25)
						  )
	
	# vs <- vehicles_subset
	m0 <- vs %>% filter(year=="2000", make=="Volkswagen", model=="Golf")
	m1 <- vs %>% filter(year=="2015", make=="Volkswagen", model=="Golf")
	

	vehicle.year 	<- as.character(sort(unique(vs$year)))

	observe({
		#grab the values from the select boxes and store them in local variables
		current_year 	<- ifelse(input$Choose_Year_Current == "1900", "2000", input$Choose_Year_Current)
		current_make	<- ifelse(input$Choose_Make_Current == "None", "Volkswagen", input$Choose_Make_Current)
		current_model 	<- ifelse(input$Choose_Model_Current == "None", "Golf", input$Choose_Model_Current)
		
		new_year	<- ifelse(input$Choose_Year_New == "1900", "2017", input$Choose_Year_New)
		new_make	<- ifelse(input$Choose_Make_New == "None", "Volkswagen", input$Choose_Make_New)
		new_model	<- ifelse(input$Choose_Model_New == "None", "Golf", input$Choose_Model_New)
		
		
		#only update the year if it is first time loaded.
		if(input$Choose_Year_Current == "1900")
		{
			updateSelectInput(session
						  ,"Choose_Year_Current"
						  ,label = "Choose Make"
						  ,choices = vehicle.year
						  ,selected = current_year
						  )
		}
		
		#update the makes based on the year
		if(input$Choose_Year_Current != "1900")
		{
			vehicleMake	<- sort(as.vector(with(vs, subset(make, year==current_year))))
			updateSelectInput(session
							  ,"Choose_Make_Current"
							  ,label = "Choose Make"
							  ,choices = vehicleMake
							  ,selected = current_make
							  )
		}
		
		#update the models based on the year and make
		if(input$Choose_Year_Current != "1900")
		{
			vehicleModel <- sort(as.vector(with(vs, subset(model
													  ,year==current_year 
													  & make==current_make))))
			updateSelectInput(session
							  ,"Choose_Model_Current"
							  ,label = "Choose Model"
							  ,choices = vehicleModel
							  ,selected = current_model
							  )
		}
		
		# update the new select boxes
		# same as above except for the compared values
		
		if(input$Choose_Year_New == "1900")
		{
			updateSelectInput(session
							  ,"Choose_Year_New"
							  ,label = "Choose Make"
							  ,choices = vehicle.year
							  ,selected = new_year
			)
		}
		
		if(input$Choose_Year_New != "1900")
		{
			vehicleMake	<- sort(as.vector(with(vs, subset(make, year==new_year))))
			updateSelectInput(session
							  ,"Choose_Make_New"
							  ,label = "Choose Make"
							  ,choices = vehicleMake
							  ,selected = new_make
			)
		}
		if(input$Choose_Year_New != "1900")
		{
			vehicleModel <- sort(as.vector(with(vs, subset(model
														   ,year==new_year 
														   & make==new_make))))
			updateSelectInput(session
							  ,"Choose_Model_New"
							  ,label = "Choose Model"
							  ,choices = vehicleModel
							  ,selected = new_model
			)
			
		}
		
		# update the temp vars for the data frame
		m0 <- vs %>% filter(year==current_year, make==current_make, model==current_model)
		m1 <- vs %>% filter(year==new_year, make==new_make, model==new_model)
		
		#plot the bar chart !	
		
		plot_v <- data.frame(vehicle = c(paste(m0[1,1],m0[1,2], m0[1,3]), paste(m1[1,1],m1[1,2], m1[1,3]))
							  ,mpg = c(mean(m0$comb08), mean(m1$comb08))
							  ,co2 = c(mean(m0$co2TailpipeGpm), mean(m1$co2TailpipeGpm))
							  )
	
		#mpg plot
		output$plotmpg <- renderPlot(ggplot(plot_v, aes(x=vehicle, y=mpg, fill=vehicle)) 
									 + geom_bar(stat = "identity")
									 + theme(axis.text.x = element_blank()
									 		,legend.position = "bottom")
									 + guides(fill=guide_legend(nrow=2,byrow = TRUE))
									 )
		#co2 plot
		output$plotco2 <- renderPlot(ggplot(plot_v, aes(x=vehicle, y=co2, fill=vehicle)) 
									 + geom_bar(stat = "identity")
									 + theme(axis.text.x = element_blank()
									 		,legend.position = "bottom"
									 		)
									 + guides(fill=guide_legend(nrow=2,byrow = TRUE))
									)
	
		output$diff_MPG <- reactive({as.character(ifelse(nrow(plot_v) >= 2, round(plot_v[2,2] - plot_v[1,2],1), 0))})
		output$diff_CO2 <- reactive({as.character(ifelse(nrow(plot_v) >= 2, round(plot_v[2,3] - plot_v[1,3],1), 0))})
		
	})
	
})
