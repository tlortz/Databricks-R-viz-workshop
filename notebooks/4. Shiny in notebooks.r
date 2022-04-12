# Databricks notebook source
# MAGIC %md # Shiny hosted in Databricks notebooks
# MAGIC 
# MAGIC [Shiny](https://shiny.rstudio.com/) is an R package that makes it easy to build interactive web apps straight from R. You can host standalone apps on a webpage or embed them in R Markdown documents or build dashboards. You can also extend your Shiny apps with CSS themes, htmlwidgets, and JavaScript actions.
# MAGIC 
# MAGIC You can develop, host, and share Shiny applications directly from a Databricks notebook. The Shiny package is included with Databricks Runtime. You can interactively develop and test Shiny applications inside Databricks R notebooks similarly to hosted RStudio
# MAGIC 
# MAGIC Let's look at a few [examples](https://docs.databricks.com/spark/latest/sparkr/shiny-notebooks.html) of how to use Shiny in Databricks. In all examples,
# MAGIC - Log messages appear in the command result, similar to the default log message (Listening on http://0.0.0.0:5150) shown in the example
# MAGIC - To stop the Shiny application, click Cancel
# MAGIC - The Shiny application uses the notebook R process. If you detach the notebook from the cluster, or if you cancel the cell running the application, the Shiny application teminates. You cannot run other cells while the Shiny application is running
# MAGIC - The Shiny app URL generated when you start an app is shareable with other users. Any Databricks user with Can Attach To permission on the cluster can view and interact with the app as long as both the app and the cluster are running

# COMMAND ----------

# MAGIC %md ## hello world example

# COMMAND ----------

library(shiny)
runExample("01_hello")

# COMMAND ----------

# MAGIC %md ## Run Shiny applications from files
# MAGIC 
# MAGIC If your Shiny application code is part of a project managed by version control, you can run it inside the notebook. Here, we'll access a full [tutorial](https://shiny.rstudio.com/tutorial/) of pre-built Shiny example apps. 

# COMMAND ----------

# MAGIC %sh mkdir /tmp/shiny_example;
# MAGIC cd /tmp/shiny_example;
# MAGIC git clone https://github.com/rstudio/shiny-examples.git

# COMMAND ----------

library(shiny)
runApp("/tmp/shiny_example/shiny-examples/007-widgets/")

# COMMAND ----------

# MAGIC %md ## Use SparkR with Shiny in a notebook

# COMMAND ----------

library(shiny)
library(SparkR)
sparkR.session()

ui <- fluidPage(
  mainPanel(
    textOutput("value")
  )
)

server <- function(input, output) {
  output$value <- renderText({ nrow(createDataFrame(iris)) })
}

shinyApp(ui = ui, server = server)

# COMMAND ----------

# MAGIC %md ## Use sparklyr with Shiny in a notebook

# COMMAND ----------

library(shiny)
library(sparklyr)

sc <- spark_connect(method = "databricks")

ui <- fluidPage(
  mainPanel(
    textOutput("value")
  )
)

server <- function(input, output) {
  output$value <- renderText({
    df <- sdf_len(sc, 5, repartition = 1) %>%
      spark_apply(function(e) sum(e)) %>%
      collect()
    df$result
  })
}

shinyApp(ui = ui, server = server)