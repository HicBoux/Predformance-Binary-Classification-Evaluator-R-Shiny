#Required libraries
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")

# Define UI for data upload app ----
ui <- fluidPage(
    
    titlePanel("PredFormance : Binary Classification Overview"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Select a file ----
            fileInput("file1", "Choose CSV File",
                      multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),
            
            # Horizontal line ----
            tags$hr(),
            
            # Input: Checkbox if file has header ----
            checkboxInput("header", "Header", TRUE),
            
            # Input: Select separator ----
            radioButtons("sep", "Separator",
                         choices = c(Comma = ",",
                                     Semicolon = ";",
                                     Tab = "\t"),
                         selected = ","),
            
            # Input: Select quotes ----
            radioButtons("quote", "Quote",
                         choices = c(None = "",
                                     "Double Quote" = '"',
                                     "Single Quote" = "'"),
                         selected = '"'),
            
            # Horizontal line ----
            tags$hr(),
            
            # Input: Select number of rows to display ----
            radioButtons("disp", "Display",
                         choices = c(Head = "head",
                                     All = "all"),
                         selected = "head"),
            
            # Choose the probability threshold
            numericInput("proba_threshold", 
                         "Probability Threshold \n (Float between 0 and 1 included)",
                         min = 0, max = 1, step = 0.001,
                         value = 0.5)
            
        ),
        
        #Overview of the input CSV files ----
        mainPanel(
            p("Example of possible input table : "),
            tableOutput("tutorial"),
            tags$b("NB : Please input a CSV file with the following column names/header : 'Actual' for true values, 'Predicted' for predicted values, 'Probability_1' and 
              'Probability_0' for the probability of the row/element to be classified as 1 and 0 respectively. Otherwise the software doesn't work and will give errors."),
            p("NB2: Rows with at least one NaN/missing value are dropped before the computation of the metrics and plots."),
            p("NB3: It can take a few minutes to load and compute stats for huge files with several Mbs."),
            h2("Overview of the Input file : "),
            tableOutput("input_file"),
            textOutput("selected_proba_threshold"),
            p("Below an overview of your input CSV once the threshold applied."),
            tableOutput("input_file_threshold"),
        )
        
    ),
    
    #All Computed metrics and graphics ----
    conditionalPanel(
        condition = "output.is_file_uploaded",
        fluidRow(
            column(8, align="center",
                   htmlOutput("summary_metrics_title"),
                   tableOutput("summary_metrics"),
                   htmlOutput("plots_title"),
                   plotOutput("roc_curve"), 
                   plotOutput("prc_curve"),
                   fluidRow(align="center", tags$b("Lift Curve")),
                   plotOutput("lift_curve"),
                   fluidRow(align="center", tags$b("Gain Curve")),
                   plotOutput("gain_curve") 
            )
        )

    )
)