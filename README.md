# 7_Chicago_Capstone

## Skills and Tools
• Data Exploratory Analysis
• Unsupervised Modeling: Clustering and Dimension Reduction
• Supervised Modeling: Multivariate Linear Regression, Obtain Predictor Correlations, Linear Model, Detect Multicollinearity, Predictor Selection, Training and Testing Models

## Purpose
Watching my parents age, in addition to getting older myself, I have been interested in methods to extend life, in a quality manner.  I have read articles about blood pressure control, eating habits, effects of anxiety and depression, quality and quantity of sleep, effects of medications and exercise.  It seems everyone has the magic bullet, or at least a piece to the puzzle for becoming “younger” and living longer.

Over the years, many have studied, collectively, some of the known and measurable variables on longevity of life.  For instance, a study was conducted in the early 2000s by the University of Colorado, to validate and expand upon previous studies1.  Rather than look at variables affecting an individual (like the ones I was researching for myself), they looked at variables on the country/world-wide level. 

In this study, I would like to answer the following questions:
 1.	What are top factors affecting life expectancy?
 2.	With what accuracy can we predict a country's life expectancy based upon these factors?
 3.	Is it possible to predict if a population will have a life expectancy >= 65?

## Study Outline
Coding was completed in R using RStudio IDE.   The following defines the process used to complete the study:

1.	Load and Clean Data
2.	Plot and Visualize Data (from 2014 only)
3.	Scale/Normalize Data
4.	Perform Exploratory Analysis 
 a.	Scatter Plot Matrix of Scaled Data
 b.	Calculate Descriptive Statistics
 c.	Corrplot() Analysis
 d.	Create Training and Testing Data
5.	Unsupervised Modeling: Perform Clustering and Dimension Reduction
 a.	Perform Kmeans Iteration
 b.	Elbow Plot: Determine Number of Clusters 
 c.	Perform PCA: Verify Cluster Number
 d.	Create Covariance and Correlation Matrices
 e.	Select the Number of Factors
  i.	Plotting Factors and Loadings
  ii.	Extract Insights
6.	Bi plot of Loadings and Component scores
 a.	Supervised Modeling
  i.	Perform Multivariate Linear Regression Modeling
  ii.	Obtain Predictor Correlations
  iii.	Perform Linear Model (training data, top 3 +/- correlated predictors)
  iv.	Unrestricted Model: Perform Linear Model (training data, all predictors)
  v.	Detecting Multicollinearity: Valuation Inflation Factor
  vi.	Predictor Selection Using Akaike Information Criteria (AIC)
  vii.	Run Final Training Model
  viii.	Run Testing Model
  ix.	Visualize Linear Model Results
7.	Classification Modeling
 a.	Load, Clean and Scale Data
 b.	Perform Generalized Linear Model
  i.	Convert Dependent Variable to Type Factor  
  ii.	Run Model / Obtain Log(odds)
  iii.	Define Classification Rule / Make Predictions
  iv.	Create Confusion Matrix and Statistics - Compare Predicted Classes to Actual

## Dataset Description
I was unable to find a quality dataset that included personal factors that might affect an individual’s life span.  Rather, I obtained population level data compiled by the World Health Organization. 

The data follows specific 22 features for 184 countries from 2000-2015.  The following table defines the dataset:


















### Results
All exploratory and inferential statistical analysis and clustering can be found in the attached [notebook](Module3_HomeWork_Final_Changed_After_Class.R) or [notebook with Graphs](Module3_HomeWork_Final_Changed_After_Class.R.html).  


