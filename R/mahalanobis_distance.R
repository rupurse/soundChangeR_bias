mahalanobis_distance <- function(exemplar, features, phoneme, agent, params, bias=NULL) {
  
  mahalDist <- compute_mahal_distance(agent, features, phoneme, params, bias)
  mahalDist <= stats::qchisq(p = params[["mahalanobisProbThreshold"]], df = get_cache_value(agent, "nFeatures"))
}
