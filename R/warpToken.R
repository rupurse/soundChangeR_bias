warpToken <- function(producedToken, perceiver, producer, percScore, params) {

  invPercScore <- 1 - (percScore)
  spellout <- 5*gsignal::idct(as.numeric(producedToken$exemplar[[1]]), n = 50)
  vowel <- spellout[1:25]
  cons <- spellout[26:50]*invPercScore
  warp <- c(vowel, cons)
  smoothwarp <- emuR::dct(warp, 5)

  smoothwarp_spellout <- 5*gsignal::idct(as.numeric(smoothwarp), n=50)
  smoothvowel <- smoothwarp_spellout[1:25]
  
  diff <- vowel - smoothvowel
  vowel2 <- vowel

  j <- 1
  warp_boosted <- c(abs(vowel*j), cons)
  k <- sum(smoothvowel[10:25] < vowel [10:25])

  while (k > 5) {
    j <- j + 0.1
    for (i in 10:25) {
      if (!is.null(smoothvowel[i]) &
          !is.null(vowel[i]) &
          smoothvowel[i] < vowel [i]
          ) {
        vowel2[i] <- vowel[i] + (diff[i]*j)
      }
    }
    warp_boosted <- c(vowel2, cons)

    smoothwarp_iterate <- emuR::dct(warp_boosted, 5)
    smoothwarp_iterate_spellout <- 5*gsignal::idct(as.numeric(smoothwarp_iterate), n=50)

    k <- sum(smoothwarp_iterate_spellout[10:25] < vowel[10:25])
  }

  warpedToken <- data.table::data.table(word = producedToken$word,
                                        phoneme = producedToken$phomene,
                                        exemplar = features2exemplar(emuR::dct(warp_boosted, 5), producer, params),
                                        nrOfTimesHeard = producedToken$nrOfTimesHeard,
                                        producerID = producedToken$producerID)
  
  return(warpedToken)
  
}
