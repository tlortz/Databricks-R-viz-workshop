# Databricks notebook source
# MAGIC %md # Using R visualization libraries other than ggplot and Databricks' `display()` 
# MAGIC 
# MAGIC Following examples from the [Databricks documentation](https://docs.databricks.com/notebooks/visualizations/index.html#visualizations-in-r)

# COMMAND ----------

# MAGIC %md ## Base R 
# MAGIC 
# MAGIC You can use the default R [plot](https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/plot) function

# COMMAND ----------

fit <- lm(Petal.Length ~., data = iris)
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(fit)

# COMMAND ----------

# MAGIC %md ## Lattice
# MAGIC 
# MAGIC The [Lattice](https://www.statmethods.net/advgraphs/trellis.html) package supports trellis graphs—graphs that display a variable or the relationship between variables, conditioned on one or more other variables

# COMMAND ----------

library(lattice)
library(ggplot2) #only needed to make the diamonds dataset available
xyplot(price ~ carat | cut, diamonds, scales = list(log = TRUE), type = c("p", "g", "smooth"), ylab = "Log price")

# COMMAND ----------

# MAGIC %md ## DandEFA
# MAGIC 
# MAGIC The [DandEFA](https://www.rdocumentation.org/packages/DandEFA/versions/1.6) package supports dandelion plots

# COMMAND ----------

install.packages("DandEFA", repos = "https://cran.us.r-project.org")
library(DandEFA)
data(timss2011)
timss2011 <- na.omit(timss2011)
dandpal <- rev(rainbow(100, start = 0, end = 0.2))
facl <- factload(timss2011,nfac=5,method="prax",cormeth="spearman")
dandelion(facl,bound=0,mcex=c(1,1.2),palet=dandpal)
facl <- factload(timss2011,nfac=8,method="mle",cormeth="pearson")
dandelion(facl,bound=0,mcex=c(1,1.2),palet=dandpal)