# =====================================================
# Project 
# - What are top factors affecting life expectancy?
# - With what accuracy can we predict a country's life expectancy based upon these factors?
# - Classification Model: Can we predict if a country will have a life expectancy >= 65

# Mike Hankinson
# 11/24/2021
# =====================================================
#
# Process
# __________________________________________
# 1. Load and Clean Data
# 2. Plot and Visualize Data (from 2014 only)
# 3. Scale/Normalize Data
# 4. Perform Exploratory Analysis 
#     a. Scatter Plot Matrix of Scaled Data
#     b. Calculate Descriptive Statistics
#     c. Corrplot() Analysis
#     d. Create Training and Testing Data
# 5. Unsupervised Modeling: Perform Clustering and Dimension Reduction
#     a. Perform Kmeans Iteration
#     b. Elbow Plot: Determine Number of Clusters 
#     c. Perform PCA: Verify Cluster Number
#     d. Create Covariance and Correlation Matrices
#     e. Select the Number of Factors
#     f. i. Plotting Factors and Loadings
#        ii.Extract Insights
#     g. Bi plot of Loadings and Component scores
# 6. Supervised Modeling
#     a. Perform Multivariate Linear Regression Modeling
#        i. Obtain Predictor Correlations
#       ii.Perform Linear Model (training data, top 3 +/- correlated predictors)
#      iii.Unrestricted Model: Perform Linear Model (training data, all predictors)
#       iv. Detecting Multicollinearity: Valuation Inflation Factor
#        v. Predictor Selection Using Akaike Information Criteria (AIC)
#       vi. Run Final Training Model
#      vii. Run Testing Model
#     viii. Visualize Linear Model Results
# 7. Classification Modeling
#     a. Load, Clean and Scale Data
#     b. Perform Generalized Linear Model
#        i. Convert Dependent Variable to Type Factor  
#       ii. Run Model / Obtain Log(odds)
#      iii. Define Classification Rule / Make Predictions
#       iv. Create Confusion Matrix and Statistics - Compare Predicted Classes to Actual



# Libraries
# __________________________________________
library(tidyverse)
library(gridExtra)
library(cluster)
library(factoextra)
library(car)

#install.packages("lares")


# 1. Load and Clean Data
# ------------------------------------------
dat <- read.csv("Life Expectancy Data.csv")
head(dat)
dim(dat)            # [1] 2938   22


# Extract 2014 data  for Analysis Only  (**Attempt with all years data**)
dat2014 <- subset (dat, dat$Year==2014)
head(dat2014)
dim(dat2014)        # [1] 183  22

datallyears <- dat


# Remove Rows with NA
dat2014 <- na.omit(dat2014) 
dim(dat2014)        # [1]  131 22


datallyears <- na.omit(datallyears) 
dim(datallyears)    # [1] 1649   22


# Define Data
# ..........................................
# - Country:  Country
# - Year:  Year of Data
# - Status:  Developed or Developing status
# - Life expectancy :  Life Expectancy in age
# - Adult Mortality:  Adult Mortality Rates of both sexes (probability of dying 
#   between 15 and 60 years per 1000 population)
# - infant deaths:  Number of Infant Deaths per 1000 population
# - Alcohol:  Alcohol, recorded per capita (15+) consumption (in litres of pure alcohol)
# - percentage expenditure:  Expenditure on health as a percentage of GDP per capita(%)
# - Hepatitis B:  Hepatitis B (HepB) immunization coverage among 1-year-olds (%)
# - Measles :  Measles - number of reported cases per 1000 population
# - BMI :  Average Body Mass Index of entire population
# - under-five deaths :  Number of under-five deaths per 1000 population
# - Polio:  Polio (Pol3) immunization coverage among 1-year-olds (%)
# - Total expenditure:  General government expenditure on health as a percentage of total 
#   government expenditure (%)
# - Diphtheria :  Diphtheria tetanus toxoid and pertussis (DTP3) immunization coverage 
#   among 1-year-olds (%)
# - HIV/AIDS:  Deaths per 1 000 live births HIV/AIDS (0-4 years)
# - GDP:  Gross Domestic Product per capita (in USD)
# - Population:  Population of the country
# - thinness  1-19 years:  Prevalence of thinness among children and adolescents for Age 
#   10 to 19 (% )
# - thinness 5-9 years:  Prevalence of thinness among children for Age 5 to 9(%)
# - Income composition of resources:  Human Development Index in terms of income 
#   composition of resources (index ranging from 0 to 1)
# - Schooling:  Number of years of Schooling(years)


