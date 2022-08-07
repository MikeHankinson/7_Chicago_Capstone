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
Coding was completed in R using RStudio IDE ([Project Code](Project.R)).   The following defines the process used to complete the study:

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

![](Readme%20Pics/data%20description.png)


Data was loaded into the model via a csv file and cleaned of empty data.  For simplicity, data from 2014 was extracted and modeled.  A visualization of a portion of the data is shown below:

 ![](Readme%20Pics/1%20data%20.png)

Prior to modeling, the data was normalized to rid of potential size bias.  Descriptive statistics were developed for 19 features. In addition, a corrplot() function was created to aid in data visualization.  This function is a “visual exploratory tool on correlation matrix that supports automatic variable reordering to help detect hidden patterns among variables”.  Data exploratory analysis results can be found within the programming model.  

## Unsupervised Analysis

Both Kmeans and Principal Component Analysis was performed on the full set of normalized 2014 data.  It was difficult to make a definitive decision of number of clusters based upon the elbow curves.  Arguments could be made to choose anywhere from 2 to 6.  In this study, dimension reduction was chosen from 18 features down to 4.  With this level of reduction, 84.6% of the variance was still accounted.  

![](Readme%20Pics/2%20Elbow%20Plot.png)

Component loading graphs were created to better understand the relationship between the Loading and Variables.  
  
![](Readme%20Pics/3%20Loadings.png)

![](Readme%20Pics/4%20Loadings%202.png)
   
A biplot was created for the relationship between the first 2 components.  Although the map shows 3 distinct areas of life expectancy facors, the countries association with them is indistinguishable.  It was difficult to gleen additional information from this tool.  

 ![](Readme%20Pics/5%20biplot.png)


## Supervised Analysis

Data was split into training and testing sets prior to performing multivariate linear regression.  Reduced factor results from PCA were not input into the LR model.  Rather, multiple methods were used to determine which factors to include.  

A correlation vector was developed to determine the relative correlations to life expectancy for each predictor.  As a baseline model to determine effect on life expectancy, the top 3 positive and negative factors were input into the linear model, using training data.   

For comparison, a second training model was performed using all predictors.  Coefficients, p-values, r2 vales and sum of squares were evaluated and compared.  

Using the Variance Inflation Factor for each predictor, multicollinearity was evaluated. From this analysis, 2 variables (infant.deaths and under.five.deaths) were found to have highly inflated variance and therefore removed from the model.  

Akaike Information Criteria was incorporated for predictor selection.  The lowest AIC iteration resulted in the following model: 

 ![](Readme%20Pics/6.png)
 

The results seemed reasonable.  However, future model would perhaps not include Population due to the large P-value.  The overall model had and adjusted R-squared of 0.86 with a P-value less than 2.2e-16.  

The same model was performed with the holdout testing data and resulted in similar results.  

 ![](Readme%20Pics/7.png)

Results were tabulated and are presented in the following graphs.  Note the linear model is not precise at describing real world behavior as some of the data points are 5 deviations from the model.  Although not perfect, the Density plot comparing the model to actual data aligned fairly well. 

 ![](Readme%20Pics/8%20Regression%20Model%20Results.png)


## Classification Modeling

The data set did not include categorical variables.  Therefore, I created a column detailing (0 or 1) whether or not life expectancy >= 65 for each country.  

Again, the data was loaded, cleaned and scaled.  Since the dependent variable was categorical, rather than numerical, it was converted into a type factor.  A Generalized Linear Model was run, using the same factors as in the linear model.  The model results were used to create the following confusion matrix:  

 ![](Readme%20Pics/9%20Confusion%20Matrix.png)

These results demonstrate that the chosen predictors are exceptional at determining if a country would have a life expectancy greater than 65 years.  

## Improvements and Future Work

1.	Use larger data set to train the model rather than simply using data from a single year (2014).  
2.	Perform different types of models to determine whether or not linear model is the most appropriate vehicle for this analysis.  
3.	Use outputs from PCA analysis as inputs into the linear model.  I did not understand how to clearly interpret the results from such a model – with combined and rotated predictors.  
