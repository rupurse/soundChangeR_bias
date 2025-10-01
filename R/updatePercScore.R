updatePercScore <- function(producedToken, perceiver, log, bias, params) {

  oDCT <- c(mean(as.numric(log$dct0)),
            mean(as.numric(log$dct1))
            mean(as.numric(log$dct2)),
            mean(as.numric(log$dct3)),
            mean(as.numric(log$dct4)),
            mean(as.numric(log$dct5)))
  oSpellout <- 5*gsignal::idct(oDCT, n = 50)
  oCentreOfMass <- sum(1:50 * oSpellout) / sum(oSpellout)

  basisIdx <- base::which(perceiver$memory$phoneme == producedToken$phoneme &
                          perceiver$memory$valid == TRUE)
  basisTokens <- base::as.matrix(perceiver$veatures)[basisIdx, , drop = FALSE]
  gaussParams <- estimate_gaussian(basisTokens)
  sSpellout <- 5*gsignal::idct(gaussParams$mean, n = 50)
  sCentreOfMass <- sum(1:50 * sSpellout) / sum(sSpellout)

  deltaCOM <- sCentreOfMass - oCentreOfMass
  deltaNorm <- deltaCOM / 49

  current_bias <- bias
  change_rate <- params[["biasChangeRate"]]

  if (deltaNorm < 0) {
    scaling_factor <- if (current_bias > 0.5) {
      1
    } else {
      current_bias / 0.5
    }
  } else if (deltaNorm > 0) {
    scaling_factor <- if (current_bias < 0.5) {
      1
    } else {
      1 - ((current_bias - 0.5) / 0.5)
    }
  } else {
    scaling_factor <- 0
  }

  change <- deltaNorm * change_rate * scaling_factor
  newPercScore <- min(1, max(0, current_bias + change))

  return(newPercScore)
}
