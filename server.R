#Required libraries
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(MLmetrics)) install.packages("MLmetrics", repos = "http://cran.us.r-project.org")
if(!require(mccr)) install.packages("mccr", repos = "http://cran.us.r-project.org")
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")
if(!require(PRROC)) install.packages("PRROC", repos = "http://cran.us.r-project.org")
if(!require(tidymodels)) install.packages("tidymodels", repos = "http://cran.us.r-project.org")
if(!require(stats)) install.packages("stats", repos = "http://cran.us.r-project.org")
if(!require(e1071)) install.packages("e1071", repos = "http://cran.us.r-project.org")

#Functions to compute metrics, stats and plots
source("helpers.R")

shinyServer( function(input, output) { 
    
    #Update of the actual used threshold ----
    output$selected_proba_threshold <- renderText({ paste("Chosen Probability Threshold th = ", input$proba_threshold) })
    
    output$tutorial <- renderTable({
        tutorial <- data.frame(c(1,1,0,0), c(1,0,0,0), c(0.911, 0.492, 0.125, 0.091), c(0.089, 0.508, 0.875, 0.909))
        names(tutorial) <- c("Actual","Predicted","Probability_1","Probability_0")
        return(tutorial)
    })
    
    #Input of the CSV file with all predictions     
    input_file <- reactive({
        
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, head of that data file by default,
        # or all rows if selected, will be shown.
        
        req(input$file1)
        
        # when reading semicolon separated files,
        # having a comma separator causes `read.csv` to error
        tryCatch(
            {
                input_file <- read.csv(input$file1$datapath,
                               header = input$header,
                               sep = input$sep,
                               quote = input$quote)
            },
            error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
            }
        )
        
    })
    
    
    output$input_file <- renderTable({
        if(input$disp == "head") {
            return(head(input_file()))
        }
        else {
            return(input_file())
        }
    })
    
    #Update of the uploaded/input CSV file according to the probability threshold ----
    input_file_threshold <- reactive({
        return(rethreshold_predictions(input_file(), input$proba_threshold, c("Actual","Predicted")))
    })
    
   output$input_file_threshold <- renderTable({
       if(input$disp == "head") {
           return(head(input_file_threshold()))
       }
       else {
           return(input_file_threshold())
       }
   })
   
   
   #Display results titles if the input file has been uploaded and filtered according to the given threshold
   output$is_file_uploaded  <-  reactive({
       return(!is.null(input_file_threshold()))
   })
   outputOptions(output, 'is_file_uploaded', suspendWhenHidden=FALSE)

        #Conditional titles to display
   output$summary_metrics_title <- renderText(paste("<h2>Summary of the Performance Metrics :</h2>"))
   
   output$plots_title <- renderText(paste("<h2>Performance Curves and Graphics :</h2>"))
   
   output$lift_curve_title <- renderText(paste("<h2>Summary of the Performance Metrics :</h2>"))
   
   output$lift_curve_title <- renderText(paste("<h2>Summary of the Performance Metrics :</h2>"))
   
   
   #Compute of the main metrics of the confusion matrix (TP,FP,TN,FN, TPR,FPR,TNR,FNR, NPV,PPV, False Discovery Rate) ----
   cfm_metrics_summary <- reactive(compute_confusion_matrix_metrics(input_file_threshold()$Predicted, input_file_threshold()$Actual))

   #Compute of the other metrics (Accuracy, Precision, F1 Score etc...) ----
   other_class_metrics_summary <- reactive(compute_class_metrics(input_file_threshold()$Predicted, input_file_threshold()$Actual, input_file_threshold()$Probability_1))
   
   #Gather both DataFrames as one summary DataFrame ----
   output$summary_metrics <- renderTable( rbind(cfm_metrics_summary(),other_class_metrics_summary()), digits = 4 )
   
   
   #Draw of plots (ROC Curve, Precision-Recall Curve, Lift Curve, Gain Curve) ----
   output$roc_curve <- renderPlot({
       plot_roc_curve(input_file_threshold()$Actual, input_file_threshold()$Probability_1)
   })
   
   output$prc_curve <- renderPlot({
       plot_prc_curve(input_file_threshold()$Actual, input_file_threshold()$Probability_1)
   })
   
   output$lift_curve <- renderPlot({
       autoplot(lift_curve(input_file_threshold(), Actual, Probability_1))
   })
   
   output$gain_curve <- renderPlot({
       autoplot(gain_curve(input_file_threshold(), Actual, Probability_1), main = "Gain Curve")
   })
   

})