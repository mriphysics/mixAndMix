# mixAndMix
Tools for computation of empirical spectral distributions

This repository provides tools to implement the methods and reproduce the experiments included in the manuscript ''Numerical techniques for the computation of sample spectral distributions of population mixtures'', L Cordero-Grande. Unpublished.

The code has been developed in MATLAB and has the following structure:

###### ./
contains the scripts for running all the experiments corresponding to the figures in the manuscript: *mixAndMix_Exp[01-13].m* and wrappers to different alternatives for computing the empirical spectral distributions (ESD), *ESDMarcenkoPastur.m*, *ESDMixAndMix.m*, *ESDQuest.m*, *ESDSimulated.m*, *ESDSpectrode.m*, *ESDTwoDeltas.m*.

###### ./Build
contains scripts that replace, extend or adapt some MATLAB built-in functions: *diagm.m*, *dynInd.m*, *eigm.m*, *emtimes.m*, *indDim.m*, *matfun.m*, *multDimMax.m*, *multDimSum.m*, *numDims.m*, *parUnaFun.m*, *resPop.m*, *resSub.m*, *sub2indV.m*.

###### ./Figures
contains scripts for generating the graphical materials: *labelFig.m*, *plotObjective.m*, *styleFigRoutine.m*.

###### ./Figures/Colormaps
contains tools to generate colormaps from https://uk.mathworks.com/matlabcentral/fileexchange/51986-perceptually-uniform-colormaps.

###### ./MarcenkoPasturCode
contains scripts that implement the Marcenko-Pastur law for computing the ESD *marcenkoPastur.m*.

###### ./Matrices
contains scripts for operations with matrices: *mat2bldiag.m*.

###### ./Methods
contains scripts with generic methods: *plugNoise.m*.

###### ./MixAndMixCode
contains scripts that implement the proposed MidAndMix ESD computation method: *addCorrelation.m*, *andersonMixing.m*, *arraySupport.m*, *fillGridPoints.m*, *gridSubdivide.m*, *interp1GPU.m*, *nonUniformGridAddPoints.m*, *pinvmDamped.m*, *startingGrid.m*.

###### ./QuestCode
contains scripts that implement the Quest ESD computation method in the manuscript ''Numerical implementation of the QuEST function'', O Ledoit, and M Wolf, Comput. Stat. Data Anal., 2017, 115:199-223 from https://www.econ.uzh.ch/en/people/faculty/wolf/publications.html#9.

###### ./SpectrodeCode
contains scripts that implement the Spectrode ESD estimation method in the manuscript ''Efficient computation of limit spectra of sample covariance matrices'', E Dobriban, Rand. Matr. Th. Appl., 2015, 4(4):1550019:1-36 from https://github.com/dobriban/EigenEdge/

NOTE 1: The results in the paper correspond to executions on an 8(16) x Intel(R) Core(TM) i7-5960X CPU @ 3.00GHz 64GB RAM with a GeForce GTX TITAN X under MATLABR2019a.

NOTE 2: Generation of the figures for the scripts *mixAndMix_Exp[02,04,06,08,10,11,12]* should be very quick, while the scripts *mixAndMix_Exp[01,03,05,07,09,13]* may take longer, as they involve measurements of computation times.

