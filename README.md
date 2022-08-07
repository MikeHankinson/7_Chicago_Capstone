# 7_Chicago_Capstone

## Skills and Tools
* Data Exploratory Analysis
* Unsupervised Modeling: Clustering and Dimension Reduction
* Supervised Modeling: Multivariate Linear Regression, Obtain Predictor Correlations, Linear Model, Detect Multicollinearity, Predictor Selection, Training and Testing Models

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
    - Scatter Plot Matrix of Scaled Data
    - Calculate Descriptive Statistics
    - Corrplot() Analysis
    - Create Training and Testing Data
5.	Unsupervised Modeling: Perform Clustering and Dimension Reduction
    - Perform Kmeans Iteration
    - Elbow Plot: Determine Number of Clusters 
    - Perform PCA: Verify Cluster Number
    - Create Covariance and Correlation Matrices
    - Select the Number of Factors
        * Plotting Factors and Loadings
        * Extract Insights
6.	Bi plot of Loadings and Component scores
    - Supervised Modeling
        *	Perform Multivariate Linear Regression Modeling
        *	Obtain Predictor Correlations
        *	Perform Linear Model (training data, top 3 +/- correlated predictors)
        *	Unrestricted Model: Perform Linear Model (training data, all predictors)
        *	Detecting Multicollinearity: Valuation Inflation Factor
        *	Predictor Selection Using Akaike Information Criteria (AIC)
        *	Run Final Training Model
         *	Run Testing Model
        *	Visualize Linear Model Results
7.	Classification Modeling
    - Load, Clean and Scale Data
    - Perform Generalized Linear Model
        *	Convert Dependent Variable to Type Factor  
        *	Run Model / Obtain Log(odds)
        *	Define Classification Rule / Make Predictions
        *	Create Confusion Matrix and Statistics - Compare Predicted Classes to Actual

## Dataset Description
I was unable to find a quality dataset that included personal factors that might affect an individual’s life span.  Rather, I obtained population level data compiled by the World Health Organization. 

The data follows specific 22 features for 184 countries from 2000-2015.  The following table defines the dataset:


1. why won't 
    - this indent
    - properly
2. ?














### Results
All exploratory and inferential statistical analysis and clustering can be found in the attached [notebook](Module3_HomeWork_Final_Changed_After_Class.R) or [notebook with Graphs](Module3_HomeWork_Final_Changed_After_Class.R.html).  


