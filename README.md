# AZHToNuNuTTProduction

So far this is only the setup for 2017. Depending on need, will extend to
all years in future.

cmsDriver commands from [this
chain](https://cms-pdmv.cern.ch/mcm/chained_requests?prepid=B2G-chain_RunIISummer20UL17wmLHEGEN_flowRunIISummer20UL17SIM_flowRunIISummer20UL17DIGIPremix_flowRunIISummer20UL17HLT_flowRunIISummer20UL17RECO_flowRunIISummer20UL17MiniAODv2_flowRunIISummer20UL17NanoAODv9-02027&page=0&shown=15).


## NTuplize MiniAODs
To convert the MiniAODs into the UHH2 NTuple format,
use the [ntuplewriter
scripts](https://github.com/UHH2/UHH2/blob/RunII_106X_v2/core/python/ntuplewriter_data_UL17.py)
provided in UHH2.
Replace the strings in the list of filenames by the paths of the production
output and add the 'files:' prefix. Then run with `cmsRun`.
