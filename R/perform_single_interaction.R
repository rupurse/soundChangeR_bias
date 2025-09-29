perform_single_interaction <- function(pop, interactionsLog, env, nrSim, groupsInfo, params, counter) {

  interactionPartners <- choose_interaction_partners(groupsInfo, params)
  
  producer <- pop[[interactionPartners[["prodNr"]]]]
  perceiver <- pop[[interactionPartners[["percNr"]]]]

  pt <- produce_token(producer, params)
  perceive_token(perceiver, pt, interactionsLog, env, nrSim, params, counter)
}
