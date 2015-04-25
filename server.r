library(shiny)

shinyServer(function(input, output) {
 
  # Function that generates scenarios and computes NAV.
  getdata <- reactive ({
    
    top <- input$top
    etf1 <- input$x1
    etf2 <- input$x2
    mydate <- input$x3
    
    if (etf1 == "USMV") {myhead1 <- "http://www.ishares.com/us/products/239695/ishares-msci-usa-minimum-volatility-etf/1395165510754.ajax?fileType=csv&fileName=USMV_holdings&dataType=fund&asOfDate="}
    if (etf1 == "USMV") {c1 <- "cornflowerblue"}
    if (etf1 == "VLUE") {myhead1 <- "http://www.ishares.com/us/products/251616/ishares-msci-usa-value-factor-etf/1395165510754.ajax?fileType=csv&fileName=VLUE_holdings&dataType=fund&asOfDate="}
    if (etf1 == "VLUE") {c1 <- "blueviolet"}
    if (etf1 == "QUAL") {myhead1 <- "http://www.ishares.com/us/products/256101/ishares-msci-usa-quality-factor-etf/1395165510754.ajax?fileType=csv&fileName=QUAL_holdings&dataType=fund&asOfDate="}
    if (etf1 == "QUAL") {c1 <- "chartreuse3"}
    if (etf1 == "MTUM") {myhead1 <- "http://www.ishares.com/us/products/251614/ishares-msci-usa-momentum-factor-etf/1395165510754.ajax?fileType=csv&fileName=MTUM_holdings&dataType=fund&asOfDate="}
    if (etf1 == "MTUM") {c1 <- "deepskyblue"}
    if (etf1 == "SIZE") {myhead1 <- "http://www.ishares.com/us/products/251465/ishares-msci-usa-size-factor-etf/1395165510754.ajax?fileType=csv&fileName=SIZE_holdings&dataType=fund&asOfDate="}
    if (etf1 == "SIZE") {c1 <- "forestgreen"}
    
    if (etf2 == "USMV") {myhead2 <- "http://www.ishares.com/us/products/239695/ishares-msci-usa-minimum-volatility-etf/1395165510754.ajax?fileType=csv&fileName=USMV_holdings&dataType=fund&asOfDate="}
    if (etf2 == "USMV") {c2 <- "cornflowerblue"}
    if (etf2 == "VLUE") {myhead2 <- "http://www.ishares.com/us/products/251616/ishares-msci-usa-value-factor-etf/1395165510754.ajax?fileType=csv&fileName=VLUE_holdings&dataType=fund&asOfDate="}
    if (etf2 == "VLUE") {c2 <- "blueviolet"}
    if (etf2 == "QUAL") {myhead2 <- "http://www.ishares.com/us/products/256101/ishares-msci-usa-quality-factor-etf/1395165510754.ajax?fileType=csv&fileName=QUAL_holdings&dataType=fund&asOfDate="}
    if (etf2 == "QUAL") {c2 <- "chartreuse3"}
    if (etf2 == "MTUM") {myhead2 <- "http://www.ishares.com/us/products/251614/ishares-msci-usa-momentum-factor-etf/1395165510754.ajax?fileType=csv&fileName=MTUM_holdings&dataType=fund&asOfDate="}
    if (etf2 == "MTUM") {c2 <- "deepskyblue"}
    if (etf2 == "SIZE") {myhead2 <- "http://www.ishares.com/us/products/251465/ishares-msci-usa-size-factor-etf/1395165510754.ajax?fileType=csv&fileName=SIZE_holdings&dataType=fund&asOfDate="}
    if (etf2 == "SIZE") {c2 <- "forestgreen"}
    
    # ETF1
    x1 <- read.csv(paste(myhead1, mydate, sep = "", collapse = NULL), skip=10)
    ETF1 <- x1[1:top,c(1,4,5,6,7)]
    ETF1[,3] <- ETF1[,3]/100
    colnames(ETF1) <- c("Ticker", "Name", "Weight", "AssetClass", "Sector")
    ETF1 <- transform(ETF1, CumSum =cumsum(Weight))
    rm(x1, myhead1)
    
    # ETF2
    x2 <- read.csv(paste(myhead2, mydate, sep = "", collapse = NULL), skip=10)
    ETF2 <- x2[1:top,c(1,4,5,6,7)]
    ETF2[,3] <- ETF2[,3]/100
    colnames(ETF2) <- c("Ticker", "Name", "Weight", "AssetClass", "Sector")
    ETF2 <- transform(ETF2, CumSum =cumsum(Weight))
    rm(x2, myhead2)
   
    pp <- new.env()
    pp$datachart <- data.frame(ETF1$CumSum, ETF2$CumSum)
    pp$datatable <- ETF1[ETF1$Ticker %in% intersect(ETF1$Ticker,ETF2$Ticker),c(-3,-6)]
    pp$tickers <- data.frame(cbind(data.frame(ETF1$Ticker),data.frame(ETF2$Ticker)))
    pp$etfs <- c(etf1,etf2)
    pp$colors <- c(c1,c2)
    
    return(pp)
     
  })
  
    # Data for plot (CumSum Weight)
  output$distPlot <- renderPlot({
    pp = getdata()
    
    matplot(pp$datachart, 
            xlab = "# Top Holdings", 
            ylab = "Cum Weight",
            ylim = c(-0.05, 0.8),
            main = "Comparative Top Holdings Cumulative Weight", 
            pch = 1,
            type = "o",
            col = pp$colors,
            bg = pp$colors 
    )
    legend("topleft", inset=.05, legend=pp$etfs, col=pp$colors, fill=pp$colors, horiz=TRUE)
    grid()  
    text(seq(1,dim(pp$datachart)[1]), pp$datachart[,1], pp$tickers[,1], col = pp$colors[1], adj = c(0,0), cex = 0.8, pos = 1)
    text(seq(1,dim(pp$datachart)[1]), pp$datachart[,2], pp$tickers[,2], col = pp$colors[2], adj = c(0,0), cex = 0.8, pos = 3)
 
  })
  # Data for table (Stocks in both ETFs)
    output$distTable <- renderTable({
    pp = getdata()
    pp$datatable
  })
 
})