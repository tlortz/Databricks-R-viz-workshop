# Databricks notebook source
# MAGIC %md # Data visualization of Spark data frames using R and Databricks utilities
# MAGIC 
# MAGIC The ggplot notebook we just reviewed was elegant and powerful. However, ggplot is limited to R data frames. What should we do to get visual insights on larger data sets, where we need to use Spark to process them? 

# COMMAND ----------

# MAGIC %md ## Library and session setup
# MAGIC 
# MAGIC Let's work in sparklyr, though it would only take minor changes to do the same workflow in SparkR

# COMMAND ----------

library(sparklyr)
library(dplyr)
library(ggplot2)
library(magrittr)
# note, not installing the whole tidyverse to avoid some namespace conflicts, e.g. between purrr and sparklyr

sc <- spark_connect(method = "databricks")

# COMMAND ----------

# MAGIC %md ## Load data into Spark
# MAGIC 
# MAGIC Let's start by loading the same `mpg` dataset from base R into Spark. We're going to copy it into the Spark context, and name the Spark dataframe `mpg_spark`. We'll also implicitly create a Spark SQL temp view called `mpg`, which is very helpful if we later want to work with the same data in SparkR, PySpark or SparkSQL

# COMMAND ----------

mpg_spark <- sparklyr::copy_to(sc, df=mpg, name="mpg", overwrite=TRUE)
class(mpg_spark)

# COMMAND ----------

# MAGIC %md ## Basic descriptive statistics

# COMMAND ----------

mpg_spark

# COMMAND ----------

mpg_spark %>% sparklyr::sdf_nrow()

# COMMAND ----------

mpg_spark %>% dplyr::count()

# COMMAND ----------

summary <- sparklyr::sdf_describe(mpg_spark) %>% collect()

display(summary)

# COMMAND ----------

# MAGIC %md ## Creating a plot with ggplot
# MAGIC 
# MAGIC Let's try what we did previously with ggplot...

# COMMAND ----------

ggplot(data = mpg_spark) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# COMMAND ----------

# MAGIC %md Yay, it worked! 
# MAGIC 
# MAGIC However, it will not always work so nicely. Why? Because ggplot implicitly runs as a single-node process on the whole dataframe. For large data frames, this will result in an out-of-memory error when the Spark data frame is "collected" to the driver node as an R data frame. `collect()` operations can be slow, and on multi-user clusters, can make your co-workers very unhappy if you bring down the cluster. Use with caution!
# MAGIC 
# MAGIC How to get around that problem? 

# COMMAND ----------

# MAGIC %md ## Native Databricks plotting capabilities
# MAGIC 
# MAGIC There are a few ways to deal with the problem of plotting Spark-sized data, but perhaps the simplest of them is the `display()` function that is unique to Databricks. Passing a Spark DataFrame to `display()` will render a sortable table that can also be configured as a visualization.
# MAGIC 
# MAGIC Note that we need to use the SparkR API to directly expose the Spark data frame (sparklyr only exposes a reference to the Spark SQL table). There are many ways to do this; one of the simplest is the ultra-flexible `SparkR::sql()` command

# COMMAND ----------

library(SparkR)

# COMMAND ----------

display(SparkR::sql("select * from mpg"))

# COMMAND ----------

display(SparkR::sql("select * from mpg"))

# COMMAND ----------

display(SparkR::sql("select * from mpg"))

# COMMAND ----------

# MAGIC %md
# MAGIC While `display()` does not offer the full flexibility of ggplot to customize graphs, or to write reusable plotting functions, it has some advantages:
# MAGIC - It will naturally sample and/or aggregate from the source Spark dataframe without risk of out-of-memory errors
# MAGIC - It has a true no-code UI for toggling variables, changing the plot type, and more
# MAGIC 
# MAGIC 
# MAGIC Note that `display()` also works the same way for base R data frames:

# COMMAND ----------

class(mpg)

# COMMAND ----------

display(mpg)

# COMMAND ----------

# MAGIC %md ## Preprocessing with sparklyr or dplyr
# MAGIC 
# MAGIC A common-sense alternative is to 
# MAGIC - Use Spark APIs to enrich, transform, aggregate and collect the source data into a data frame small enough to fit in a base R data frame
# MAGIC - Use ggplot or other R graphing libraries on the collected data

# COMMAND ----------

mpg_mean_by_cyl_class <- mpg_spark %>%
  dplyr::group_by(cyl, class) %>%
  dplyr::summarise(hwy_mean = mean(hwy), cty_mean = mean(cty)) %>%
  sparklyr::collect()

mpg_mean_by_cyl_class

# COMMAND ----------

ggplot(data = mpg_mean_by_cyl_class) + 
  geom_point(mapping = aes(x = hwy_mean, y = cty_mean, color= class)) + 
  facet_wrap(~cyl) + 
  theme_light()