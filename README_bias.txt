#This document explains the parameter settings for "Modeling the role of perceptual bias in the development and propagation of distinctive vowel nasalization".
#Our developments require the use of the emuR and gsignal packages in addition to what is required for the original soundChangeR suite.

install.packages("emuR")
install.packages("gsignal")

#For the models in section 3, we simulated change over time in normalized nasal consonant duration (NDur) and vowel nasalization duration (VNas) measures from the VNasNDur_data.csv seed data.
#No perceptual bias mechanism was incorporated into the model in section 3.1. The parameters are as follows:
set.seed(321)
run_simulation(inputDataFile = "/User/VNasNDur_data.csv", speaker= "speaker", word = "word", phoneme = "phonemic",
               features = c("ndur.norm", "nasdur.norm"), memoryIntakeStrategy = "mahalanobisDistance", mahalanobisProbThreshold = .99, forgettingrate = .7,
               runs = 5, nrOfSnapshots = 60, interactionsPerSnapshot = 1000)

#For the model in section 3.2, a bias mechanism was incorporated with the usePercScores parameter. This mechanism, activated with the useEvalBias parameter, triggers at the point of evaluation to perturb the representations of stored tokens against which perceived tokens are evaluated.
#This perturbation was proportional to an agent's bias score multiplied by a scaling factor (evalBiasScale), set to 0.2 to correspond to 1 standard deviation in the seed data distribution of VNas values.
set.seed(321)
run_simulation(inputDataFile = "/User/VNasNDur_data.csv", speaker= "speaker", word = "word", phoneme = "phonemic",
               features = c("ndur.norm", "nasdur.norm"), memoryIntakeStrategy = "mahalanobisDistance", mahalanobisProbThreshold = .99, forgettingrate = .7,
               runs = 5, nrOfSnapshots = 60, interactionsPerSnapshot = 1000,
               usePercScores = TRUE, percScores = "nasal_voiceless_bias",
               biasedPhones = "nasal_voiceless", useEvalBias = TRUE, evalBiasScale = 0.2,)

#For the models in section 4, we simulated cumulative change in 6 DCT coefficients, representing the trajectory of nasal flow during and following the vowel. This seed data is found in DCT_data.csv.
#No perceptual bias mechanism was incorporated into the model in section 4.1. The parameters are as follows:
set.seed(321)
run_simulation(inputDataFile = "/User/DCT_data.csv", speaker= "speaker", word = "word", phoneme = "phonemic",
               features = c("DCT0", "DCT1", "DCT2", "DCT3", "DCT4", "DCT5"), memoryIntakeStrategy = "maxPosteriorProb", posteriorProbThreshold = 3/5, forgettingrate = .7,
               runs = 1, nrOfSnapshots = 60, interactionsPerSnapshot = 1000)
#Additional runs of this model (Appendix A) used random number seeds of 6, 7, 8, and 9.

#For the model in section 4.2 a bias mechanism was incorporated with the usePercScores parameter. This mechanism, activated with the usePercScores parameter, acts as a perceptual filter warping perceived tokens (useWarping) prior to evaluation.
set.seed(321)
run_simulation(inputDataFile = "/User/DCT_data.csv", speaker= "speaker", word = "word", phoneme = "phonemic",
               features = c("DCT0", "DCT1", "DCT2", "DCT3", "DCT4", "DCT5"), memoryIntakeStrategy = "maxPosteriorProb", posteriorProbThreshold = 3/5, forgettingrate = .7,
               runs = 1, nrOfSnapshots = 60, interactionsPerSnapshot = 1000,
               usePercScores = TRUE, percScores = "nasal_voiceless_bias",
               biasedPhones = "nasal_voiceless", useWarping = TRUE)
#Additional runs of this model (Appendix B) used random number seeds of 6, 7, 8, and 9.

#For the model in section 5, we developed the model in section 4.2 and incorporated the ability for bias scores to update (dynamicBias). This rate of change was scaled to a maximum of 0.5 in a single step (biasChangeRate).
set.seed(321)
run_simulation(inputDataFile = "/User/DCT_data.csv", speaker= "speaker", word = "word", phoneme = "phonemic",
               features = c("DCT0", "DCT1", "DCT2", "DCT3", "DCT4", "DCT5"), memoryIntakeStrategy = "maxPosteriorProb", posteriorProbThreshold = 3/5, forgettingrate = .7,
               runs = 1, nrOfSnapshots = 60, interactionsPerSnapshot = 1000,
               usePercScores = TRUE, percScores = "nasal_voiceless_bias",
               biasedPhones = "nasal_voiceless", useWarping = TRUE,
               dynamicBias = TRUE, biasChangeRate = 0.5)
#Additional runs of this model (Appendix C) used randum number seeds of 6, 7, 8, and 9.