# 2. Plot and Visualize Data (from 2014 only)
# -------------------------------
plot1a <- dat2014 %>% 
  ggplot(aes(x = "All Countries", y = Life.expectancy)) + 
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "blue") +
  labs(x = "", y="Life Expectancy")


plot1 <- dat2014 %>% 
  ggplot(aes(x = "All Countries", y = Alcohol)) + 
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "blue") +
  labs(x = "", y="Alcohol")


plot2 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = infant.deaths)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "orange") +
  labs(x = "", y="Infant Deaths")

plot3 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = percentage.expenditure)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "green") +
  labs(x = "", y="% Expenditure")

plot4 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = Hepatitis.B)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "red") +
  labs(x = "", y="Hepatitis B")

plot5 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = Measles)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "violet") +
  labs(x = "", y="Measles")

plot6 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = BMI)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "yellow") +
  labs(x = "", y="Body Mass Index")

plot7 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = Polio)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "black") +
  labs(x = "", y="Polio")

plot8 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y = Diphtheria)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "blue") +
  labs(x = "", y="Diphtheria")

plot9 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y =  HIV.AIDS)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "blue") +
  labs(x = "", y=" HIV/AIDS")

plot10 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y =  Schooling)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "blue") +
  labs(x = "", y="Schooling")

plot11 <- dat2014 %>%
  ggplot(aes(x = "All Countries", y =  GDP)) +
  geom_jitter(width = .025, height = 0, size = 2, alpha = .5, color = "blue") +
  labs(x = "", y="GDP")


grid.arrange(plot1a, plot1, plot2, plot3, plot4, plot5, plot6, plot7, plot8, 
             plot9, plot10, plot11)



# 3. Scale/Normalize Data
# -------------------------------
# Normalize dat2014
dat2014N <- sapply(dat2014[,5:22], function(z) (z-min(z))/(max(z)-min(z)))
# Column bind first 4 columns of dat2014 with dat2014N
dat2014N <- cbind(dat2014[,1:4], dat2014N)
dim(dat2014N)  # [1] 131  22


# Normalize datallyears
datallyearsN <- sapply(datallyears[,5:22], function(z) (z-min(z))/(max(z)-min(z)))
datallyearsN <- cbind(datallyears[,1:4], datallyearsN)
dim(datallyearsN) # [1] 1649   22


# Reassign Index Numbers to Consecutive Sequence
rownames(dat2014N) <- 1:nrow(dat2014N)
rownames(datallyearsN) <- 1:nrow(datallyearsN)



# 4. Perform Exploratory Analysis 
# -------------------------------

# a. Scatter Plot Matrix of Scaled Data
# ...............................
# Too Cluttered
# pairs(~ datallyears$Life.expectancy+ datallyears$Adult.Mortality+ datallyears$infant.deaths+
#       datallyears$Alcohol+ datallyears$Hepatitis.B+ datallyears$Measles+
#       datallyears$BMI+ datallyears$under.five.deaths+ datallyears$Polio+ datallyears$Total.expenditure+ datallyears$Diphtheria+
#       datallyears$HIV.AIDS+ datallyears$GDP+ datallyears$Income.composition.of.resources+ datallyears$Schooling, data = dat2014N,
#       lower.panel = panel.smooth)


# b. Calculate Descriptive Statistics
# ...............................
summary(dat2014N[,4:22])
summary(datallyearsN[,4:22])


# c. Corrplot()
# ...............................
library(corrplot)
# In corrplot(), the argument order="hclust" reorders the rows and columns according to variables'
# similarity in a hierarchical cluster solution

corrplot(cor(dat2014N[5:22]), order="hclust")




# d. Create Training and Testing Data
# ...............................

train.rows.2014 <- sample(1:131, 92)
train.rows.allyears <- sample(1:1649, 1154)

train.2014 <- dat2014N[train.rows.2014,]
train.allyears <- datallyearsN[train.rows.allyears,]
dim(train.allyears)   # [1] 1154   22

# 2014 Only Test Data
`%notin%` <- Negate(`%in%`)
range <- 1:131
holdout.2014 <- vector()
for(i in range) {
  if(i %notin% train.rows.2014) {
    holdout.2014[i] <- i
  }
}


holdout.2014 <- holdout.2014[!is.na(holdout.2014)]
# test.2014 <- train.2014[holdout.2014,] -- Original
test.2014 <- dat2014N[holdout.2014,]
test.2014<- na.omit(test.2014) 


