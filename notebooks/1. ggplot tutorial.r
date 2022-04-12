# Databricks notebook source
# MAGIC %md # Data Visualization with `ggplot2`
# MAGIC 
# MAGIC Borrowed & adapted from Chapter 3 of [R for Data Science](https://r4ds.had.co.nz/index.html) by Hadley Wickham & Garrett Grolemund

# COMMAND ----------

# MAGIC %md ## Installation
# MAGIC 
# MAGIC Install the tidyverse, which includes the graphing library ggplot2.
# MAGIC 
# MAGIC _Note, this library is pre-installed on the Databricks Machine Learning Runtime. If it is not installed on your cluster, you can install it at the [scope of your notebook](https://docs.databricks.com/libraries/notebooks-r-libraries.html) via_
# MAGIC 
# MAGIC `install.packages("tidyverse")`

# COMMAND ----------

library(tidyverse)

# COMMAND ----------

# MAGIC %md ## Creating a plot
# MAGIC 
# MAGIC Let’s use our first graph to answer a question: Do cars with big engines use more fuel than cars with small engines? You probably already have an answer, but try to make your answer precise. What does the relationship between engine size and fuel efficiency look like? Is it positive? Negative? Linear? Nonlinear?
# MAGIC 
# MAGIC You can test your answer with the mpg data frame found in ggplot2 (aka `ggplot2::mpg`). A data frame is a rectangular collection of variables (in the columns) and observations (in the rows). mpg contains observations collected by the US Environmental Protection Agency on 38 models of car.

# COMMAND ----------

mpg

# COMMAND ----------

# MAGIC %md To plot mpg, run this code to put displ on the x-axis and hwy on the y-axis

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# COMMAND ----------

# MAGIC %md
# MAGIC The plot shows a negative relationship between engine size (displ) and fuel efficiency (hwy). In other words, cars with big engines use more fuel. Does this confirm or refute your hypothesis about fuel efficiency and engine size?
# MAGIC 
# MAGIC With ggplot2, you begin a plot with the function `ggplot()`. `ggplot()` creates a coordinate system that you can add layers to. The first argument of `ggplot()` is the dataset to use in the graph. So `ggplot(data = mpg)` creates an empty graph, but it’s not very interesting so I’m not going to show it here.
# MAGIC 
# MAGIC You complete your graph by adding one or more layers to `ggplot()`. The function `geom_point()` adds a layer of points to your plot, which creates a scatterplot. ggplot2 comes with many geom functions that each add a different type of layer to a plot. You’ll learn a whole bunch of them throughout this chapter.
# MAGIC 
# MAGIC Each geom function in ggplot2 takes a mapping argument. This defines how variables in your dataset are mapped to visual properties. The mapping argument is always paired with `aes()`, and the x and y arguments of `aes()` specify which variables to map to the x and y axes. ggplot2 looks for the mapped variables in the data argument, in this case, mpg.

# COMMAND ----------

# MAGIC %md ## Using aesthetic mappings
# MAGIC 
# MAGIC You can add a third variable, like class, to a two dimensional scatterplot by mapping it to an aesthetic. An aesthetic is a visual property of the objects in your plot. Aesthetics include things like the size, the shape, or the color of your points. You can display a point (like the one below) in different ways by changing the values of its aesthetic properties. Since we already use the word “value” to describe data, let’s use the word “level” to describe aesthetic properties.
# MAGIC 
# MAGIC You can convey information about your data by mapping the aesthetics in your plot to the variables in your dataset. For example, you can map the colors of your points to the class variable to reveal the class of each car.

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# COMMAND ----------

# MAGIC %md 
# MAGIC To map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable inside `aes()`. ggplot2 will automatically assign a unique level of the aesthetic (here a unique color) to each unique value of the variable, a process known as scaling. ggplot2 will also add a legend that explains which levels correspond to which values.
# MAGIC 
# MAGIC The colors reveal that many of the unusual points are two-seater cars. These cars don’t seem like hybrids, and are, in fact, sports cars! Sports cars have large engines like SUVs and pickup trucks, but small bodies like midsize and compact cars, which improves their gas mileage. In hindsight, these cars were unlikely to be hybrids since they have large engines.
# MAGIC 
# MAGIC In the above example, we mapped class to the color aesthetic, but we could have mapped class to the size aesthetic in the same way. In this case, the exact size of each point would reveal its class affiliation. We get a warning here, because mapping an unordered variable (class) to an ordered aesthetic (size) is not a good idea.

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# COMMAND ----------

