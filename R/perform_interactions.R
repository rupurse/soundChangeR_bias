perform_interactions <- function(pop, logDir, params) {

  groupsInfo <- data.table::rbindlist(base::lapply(pop, function(agent) {
    data.table::data.table(agentID = agent$agentID, group = agent$group)
    }))[base::order(agentID),]

  pb <- utils::txtProgressBar(min = 0, max = params[["nrOfSnapshots"]], initial = 0, style = 3)

  ##RP 2025
  counter <- as.integer(0)
  env <- new.env()
  if params["dynamicBias"]]) {
    env$perc_log <- data.table::data.table(
      counter = integer(),
      perceiverID = integer(),
      biasScore = numeric(),
      accepted = logical(),
      dct0 = numeric(),
      dct1 = numeric(),
      dct2 = numeric(),
      dct3 = numeric(),
      dct4 = numeric(),
      dct5 = numeric()
    )
  }
  ##
  
  for (snap in 1:params[["nrOfSnapshots"]]) {
    utils::setTxtProgressBar(pb, snap)
    interactionsLog <- create_interactions_log(params)
    for (i in 1:params[["interactionsPerSnapshot"]]) {
      counter <- counter + 1
      perform_single_interaction(pop, interactionsLog, env, snap, groupsInfo, params, counter)
    }
    save_population(pop, extraCols = base::list(snapshot = snap), logDir = logDir)
    save_interactions_log(interactionsLog, extraCols = base::list(snapshot = snap), logDir = logDir)
  }
  close(pb)
}
