write_interactions_log2 <- function(interactionsLog, producedToken, perceiver, perceiverPhoneme_, memorise, strategy, features, nrSim, percScore, counter) {

  rowToWrite <- base::which(interactionsLog$valid == FALSE)[1]
  stopifnot(is.integer(rowToWrite), length(rowToWrite)==1, !is.na(rowToWrite))
  cnt<-as.integer(counter)
  interactionsLog[rowToWrite, `:=`(
    word = producedToken$word,
    producerID = producedToken$producerID,
    producerPhoneme = producedToken$phoneme,
    producerNrOfTimesHeard = producedToken$nrOfTimesHeard,
    perceiverID = perceiver$agentID,
    perceiverPhoneme = perceiverPhoneme_,
    perceiverNrOfTimesHeard = {
      if (memorise) {
        perceiver$memory$nrOfTimesHeard[perceiver$memory$word == producedToken$word & perceiver$memory$valid == TRUE][1]
      } else {
        base::as.integer(base::max(1, perceiver$memory$nrOfTimesHeard[perceiver$memory$word == producedToken$word & perceiver$memory$valid == TRUE][1]))
      }
    },
    accepted = memorise,
    rejectionCriterion = base::ifelse(memorise, NA_character_, strategy),
    biasScore = percScore,
    counter = as.integer(cnt),
    valid = TRUE
  )] %>% 
    .[rowToWrite, base::paste0("P", 1:base::ncol(features)) := base::as.list(features)]
}