dim(train.2014)   # [1] 92 22
dim(test.2014)    # [1] 27 22


# 5. Unsupervised Modeling: Perform Clustering and Dimension Reduction
# -------------------------------
# Perform on all normalized 2014 data, not subset of train/test

# a. Perform Kmeans Iteration
# ...............................

# Model 2-7 clusters
#Create vector to record in-cluster sum-of-squares model run
withinss <- numeric(7) 
# Initialize empty 7X9 matrix to record proportion of population in each cluster for each model iteration
size <- matrix(NA,7,9) 
# Populate column 1 with number of clusters for each iteration (2 clusters - 8 clusters) 
size[,1] <- 2:8
# Set n to equal the number of rows in the train.2014 data set
n <- nrow(dat2014N)


for(i in 2:8){
  name <- paste("km.object.of7", i, sep = ".") #create name based upon the number of cluster
  temp <- assign(name, kmeans(dat2014N[5:22], centers = i, nstart=50)) #Use assign() to perform Kmeans based upon index, i. saves a kmeans object for each loop iteration
  withinss[i-1] <- temp$tot.withinss #saves the within-cluster sum-of-squares and the appropriate index
  size[i-1, 2:(i+1)] <- round(temp$size/n, 4) #save the cluster size proportions
}         


# b. Elbow Plot: Determine Number of Clusters 
# ...............................
plot(withinss, type="b", pch=16, xaxt="n",xlab="# of clusters", main="Elbow Plot")
axis(1, at=1:7, labels=2:8)
size

# Result: 3 or 6 Clusters
# By Analyzing the chart, we can see that when the number of groups (K) 
# could be both 3 and 6  (there is a slope change in increase in the sum of squares), 

# The main purpose is to find a fair number of groups that could explain satisfactorily a considerable part of the data.
# Based upon elbow plot, select and evaluate 6 clusters.


# c. Perform PCA: Verify Cluster Number
# ...............................
# Note: 
# - PCA Methodology rotates the axis of the data to **REPLACE VARIABLES with 
#   FACTORS/COMPONENTS (interchangeable)** 
#   that maximize the variation of the data projected onto that axis.
# 
# - LOADINGS are coefficients of FACTORS that link to the original data like the following:
#           ~ ORIGINAL DATA = FACTORS * transpose[LOADINGS]
#           ~ For matrix vectors A and X of size n, LAMBDA*A = LAMBDA*X
#           ~ LAMBDA = scalar and is EIGEN VALUE for both A and X 
#
# The EIGEN VECTOR associated with the 
# HIGHEST EIGEN VALUE = LOADING associated with the FIRST PRINCIPAL COMPONENT


dat2014N.pca <- princomp(dat2014N[5:22])  

    # Standard deviations:
    #   Comp.1      Comp.2      Comp.3      Comp.4      Comp.5      Comp.6      Comp.7 
    # 0.500876944 0.346899857 0.241961695 0.228629517 0.194411885 0.180898377 0.149670461 
    # Comp.8      Comp.9     Comp.10     Comp.11     Comp.12     Comp.13     Comp.14 
    # 0.134324886 0.131510814 0.126528373 0.101643288 0.072950120 0.069364674 0.053260803 
    # Comp.15     Comp.16     Comp.17     Comp.18 
    # 0.046351942 0.030355353 0.025582687 0.003923336 
    # 
    # 18  variables and  131 observations.


# d. Create Covariance and Correlation Matrices
# ...............................
cumulative_variation_VAF <- cumsum(dat2014N.pca$sdev^2/sum(dat2014N.pca$sdev^2))  # VAF
    # Comp.1    Comp.2    Comp.3    Comp.4    Comp.5    Comp.6    Comp.7    Comp.8 
    # 0.3839900 0.5681800 0.6577889 0.7377949 0.7956449 0.8457322 0.8800192 0.9076359 
    
    # Comp.9   Comp.10   Comp.11   Comp.12   Comp.13   Comp.14   Comp.15   Comp.16 
    # 0.9341075 0.9586113 0.9744243 0.9825697 0.9899341 0.9942759 0.9975644 0.9989747 

    # Comp.17   Comp.18 
    # 0.9999764 1.0000000 

