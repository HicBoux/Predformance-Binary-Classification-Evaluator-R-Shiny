rethreshold_predictions <- function(data, threshold, cols) {
  # Recompute the final class label (0 or 1) of the column "Predicted" according to a given threshold
  # applied on the column "Probability_1" in the input data.
  #
  # Args:
  #   data: raw data including at least 2 columns named "Predicted" and "Probability_1" and refering 
  #         respectively to the predicted class labels (0 or 1 ) and probability to be 1.
  #   threshold: probability threshold applied on the column "Probability_1" and upon which is considered 
  #         a row as having a class label "Predicted" of 1.
  #   cols: vector c("Actual","Predicted") with the "actual" and "predicted" column names in order to transform them as factors.
  #
  # Returns:
  #   A transformed dataframe where the probability threshold has been applied.
  
  data <- na.omit(data) #Rows with at least one NaN are dropped
  data$Predicted <- ifelse(data$Probability_1 < threshold, 0, 1)
  data[cols] <- lapply(data[cols], factor)
  
  return(data)
}

compute_confusion_matrix_metrics <- function(predicted_label, actual_label) {
  # Compute the confusion matrix and metrics like the number and rate false positives, true positives, false negatives,
  # true negatives but also the false discovery rate, the negative predictive value and the positive negative value.
  #
  # Args:
  #   predicted_label: column of a dataframe with all predicted class labels (0 or 1)
  #   actual_label: column of a dataframe with all actual/true class labels (0 or 1)
  #
  # Returns:
  #   A 2-columns dataframe with row by row the name of value of all the metrics computed.
  
  confusion_matrix <- ConfusionMatrix(predicted_label, actual_label)
  fp <- confusion_matrix[1,2]
  tp <- confusion_matrix[2,2]
  fn <- confusion_matrix[2,1]
  tn <- confusion_matrix[1,1]
  
  tpr <- tp / (tp + fn)
  fpr <- fp / (fp + tn)
  fnr <- fn / (fn + tp)
  tnr <- tn / (tn + fp)
  
  false_discovery_rate <- fp / (fp + tp)
  negative_predictive_value <- tn / (tn + fn)
  positive_predictive_value <- tp / (tp + fp)
  
  metric_names <- c(
    'False Positives FP',
    'True Positives TP',
    'False Negatives FN',
    'True Negatives TN',
    'True Positive Rate',
    'Type-I Error | False Positive Rate',
    'Type-II Error | False Negative Rate',
    'True Negative Rate',
    'False Discovery Rate',
    'Negative Predictive Value',
    'Positive Predictive Value')
  
  metric_scores <- c(
    fp,
    tp,
    fn,
    tn,
    tpr,
    fpr,
    fnr,
    tnr,
    false_discovery_rate,
    negative_predictive_value,
    positive_predictive_value)
  
  cfm_metrics_summary <- data.frame(metric_names, metric_scores)
  names(cfm_metrics_summary)[1] <- "Metric Name"
  names(cfm_metrics_summary)[2] <- "Value"
  
  return(cfm_metrics_summary)
  
}

