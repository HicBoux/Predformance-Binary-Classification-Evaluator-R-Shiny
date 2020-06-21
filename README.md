# Predformance : Simple R-Shiny App to evaluate fast Binary Classifications

The aim of this app is to get fast the performance metrics of a binary classifier model. Some typical use cases are showed at the end of this Readme file. 

In order to use this app and get the results, you need to input your comma-separated CSV file of predictions thanks the button "Browse..."
and it will generate automatically the scores and graphs. It can take a few minutes for huge CSV files with more than 50k rows.
It is important to have those column names in your CSV files : Actual, Predicted, Probability_1, Probability_0. Otherwise an error
will be returned. Some examples of correct CSV are also available in this repository.

You can whether download the repository and launch this app in R-Studio or directly 
use the hosted online version at : https://hicboux.shinyapps.io/predformance-binaryclass/ 


<h3>Computed Metrics :</h3>
<ul>
  <li>False Positives FP</li>
  <li>True Positives TP</li>
  <li>False Negatives FN</li>
  <li>True Negatives TN</li>
  <li>True Positive Rate</li>
  <li>Type-I Error | False Positive Rate</li>
  <li>Type-II Error | False Negative Rate</li>
  <li>True Negative Rate</li>
  <li>False Discovery Rate</li>
  <li>Negative Predictive Value</li>
  <li>Positive Predictive Value</li>
  <li>Accuracy</li>
  <li>Precision</li>
  <li>Recall</li>
  <li>Sensivity</li>
  <li>Specificity</li>
  <li>F1 Score</li>
  <li>F2 Score</li>
  <li>F0.5 Score</li>
  <li>Cohen's Kappa Coeffficient</li>
  <li>Matthews Correlation Coefficient</li>
  <li>ROC AUC Score</li>
  <li>Precision-Recall AUC Score</li>
  <li>Average Precision</li>
  <li>Log Loss</li>
  <li>Brier Score</li>
  <li>Kolgomorov-Smirnov Statistics</li>
  <li>Brier Score</li>
</ul>
<h3>Computed Graphs/Curves :</h3>
<ul>
  <li>ROC Curve</li>
  <li>PR Curve</li>
  <li>Lift Curve</li>
  <li>Gain Curve</li>
</ul>

<h2>Use Case</h2>
-Although operational and ready-to-use, this app is nonetheless not able to deal with huge CSV files.</br>
-Ideal usages of this app :
<ul>
  <li>Get fast results from your Machine Learning model.</li>
  <li>Check your performance to predict soccer game results.</li>
  <li>Check your performance to classify your documents in the proper themes.</li>
  <li>Whatever else so long you have a binary situation where things can be done right or wrong.</li>
</ul>
 , 


<h2>Credits</h2>
Copyright (c) 2020, HicBoux. Work released under MIT License.

(Please contact me if you wish to use my work in specific conditions not allowed automatically by the MIT License.)