summary(dat2014N.pca)
    # Importance of components:
    #                         Comp.1    Comp.2     Comp.3     Comp.4     Comp.5     Comp.6     Comp.7
    # Standard deviation     0.5008769 0.3468999 0.24196170 0.22862952 0.19441189 0.18089838 0.14967046
    # Proportion of Variance 0.3839900 0.1841900 0.08960889 0.08000598 0.05785002 0.05008725 0.03428704
    # Cumulative Proportion  0.3839900 0.5681800 0.65778893 0.73779491 0.79564493 0.84573218 0.88001922
    
    #                         Comp.8     Comp.9    Comp.10    Comp.11     Comp.12     Comp.13     Comp.14
    # Standard deviation     0.13432489 0.13151081 0.12652837 0.10164329 0.072950120 0.069364674 0.053260803
    # Proportion of Variance 0.02761664 0.02647164 0.02450381 0.01581304 0.008145352 0.007364352 0.004341835
    # Cumulative Proportion  0.90763586 0.93410750 0.95861131 0.97442435 0.982569701 0.989934053 0.994275888
    
    #                         Comp.15     Comp.16     Comp.17      Comp.18
    # Standard deviation     0.046351942 0.030355353 0.025582687 3.923336e-03
    # Proportion of Variance 0.003288469 0.001410355 0.001001729 2.355965e-05
    # Cumulative Proportion  0.997564357 0.998974712 0.999976440 1.000000e+00




# e. Select the Number of Factors -- Verify Cluster Number from Above
# ...............................
plot(cumulative_variation_VAF, type="b", pch=16, xlab="# Components", ylab="VAF", main="PCA Elbow Plot", xaxt="n")
axis(1, at=1:18, labels=paste0("PC",1:18))


# Argument could be made for either 2 - 6 principal components
# based upon breaking point within the elbow plot:  
# With 6 Principal Components: 
#     - Dimension reduction from 18 to 6
#     - Still accounting for 84.6% of the variance



# f. i. Plotting Factors and Loadings
#    ii.Extract Insights
# ...............................
# The key to interpreting our principal components will often be found in the LOADINGS. 
# The LOADINGS (Eigen VALUES/VECTORS) are the values that explain how factors are connected to the original variables that we are attempting to analyze.
#     ORIGINAL DATA = FACTORS * transpose[LOADINGS]

# --Component 1 Loading Plot--
plot(dat2014N.pca$loadings[,1], type="b", xaxt="n", col="dodgerblue", pch=16, 
     xlab="Variable", ylab="Loadings", main="Loadings for Component 1")
axis(1,1:18, c("A. Mortality", "Infant Deaths", "Alcohol", "% Expen", "Hep.B", "Measels", "BMI", "<5Deaths", "Polio", 
               "TotExpen", "Dipth", "HIV/AIDS", "GDP","Pop.", ">19thin", "5-9thin",
               "Income Index", "School"))
#axis(1,1:18, c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16","17", "18"))
abline(h=0, lty=2)  # abline() adds line to an existing graph


# --Component 2 Loading Plot--
plot(dat2014N.pca$loadings[,2], type="b", xaxt="n", col="dodgerblue", pch=16, 
     xlab="Variable", ylab="Loadings", main="Loadings for Component 2")
axis(1,1:18, c("A. Mortality", "Infant Deaths", "Alcohol", "% Expen", "Hep.B", "Measels", "BMI", "<5Deaths", "Polio", 
               "TotExpen", "Dipth", "HIV/AIDS", "GDP","Pop.", ">19thin", "5-9thin",
               "Income Index", "School"))
#axis(1,1:18, c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16","17", "18"))
abline(h=0, lty=2)  # abline() adds line to an existing graph


# --Component 3 Loading Plot--
plot(dat2014N.pca$loadings[,3], type="b", xaxt="n", col="dodgerblue", pch=16, 
     xlab="Variable", ylab="Loadings", main="Loadings for Component 3")
axis(1,1:18, c("A. Mortality", "Infant Deaths", "Alcohol", "% Expen", "Hep.B", "Measels", "BMI", "<5Deaths", "Polio", 
               "TotExpen", "Dipth", "HIV/AIDS", "GDP","Pop.", ">19thin", "5-9thin",
               "Income Index", "School"))
