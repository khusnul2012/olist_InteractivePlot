#LBB3
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$sales_year <- renderPlotly({
        
        sales_year <- ggplot(data = sales_yr, aes(x = month, y = frequency, colour=year)) +       
            geom_line(aes(group=year)) + 
            geom_point()+
            labs(title = " ",
                 subtitle = "",
                 y = "Units",
                 x = "Month")+
            xlab("Year")+
            theme_classic()
        
        ggplotly(sales_year) %>% 
            hide_colorbar()
        
    })
    
    output$pie_chart<- renderPlot({
        
        timeline_shipp <- df_need %>% 
            group_by(payment_type) %>% 
            filter(year == input$year,
                   !is.na(payment_type)) %>% 
            summarise(frequency=n()) %>% 
            arrange(desc(frequency)) %>% 
            ungroup() %>% 
            head(5)
        
        hsize <- 2
        pie1 <- timeline_shipp %>% 
            mutate(prop = frequency/sum(frequency)*100,
                   x=hsize)
        
        pie_chart <- ggplot(pie1, aes(x = hsize, y = prop, fill = payment_type)) +
            geom_col(color = "black") +
            geom_text(aes(label = paste0(round(prop, 2),"%")),
                      position = position_stack(vjust = 0.5), size=5) +
            coord_polar(theta = "y") +
            scale_fill_manual(values = c("#FF4646", "#FA9191",
                                         "#C64756", "#FFDCB8", "#F8F7DE"))+
            xlim(c(0.2, hsize + 0.5)) +
            theme(panel.background = element_rect(fill = "white"),
                  panel.grid = element_blank(),
                  axis.title = element_blank(),
                  axis.ticks = element_blank(),
                  axis.text = element_blank(),
            )
        (pie_chart)
        
        
    })

   output$fast <- renderPlotly({
       
       fast <- ggplot(delivery_time_fastest, aes(x=mean_delivery, y=reorder(customer_state, -mean_delivery)))+
           geom_col(aes(fill=mean_delivery, text=popup))+
           scale_fill_gradient(high="#d52854", low="#f5cfd9")+
           labs(title = "Top 5 States with Fastest Delivery Tiime ",
                subtitle = "",
                y = "States",
                x = "Mean Delivery Time",
                caption = "Source: Dataset by Olist Kaggle")+
           theme_classic()+
           theme(legend.position = "None")
       
       
       ggplotly(fast, tooltip="text") %>% 
           hide_colorbar()
       
   }) 
   
   output$slow <- renderPlotly({
       
       slow <- ggplot(delivery_time_slowest, aes(x=mean_delivery, y=reorder(customer_state, mean_delivery)))+
           geom_col(aes(fill=mean_delivery, text=popup))+
           scale_fill_gradient(high="darkred", low="#d11141")+
           labs(title = "Top 5 States with Slowest Delivery Tiime",
                subtitle = "",
                y = "State",
                x = "Mean Delivery Time",
                caption = "Source: Dataset by Olist Kaggle")+
           theme_classic()+
           theme(legend.position = "None")
       
       ggplotly(slow, tooltip="text") %>% 
           hide_colorbar()
       
   })
   
 
   
    
    })