# MAGIC %md Or we could have mapped class to the alpha aesthetic, which controls the transparency of the points, or to the shape aesthetic, which controls the shape of the points.

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# COMMAND ----------

# MAGIC %md You can also set the aesthetic properties of your geom manually. For example, we can make all of the points in our plot yellow with a dark theme:

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "yellow") +
  theme_dark()

# COMMAND ----------

# MAGIC %md ## Facets
# MAGIC 
# MAGIC One way to add additional variables is with aesthetics. Another way, particularly useful for categorical variables, is to split your plot into facets, subplots that each display one subset of the data.
# MAGIC 
# MAGIC To facet your plot by a single variable, use facet_wrap(). The first argument of facet_wrap() should be a formula, which you create with ~ followed by a variable name (here “formula” is the name of a data structure in R, not a synonym for “equation”). The variable that you pass to facet_wrap() should be discrete.

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# COMMAND ----------

# MAGIC %md ## Geometric objects
# MAGIC 
# MAGIC A geom is the geometrical object that a plot uses to represent data. People often describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms, line charts use line geoms, boxplots use boxplot geoms, and so on. Scatterplots break the trend; they use the point geom. As we see above, you can use different geoms to plot the same data. The plot on the left uses the point geom, and the plot on the right uses the smooth geom, a smooth line fitted to the data.
# MAGIC 
# MAGIC To change the geom in your plot, change the geom function that you add to ggplot(). For instance `geom_point()` vs `geom_smooth()`:

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# COMMAND ----------

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# COMMAND ----------

# MAGIC %md Every geom function in ggplot2 takes a mapping argument. However, not every aesthetic works with every geom. You could set the shape of a point, but you couldn’t set the “shape” of a line. On the other hand, you could set the linetype of a line. `geom_smooth()` will draw a different line, with a different linetype, for each unique value of the variable that you map to linetype.

# COMMAND ----------

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# COMMAND ----------

# MAGIC %md To display multiple geoms in the same plot, add multiple geom functions to `ggplot()`

# COMMAND ----------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# COMMAND ----------

# MAGIC %md This, however, introduces some duplication in our code. Imagine if you wanted to change the y-axis to display cty instead of hwy. You’d need to change the variable in two places, and you might forget to update one. You can avoid this type of repetition by passing a set of mappings to `ggplot()`. ggplot2 will treat these mappings as global mappings that apply to each geom in the graph. In other words, this code will produce the same plot as the previous code:

# COMMAND ----------

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# COMMAND ----------

# MAGIC %md ## Databricks edge feature - Widgets and ggplot

# COMMAND ----------

# MAGIC %md One particularly useful set of `dbutils` functions are [Widgets](https://docs.azuredatabricks.net/user-guide/notebooks/widgets.html#widgets).  Widgets add a layer of parameterization to your notebooks that can be used when building dashboards and visualizations, training models, or querying data sources.  Think of widgets as turning your notebook into a function.
# MAGIC 
# MAGIC In the following example we'll create a widget to dynamically render the output of a plot. This can make it much easier to try many different variable plotting configurations without creating new plots. 
# MAGIC 
# MAGIC _Note: passing variable names to functions in R is quite a bit more complex than doing it in Python. This [tidyverse blog post](https://ggplot2.tidyverse.org/dev/articles/ggplot2-in-packages.html#using-aes-and-vars-in-a-package-function) gives some helpful patterns for passing dataframe column names as variables to ggplot._

# COMMAND ----------

dbutils.widgets.removeAll()

cols <- as.list(colnames(mpg))

## Instatiate the widgets
dbutils.widgets.dropdown(name = "Y-Variable", defaultValue = "hwy", choices = cols)
dbutils.widgets.dropdown(name = "X-Variable", defaultValue = "displ", choices = cols)

# COMMAND ----------

xValue <- dbutils.widgets.get("X-Variable")
yValue <- dbutils.widgets.get("Y-Variable")

ggplot(data=mpg, aes(x= .data[[xValue]], y = .data[[yValue]])) + 
  geom_point()

# COMMAND ----------

# MAGIC %md ## Next steps
# MAGIC 
# MAGIC The [online version of Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) has much more content, including how to work with
# MAGIC - Statistical transformations
# MAGIC - Position adjustments
# MAGIC - Coordinate systems
# MAGIC - The layered grammar of graphics
# MAGIC 
# MAGIC The website also has exercises for each topic, to help you better learn the content!