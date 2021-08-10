#Install Packages
library(dplyr)
library(lubridate)
library(scales)
library(glue)
library(plotly)
library(maps)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(ECharts2Shiny)



#Persiapan Data
order_item <- read.csv("olist_order_items_dataset.csv")
orders <- read.csv("olist_orders_dataset.csv")
product <- read.csv("olist_products_dataset.csv")
customer_data <- read.csv("olist_customers_dataset.csv")
geolocation <- read.csv("olist_geolocation_dataset.csv")
order_payment <- read.csv("olist_order_payments_dataset.csv")
names(olist_order)





olist_order <- left_join(orders, order_item, order_payment, by = "order_id") 
olist_order <- left_join(olist_order, product, by = "product_id") 
olist_order <- left_join(olist_order, order_payment, by = "order_id")


df_need <- olist_order %>% 
  mutate(across(c(order_delivered_carrier_date, order_delivered_customer_date, 
             order_estimated_delivery_date, order_purchase_timestamp),
           ymd_hms 
    ),
    across(c(payment_type,product_category_name,order_status)),
    year = year(order_purchase_timestamp),
    month = month(order_purchase_timestamp,
                  label=T,
                  abbr=T)
  ) %>% 
  select(year, month, order_id, payment_type, product_category_name)

sales <- df_need %>% distinct(order_id, .keep_all = TRUE)

sales_yr <- sales %>% 
  group_by(month, year) %>%  
  summarise(frequency=n()) %>% 
  ungroup() %>% 
  mutate(month= as.factor(month),
         year=as.factor(year))





#Cek NA row
#colSums(is.na(olist_order))
#Deleting row data
#olist_order <- na.omit(olist_order) 
#colSums(is.na(olist_order)) 


df_need <- olist_order %>% 
  mutate(across(c(order_delivered_carrier_date, order_delivered_customer_date, 
                  order_estimated_delivery_date, order_purchase_timestamp),
                ymd_hms 
  ),
  across(c(payment_type,product_category_name,order_status)),
  year = year(order_purchase_timestamp)
  ) %>% 
  select(year, payment_type, product_category_name)

#-----------------------R2H1---------------#

#customer_data -> cust_id, cust_state
#orders -> cust_id, order_delivered_carrier, order_delivered_cust
shipping <- left_join(customer_data, orders, by = "customer_id")
names(shipping)
shipping <- shipping %>% 
  mutate(
    across(c(order_delivered_carrier_date, order_delivered_customer_date),ymd_hms),
  dif_ship= difftime(time1=order_delivered_customer_date, time2=order_delivered_carrier_date, units = "days"))



delivery_time_fastest <- shipping %>% 
  filter(!is.na(dif_ship))%>% 
  group_by(customer_state) %>% 
  summarise(mean_delivery=round(mean(dif_ship))) %>% 
  ungroup() %>% 
  arrange((mean_delivery)) %>% 
  mutate(popup= glue("Days: {mean_delivery},
                     State: {customer_state}"))%>% 
  head(5)


delivery_time_slowest <- shipping %>% 
  filter(!is.na(dif_ship))%>% 
  group_by(customer_state) %>% 
  summarise(mean_delivery=round(mean(dif_ship))) %>% 
  ungroup() %>% 
  arrange(desc(mean_delivery)) %>% 
  mutate(popup= glue("Days: {mean_delivery},
                     State: {customer_state}"))%>% 
  head(5)

#------------------

month_yr <- olist_order %>% 
  mutate(across(c(order_delivered_carrier_date, order_delivered_customer_date, 
                  order_estimated_delivery_date, order_purchase_timestamp),
                ymd_hms 
  ),
  across(c(payment_type,product_category_name,order_status)),
  year = year(order_purchase_timestamp),
  month = month(order_purchase_timestamp,
                label=T,
                abbr=T)
  ) %>% 
  select(year, month, order_id)


