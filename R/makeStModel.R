#' Creating a propensity function
#' 
#' This function creates a propensity function of the model (required for the stochastic simulation)
#' This function is called from the "makeModel.R" function.
#' 
#' @param x  model name (required)
#' @param tmpDF a data frame that contains information about reactions, species, stoichometric coefficients, etc. 
#'     (temp data frame used within the "makeModel.R" function) (required)
#'     
#' @return This function returns a vector that contains propensity function corresponding to a defined model.
#' 

#makeStModel.function <- function(x, tmpDF){
makeStModel <- function(x, tmpDF){
  
  # Create a data frame describing reaction rates
  DF.rates <- data.frame(rName=x$rate$rrName, rVal=x$rates$rVal, rType=x$rates$rType)
  
  tmpDF.hlp <- merge(tmpDF, DF.rates, by.x="reaction", by.y="rName")
  
  tmpDF.hlp2 <- plyr::ddply(tmpDF.hlp, .variable="reactionNumber", function(x) data.frame(stVal=ifelse(toupper(x$rType) == "FIXED", ifelse(x$rVal != 1, paste(as.character(x$rVal), x$product, sep="*"), as.character(x$product)), paste(as.character(x$rVal), x$product, sep="*"))))
  
  tmpDF.hlp <- unique(tmpDF.hlp2[, c("reactionNumber", "stVal")])
  
  
  ###################################################################
  # No need for this here, because we don't care about side (that's why we use the numerical matrix of change
  # if the number of individuals in each state (rows) caused by a single reaction of any given type (columns))
  # Summarize per species quantity (per reaction and product)
  #tmpDF.hlp2 <- ddply(tmpDF.hlp, .variable=c("reactionNumber", "rVal"), function(x) data.frame(tot=sum(as.numeric(x$stoch)*as.numeric(x$side))))     
  
  # Remove those with total equal to zero (that canceled out)
  #tmpDF.hlp <- tmpDF.hlp2[as.numeric(tmpDF.hlp2$tot) != 0, ]
  
  # Sort reactions by reaction number
  #tmpDF.hlp2 <- tmpDF.hlp[match(sort(tmpDF.hlp$reactionNumber), tmpDF.hlp$reactionNumber),]
  
  # Create and return an array with reactions
  # tmpDF.hlp <- plyr::ddply(tmpDF.hlp2, .variable="reactionNumber", function(x) data.frame(t1=ifelse(x$tot == 1, paste(as.character(x$rVal), x$product, sep="*"), ifelse(x$tot == -1, paste("-", paste(as.character(x$rVal),x$product, sep="*"), sep=""), paste(as.character(x$tot), as.character(x$rVal), x$product, sep="*")))))
  
  #as.character(tmpDF.hlp$t1)
  ###################################################################

  # Sort reactions by reaction number
  tmpDF.hlp2 <- tmpDF.hlp[match(sort(tmpDF.hlp$reactionNumber), tmpDF.hlp$reactionNumber),]
  
  as.character(tmpDF.hlp$stVal)  
  
 
}

#makeStModel <- cmpfun(makeStModel.function)
#rm(makeStModel.function)