compute_class_metrics <- function(predicted_label, actual_label, probability_1) {
  # Compute various binary classification metrics like the accuracy, precision, recall, sensitivity, specificity,
  # average precision, f1 score, f2 score, f0.5 score, Cohen's Kappa and Matthew's correlation coefficients,
  # the roc auc, brier and log loss scores, and the kolgomorov-smirnov statistics.
  #
  # Args:
  #   predicted_label: column of a dataframe with all predicted class labels (0 or 1) as factors
  #   actual_label: column of a dataframe with all actual/true class labels (0 or 1) as factors
  #   probability_1 : column of a dataframe with the probability (between 0 and 1) for each row to be classified as 1 
  #
  # Returns:
  #   A 2-columns dataframe with row by row the name of value of all the metrics computed.
  
  accuracy <- Accuracy(y_true = actual_label, y_pred = predicted_label)
  precision <- Precision(y_true = actual_label, y_pred = predicted_label, positive = 1)
  recall <- Recall(y_true = actual_label, y_pred = predicted_label,  positive = 1)
  sensitivity <- Sensitivity(y_true = actual_label, y_pred = predicted_label,  positive = 1)
  specificity <- Specificity(y_true = actual_label, y_pred = predicted_label,  positive = 1)
  
  f1 <- FBeta_Score(y_true = actual_label, y_pred = predicted_label, positive = 1, beta = 1)
  f2 <- FBeta_Score(y_true = actual_label, y_pred = predicted_label, positive = 1, beta = 2)
  f05 <- FBeta_Score(y_true = actual_label, y_pred = predicted_label, positive = 1, beta = 0.5)
  
  stats_matrix <- confusionMatrix(data = predicted_label, reference = actual_label)
  cohen_kappa <- stats_matrix$overall[2]
  
  mcc <- mccr(act = actual_label, pred = predicted_label) #(tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn))
  
  roc_auc_score <- AUC(y_true = actual_label, y_pred = predicted_label)
  
  average_precision <- PRAUC(y_true = actual_label, y_pred = probability_1)
  pr_auc_score <- PRAUC(y_true = actual_label, y_pred = probability_1)
  
  log_loss <- LogLoss(probability_1,as.numeric(as.matrix(actual_label)))
  
  brier_score_loss <- mean((as.numeric(as.matrix(actual_label))-probability_1)^2)
  
  kolmogorov_smirnov_stat <- KS_Stat(y_pred = probability_1,y_true = as.numeric(as.matrix(actual_label)))/100
  
  metric_names <- c(
    'Accuracy',
    'Precision',
    'Recall',
    'Sensivity',
    'Specificity',
    'F1 Score',
    'F2 Score',
    'F0.5 Score',
    'Cohen Kappa',
    'Matthews Correlation Coefficient',
    'ROC AUC Score',
    'Precision-Recall AUC Score',
    'Average Precision',
    'Log Loss',
    'Brier Score',
    'Kolgomorov-Smirnov Statistics'
  )
  metric_scores <- c(
    accuracy,
    precision,
    recall,
    sensitivity,
    specificity,
    f1,
    f2,
    f05,
    cohen_kappa,
    mcc,
    roc_auc_score,
    pr_auc_score,
    average_precision,
    log_loss,
    brier_score_loss,
    kolmogorov_smirnov_stat
  )
  
  class_metrics_summary <- data.frame(metric_names, metric_scores)
  names(class_metrics_summary)[1] <- "Metric Name"
  names(class_metrics_summary)[2] <- "Value"
  
  return(class_metrics_summary)
}

plot_roc_curve <- function(actual_label, probability_1){
  # Plot the ROC curve.
  #
  # Args:
  #   actual_label: column of a dataframe with all actual/true class labels (0 or 1) as factors
  #   probability_1 : column of a dataframe with the probability (between 0 and 1) for each row to be classified as 1 
  #
  # Returns:
  #   A plot of the ROC Curve from the input data.
  roc_curve <- roc.curve(scores.class0 = probability_1, weights.class0=as.numeric(as.matrix(actual_label)), curve=TRUE)
  return(plot(roc_curve, auc.main=FALSE))
}

plot_prc_curve <- function(actual_label, probability_1){
  # Plot the Precision-Recall curve.
  #
  # Args:
  #   actual_label: column of a dataframe with all actual/true class labels (0 or 1) as factors
  #   probability_1 : column of a dataframe with the probability (between 0 and 1) for each row to be classified as 1 
  #
  # Returns:
  #   A plot of the Precision-Recall Curve from the input data.
  prc_curve <- pr.curve(scores.class0 = probability_1, weights.class0=as.numeric(as.matrix(actual_label)), curve=TRUE)
  return(plot(prc_curve, auc.main=FALSE))
}

