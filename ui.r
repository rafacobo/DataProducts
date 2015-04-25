# Define UI 
shinyUI(pageWithSidebar(
 
  # Application title
  headerPanel("A look into iShares Factor ETFs"),
 
  # Getting inputs
  sidebarPanel(
    		
	  selectInput('x1', 'Factor ETF 1 :', c("SIZE","VLUE","QUAL","MTUM","USMV")),
    
    selectInput('x2', 'Factor ETF 2 :', c("USMV","VLUE","QUAL","MTUM","SIZE")),
    
	  selectInput('x3', 'Date :', c("2014/12/31", "2014/09/30", "2014/06/30", "2014/03/31", "2013/12/31")),
 
    sliderInput("top", 
                "Top Holdings Limit :", 
                min = 5, 
                max = 30, 
                value = 15,
                step = 1),
    
    p("Once you have chosen two ETFs, a date and a threeshold this app go to the iShares website and download separately all the holdings for both ETF, subset the top holdings selected, plot the cumulative weight and show what stocks are common."),
    
    h5("QUAL = iShares MSCI USA Quality Factor ETF"),
    
	  h5("MTUM = iShares MSCI USA Momentum Factor ETF"),
    
	  h5("VLUE = iShares MSCI USA Value Factor ETF"),
    
	  h5("SIZE = iShares MSCI USA Size Factor ETF"),
    
	  h5("USMV = iShares MSCI USA Minimum Volatility ETF"),
    
	  a( h4("What is iShares?"), href="http://www.ishares.com/us/index"),
    
	  a( h4("What is an ETF?"), href="http://www.ishares.com/us/education/what-is-an-etf"),
    
	  a( h4("What is Factor Investing?"), href="http://www.ishares.com/us/strategies/smart-beta")
  ),
 
  # Show a plot & table
  mainPanel(
    h3('Top Holdings and Cumulative Weight on both Factor ETFs'),
    plotOutput("distPlot", height = "400px"),
    h3('Common stocks on both Factor ETFs'),
    htmlOutput("distTable")
    )
))


# http://www.ishares.com/us/strategies/smart-beta
# http://shiny.rstudio.com/tutorial/lesson2/