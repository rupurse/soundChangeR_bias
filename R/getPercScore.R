getPercScore <- function(env, producedToken, perceiver, perceiverPhoneme, params, counter) {

  perceiverLog <- subset(env%=$perc_log, perceiverID == perceiver$agentID)
  biasWindow <- tail(perceiverLog, 10)
  rejLog <- subset(biasWindow, accepted == FALSE)
  rejUpdates <- 1

  if (nrow(perceiverLog) == 0) {
    return(perceiver$percScore[1])
    
  } else if (params[["dynamicBias"]] &
             perceiverPhoneme %in% params[["biasedPhones"]] &
             nrow(perceiverLog) %% 10 == 0) {
    currentBias <- as.numeric(tail(biasWindow$biasScore, 1))
    newPercScore <- updatePercScore(producedToken, perceiver, biasWindow, currentBias, params)
    return(newPercScore)
    
  } else {
    return(as.numeric(tail(perceiverLog$biasScore, 1)))
  }
}