axis(1,1:18, c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16","17", "18"))
abline(h=0, lty=2)  # abline() adds line to an existing graph


# --Component 4 Loading Plot--
plot(dat2014N.pca$loadings[,4], type="b", xaxt="n", col="dodgerblue", pch=16, 
     xlab="Variable", ylab="Loadings", main="Loadings for Component 4")
axis(1,1:18, c("A. Mortality", "Infant Deaths", "Alcohol", "% Expen", "Hep.B", "Measels", "BMI", "<5Deaths", "Polio", 
               "TotExpen", "Dipth", "HIV/AIDS", "GDP","Pop.", ">19thin", "5-9thin",
               "Income Index", "School"))
# axis(1,1:18, c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16","17", "18"))
abline(h=0, lty=2)  # abline() adds line to an existing graph



# - Demonstrates positive and negative factors

# - This appears to be an ideal solution for determining important variables for 
#   the prediction of life expectancy.  



# g. Bi plot of Loadings and Component scores
# ...............................
# biplot for components 1 and 2
biplot(dat2014N.pca)

    # Result:
    # For PC1 and PC2, the map contains 3 distinct areas of life expectancy factors.  
    # From there, the countries are non-distinguishable within this plot. 


# 6. Supervised Modeling
# ..........................................
# ***Note to instructors:  I am unsure how to use PCA analysis as input for reduced factors
# within my multivariate model.***  


# a. Perform Multivariate Linear Regression Modeling
# ...............................

# i. Obtain Predictor Correlations
# . . . . . . . . . . . . . . . . 
cor(dat2014N[4:22])

# Entire correlation data too busy.  
# Obtain correlation vector for Life.expectancy only. 

life_cor <- cor(dat2014N[4:22])[1,]


  # Life.expectancy             Adult.Mortality 
  # 1.00000000                     -0.77006889 

  # infant.deaths               Alcohol 
  # -0.20094246                      0.52951003

  # percentage.expenditure      Hepatitis.B 
  # 0.41259578                      0.25209759

  # Measles                     BMI 
  # -0.04875626                      0.55522649

  # under.five.deaths           Polio 
  # -0.22857019                      0.38515579 

  # Total.expenditure           Diphtheria 
  # 0.31931099                      0.34246355

  # HIV.AIDS                    GDP 
  # -0.61710562                      0.44377093

  # Population                  thinness..1.19.years 
  # -0.03599048                     -0.43694419 

  # thinness.5.9.years          Income.composition.of.resources 
  # -0.46095903                      0.89201700 

  # Schooling 
  # 0.80179634 

# Notes: 
#   - Education and income index have the strongest positive correlation to life expectancy.  
#   - Adult mortality and HIV/AIDS have strongest negative correlation to life expectancy.   


# ii.Restricted Model: Perform Linear Model (training data, top 3 +/- correlated predictors)
# . . . . . . . . . . . . . . . . 
# Perform linear model using
#   - training data
#   - top 3 positive and negatively correlated predictors to life expectancy


train.2014.restricted.lm <- lm(Life.expectancy ~  Income.composition.of.resources + Schooling + BMI +  
                    thinness.5.9.years + HIV.AIDS + Adult.Mortality,
                    train.2014)

summary(train.2014.restricted.lm)
    # Residuals:
    #   Min      1Q  Median      3Q     Max 
    # -8.4703 -1.9701  0.0248  1.7024  7.8928 
    # 
    # Coefficients:
    #                                 Estimate  Std. Error t value  Pr(>|t|)    
    # (Intercept)                      61.5728     1.8579  33.142  < 2e-16 ***
    # Income.composition.of.resources  20.5350     3.6603   5.610 2.47e-07 ***
    # Schooling                         1.9825     4.3349   0.457 0.648598    
    # BMI                               0.5165     1.8169   0.284 0.776880    
    # thinness.5.9.years               -3.4692     2.6446  -1.312 0.193110    
    # HIV.AIDS                         -7.4213     2.3618  -3.142 0.002309 ** 
    # Adult.Mortality                  -8.1121     2.3679  -3.426 0.000946 ***
    #   ---
    #   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    # 
    # Residual standard error: 3.12 on 85 degrees of freedom
    # Multiple R-squared:  0.891,	Adjusted R-squared:  0.8833 
    # F-statistic: 115.8 on 6 and 85 DF,  p-value: < 2.2e-16


#iii.Unrestricted Model: Perform Linear Model (training data, all predictors)
# . . . . . . . . . . . . . . . .
# Perform linear model using
#   - training data
#   - all predictors to life expectancy


train.2014.unrestricted.lm <- lm(Life.expectancy ~  Income.composition.of.resources + Schooling + BMI + 
                                   Alcohol + GDP + percentage.expenditure + Polio + Diphtheria + Polio +
                                   Total.expenditure + Hepatitis.B +  
                                   Population + Measles + infant.deaths + under.five.deaths + thinness..1.19.years +
                                   thinness.5.9.years + HIV.AIDS + Adult.Mortality,
                               train.2014)

summary(train.2014.unrestricted.lm)
    # Residuals:
    #   Min      1Q  Median      3Q     Max 
    # -8.9632 -1.8004  0.0834  1.5815  7.7089 
    # 
    # Coefficients:
    #                               Estimate    Std. Error t value   Pr(>|t|)    
    # (Intercept)                      62.0314     2.4454  25.367  < 2e-16 ***
    # Income.composition.of.resources  19.8332     4.3730   4.535 2.21e-05 ***
    # Schooling                         0.5081     4.8345   0.105  0.91658    
    # BMI                               0.1244     2.1316   0.058  0.95363    
    # Alcohol                           0.5018     1.8477   0.272  0.78670    
    # GDP                              -5.3471     8.2454  -0.648  0.51870    
    # percentage.expenditure            6.8936     7.8345   0.880  0.38180    
    # Polio                            -1.9991     2.4720  -0.809  0.42133    
    # Diphtheria                        0.7043     4.8694   0.145  0.88540    
    # Total.expenditure                 1.2050     1.9959   0.604  0.54788    
    # Hepatitis.B                       2.1176     4.1934   0.505  0.61509    
    # Population                        8.0152    25.2668   0.317  0.75198    
    # Measles                          -5.8022    18.9642  -0.306  0.76051    
    # infant.deaths                    34.7934    74.3332   0.468  0.64113    
    # under.five.deaths               -31.9728    63.9492  -0.500  0.61860    
    # thinness..1.19.years              1.3293     9.3930   0.142  0.88785    
    # thinness.5.9.years               -7.1737     9.6642  -0.742  0.46029    
    # HIV.AIDS                         -7.1994     2.5314  -2.844  0.00578 ** 
    # Adult.Mortality                  -8.5469     2.5946  -3.294  0.00152 ** 
    #   ---
    #   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    # 
    # Residual standard error: 3.209 on 73 degrees of freedom
    # Multiple R-squared:  0.901,	Adjusted R-squared:  0.8766 
    # F-statistic: 36.91 on 18 and 73 DF,  p-value: < 2.2e-16

cbind(Unrestricted=sum(train.2014.unrestricted.lm$residuals^2), Restricted=sum(train.2014.restricted.lm$residuals^2))
    #       Unrestricted Restricted
    # [1,]     751.6448   827.6418


# Thoughts........
# - Sum of Squares reduced with all predictors included. 
# - Multiple low P-Valued predictors could be good candidates for final model inclusion. 
# - What about colinearity?



# iv. Detecting Multicollinearity: Valuation Inflation Factor
# . . . . . . . . . . . . . . . .
# - Evaluate the Variance Inflation Factor (VIF) for each predictor in the model
# - VIF informs us how much the variance of the coefficient estimate increases for a 
#   predictor when including it in the same model as the other predictors, 
#   or in other words to what factor the precision of the estimate will be harmed and the 
#   confidence interval will be widened. 
# - For a particular variable, VIF is calculated by performing a regression with that variable as 
#   the response and the other variables as the predictors.


# - VIF lower bound: 1 (two predictors are completely uncorrelated, VIF=1)
# the variance of the estimates are 1x greater when the predictors are included together
# (i.e., the variance is unchanged).
# - Upper acceptable bound: 5 (if include predictors with values above this threshold, 
# need to be aware that estimate precision is likely to be significantly affected). 
# If 2 variables are highly correlated they will both have a high VIF value


#library(car)

# --Restricted Model--
VIF.2014.restricted <- vif(train.2014.restricted.lm)
    # Income.composition.of.resources     Schooling 
    # 9.380275                            6.562013 
    # BMI                                 thinness.5.9.years 
    # 2.260136                            1.707137 
    # HIV.AIDS                            Adult.Mortality 
    # 1.879727                            2.615192 


# --Unrestricted Model--
VIF.2014.unrestricted <- vif(train.2014.unrestricted.lm)
    # Income.composition.of.resources       Schooling 
    # 12.660749                             7.718027 
    # BMI                                   Alcohol 
    # 2.941881                              2.324621 
    # GDP                                   percentage.expenditure 
    # 12.124875                             11.858110 
    # Polio                                 Diphtheria 
    # 3.046543                              10.582413 
    # Total.expenditure                     Hepatitis.B 
    # 1.440861                              8.851350 
    # Population                            Measles 
    # 62.971477                             35.446782 
    # infant.deaths                         under.five.deaths 
    # 730.701956                            594.602826 
    # thinness..1.19.years                  thinness.5.9.years 
    # 20.385306                             21.558925 
    # HIV.AIDS                              Adult.Mortality 
    # 2.042069                              2.969129 


# Note: 
#   - Variance of infant.deaths and under.five.deaths are inflated several hundred times




# v. Predictor Selection Using Akaike Information Criteria (AIC)
# . . . . . . . . . . . . . . . .
# - At each iteration, the function will provide the AIC for the current model 
#   and the corresponding AIC if we were to remove any predictors or add a 
#   predictor not included back in.

# First, run model without inclusion of infant.deaths and under.five.deaths
train.2014.unrestricted.lm <- lm(Life.expectancy ~  Income.composition.of.resources + Schooling + BMI + 
                                   Alcohol + GDP + percentage.expenditure + Polio + Diphtheria + Polio +
                                   Total.expenditure + Hepatitis.B +  
                                   Population + Measles + thinness..1.19.years +
                                   thinness.5.9.years + HIV.AIDS + Adult.Mortality,
                                 train.2014)

step(train.2014.unrestricted.lm, direction="both")

# The lowest AIC contained the following:
    # lm(formula = Life.expectancy ~ Income.composition.of.resources +
    #      Population + thinness.5.9.years + HIV.AIDS + Adult.Mortality,
    #    data = train.2014)

# vi. Run Final Training Model
# . . . . . . . . . . . . . . . .
final.train.2014.lm <- lm(Life.expectancy ~ Income.composition.of.resources +
                            Population + thinness.5.9.years + HIV.AIDS + Adult.Mortality,
                          data = train.2014)
summary(final.train.2014.lm)


# vii. Run Testing Model
# . . . . . . . . . . . . . . . .
test.2014.lm <- lm(Life.expectancy ~ Income.composition.of.resources +
                     Population + thinness.5.9.years + HIV.AIDS + Adult.Mortality,
                   data = test.2014)
summary(test.2014.lm)
    # Residuals:
    #   Min      1Q  Median      3Q     Max 
    # -7.0821 -1.2327  0.4281  1.7906  5.9816 
    # 
    # Coefficients:
    #                                 Estimate  Std. Error t value Pr(>|t|)    
    # (Intercept)                       60.921      2.275  26.776  < 2e-16 ***
    # Income.composition.of.resources   22.649      2.729   8.299 1.38e-09 ***
    # Population                        -1.597      4.002  -0.399  0.69241    
    # thinness.5.9.years                 1.839      3.707   0.496  0.62313    
    # HIV.AIDS                          -5.089      3.494  -1.457  0.15470    
    # Adult.Mortality                  -10.220      2.869  -3.562  0.00114 ** 
    #   ---
    #   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    # 
    # Residual standard error: 2.868 on 33 degrees of freedom
    # Multiple R-squared:  0.8967,	Adjusted R-squared:  0.881 
    # F-statistic: 57.28 on 5 and 33 DF,  p-value: 2.615e-15


# viii. Visualize Linear Model Results
# . . . . . . . . . . . . . . . .
# https://datascienceplus.com/machine-learning-results-in-r-one-plot-to-rule-them-all-part-2-regression-models/

test.2014.lm.predictions <- data.frame(predict(test.2014.lm, test.2014))
dim(test.2014.lm.predictions)

data.vs.results.test.2014 <- cbind(test.2014[,1:4], test.2014.lm.predictions)


lares::mplot_lineal(tag = data.vs.results.test.2014$Life.expectancy, 
                    score = data.vs.results.test.2014[,5],
                    subtitle = "Longevity Model",
                    model_name = "test.2014.lm")



lares::mplot_cuts_error(tag = data.vs.results.test.2014$Life.expectancy, 
                        score = data.vs.results.test.2014[,5],
                        title = "Longevity Model",
                        model_name = "test.2014.lm")



lares::mplot_density(tag = data.vs.results.test.2014$Life.expectancy, 
                     score = data.vs.results.test.2014[,5],
                     subtitle = "Longevity Model",
                     model_name = "test.2014.lm")



lares::mplot_full(tag = data.vs.results.test.2014$Life.expectancy, 
                  score = data.vs.results.test.2014[,5],
                  subtitle = "Longevity Model",
                  model_name = "test.2014.lm",
                  save = T)


lares::mplot_splits(tag = data.vs.results.test.2014$Life.expectancy, 
                    score = data.vs.results.test.2014[,5],
                    split = 6)


# 7. Classification Modeling
# ------------------------------------------
# Data set doesn't contain categorical variables.  
# Therefore, add column detailing (0 or 1) whether or not life expectancy >= 65.  



# a. Load, Clean and Scale Data
# ..........................................
dat.L <- read.csv("Life Expectancy Data Logistic Regression.csv")

# Extract 2014 data  for Analysis Only  (**Attempt with all years data**)
dat2014.L <- subset (dat.L, dat.L$Year==2014)

# Remove Rows with NA
dat2014.L <- na.omit(dat2014.L) 
dim(dat2014.L)

# Normalize dat2014
dat2014N.L <- sapply(dat2014.L[,5:23], function(z) (z-min(z))/(max(z)-min(z)))
# Column bind first 4 columns of dat2014 with dat2014N
dat2014N.L <- cbind(dat2014.L[,1:4], dat2014N.L)
dim(dat2014N.L)  # [1] 131  23


# Reassign Index Numbers to Consecutive Sequence
rownames(dat2014N.L) <- 1:nrow(dat2014N.L)


# b. Perform Generalized Linear Model
# ..........................................

# i. Convert Dependent Variable to Type Factor
# . . . . . . . . . . . . . . . .
# Since the dependent variable is categorical and not numeric, 
# convert it to type factor for logistic regression and subsequent analysis.

Response <- as.factor(dat2014N.L$LE..65)


# ii. Run Model / Obtain Log(odds)
# . . . . . . . . . . . . . . . .
# Note: For this model, use the same 5 predictors as the final linear model.  


log.reg <- glm(Response ~ Income.composition.of.resources + Population + 
                 thinness.5.9.years + HIV.AIDS + Adult.Mortality, 
               family="binomial", data=dat2014N.L)
summary(log.reg)
    # Deviance Residuals: 
    #   Min        1Q    Median        3Q       Max  
    # -2.18871   0.00000   0.00012   0.00184   1.58287  
    # 
    # Coefficients:
    #                                 Estimate  Std. Error z value  Pr(>|z|)  
    # (Intercept)                       -7.396      3.681  -2.009   0.0445 *
    # Income.composition.of.resources   36.672     16.104   2.277   0.0228 *
    # Population                        -2.519     15.284  -0.165   0.8691  
    # thinness.5.9.years                 0.989      4.476   0.221   0.8251  
    # HIV.AIDS                         -35.117     18.584  -1.890   0.0588 .
    # Adult.Mortality                   -4.490      3.843  -1.168   0.2427  
    # ---
    #   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    # 
    # (Dispersion parameter for binomial family taken to be 1)
    # 
    # Null deviance: 147.879  on 130  degrees of freedom
    # Residual deviance:  14.589  on 125  degrees of freedom
    # AIC: 26.589
    # 
    # Number of Fisher Scoring iterations: 11


#iii. Define Classification Rule / Make Predictions
# ..........................................
# Define Log of Odds >= 0.5 as pass, 1
#        Log of Odds <  0.5 as fail, 0

predictions <- log.reg$fitted.values
predictions[predictions>=0.5] <- 1
predictions[predictions<0.5] <- 0
predictions <- as.factor(predictions)


# iv. Create Confusion Matrix and Statistics - Compare Predicted Classes to Actual
# ..........................................
library(caret)
confusionMatrix(predictions, Response, mode="prec_recall", positive = "1")

    # Reference
    # Prediction     0  1
    #             0 32  1
    #             1  1 97
    # 
    # Accuracy : 0.9847          
    # 95% CI : (0.9459, 0.9981)
    # No Information Rate : 0.7481          
    # P-Value [Acc > NIR] : 3.109e-14       
    # 
    # Kappa : 0.9595          
    # 
    # Mcnemar's Test P-Value : 1               
    #                                           
    #               Precision : 0.9898          
    #                  Recall : 0.9898          
    #                      F1 : 0.9898          
    #              Prevalence : 0.7481          
    #          Detection Rate : 0.7405          
    #    Detection Prevalence : 0.7481          
    #       Balanced Accuracy : 0.9797          
    #                                           
    #        'Positive' Class : 1     

# Model Results: Excellent model for predicting life expectancy >= 65
                
                
                
              


# rm(list = ls())      Removes global environment
                    