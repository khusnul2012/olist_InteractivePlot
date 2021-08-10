#LBB3

shinyUI(fluidPage(
    
    dashboardPage(
        
        #Header
        dashboardHeader(title = "Brazilian Public"),
        
        dashboardSidebar(
            
            sidebarMenu(
                
                menuItem(text = "Home", icon = icon("home"), tabName = "menu_home"),
                menuItem(text = "General Analysis", icon = icon("chart-bar"), tabName = "menu_data")
                
            )
            
        ),
        
        
        dashboardBody(
            
            
            tabItems(
                #Menu Home
                tabItem(align= "left", tabName = "menu_home",
                        
                        h1("3rd LBB: Data Visualization"),
                        h4("by: khusnul2012"),
                        h4("This dataset contains 100,000 Orders with product, customer and reviews info
                           from https://www.kaggle.com/olistbr/brazilian-ecommerce"),
                        h5("Fields include:"),
                        h5("year: year of purchased item"),
                        h5("month: month of purchased item"),
                        h5("payment_type: method of payment chosen by the customer"),
                        h5("mean_delivery: average delivery time"),
                        h5("customer_state: Custumer's State loc"),
                        
                        ),
                #Menu Product
                tabItem(align= "center", tabName = "menu_data",
                        
                        
                        h2("Products Sold at Brazilian E-Commerce"),
                        fluidRow(plotlyOutput("sales_year")),
                        
                        h2("Preferred Payment Type at Brazilian E-Commerce"),
                        
                        fluidRow(
                            
                            radioButtons(inputId = "year",
                                         label = "Select year",
                                         choices = unique(df_need$year), inline=T
                                         
                            )
                        ),
                        fluidRow(plotOutput("pie_chart")),
                        
                        h2(""),
                        
                        
                        fluidRow(
                            column( width = 6,
                            
                            plotlyOutput("fast")),
                            
                            column(width = 6,
                                   
                            plotlyOutput("slow"))
                        )
                        
                        )
                )
            )
    )
)
)


