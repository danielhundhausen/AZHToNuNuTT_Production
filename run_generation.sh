#!/bin/bash

MA=$1
MH=$2
EVENTS=$3
echo "MA-"$MA "MH-"$MH "Events: "$EVENTS

module use -a /afs/desy.de/group/cms/modulefiles/
module load cmssw
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/grid.desy.de/etc/profile.d/grid-ui-env.sh

GRIDPACKS="/nfs/dust/cms/user/hundhad/gridpacks_inv/AZHToNuNutt_MA-<MA>_MH-<MH>_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz"
BASEDIR=$(pwd)
export X509_USER_PROXY=${BASEDIR}"/x509up_u36978"
RUNDIR=${MA}_${MH}_$RANDOM$RANDOM

echo $X509_USER_PROXY
voms-proxy-info || exit 1

mkdir ${RUNDIR}
cd ${RUNDIR}

# Copy and prepare .py cfg files
cp ../step1_GEN.py .
cp ../step2_SIM.py .
cp ../step3_DIGI2RAW.py .
cp ../step4_HLT.py .
cp ../step5_RECO.py .
cp ../step6_MiniAOD.py .

#############################################################
# 1) GEN
#############################################################
export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_30_patch1/src ] ; then
  echo release CMSSW_10_6_30_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_30_patch1
fi
cd CMSSW_10_6_30_patch1/src
eval `scram runtime -sh`

# Prepare Fragment
# * copy fragment to Configuration/GenProduction/python
# * replace the path with the path to the gridpack
mkdir -p Configuration/GenProduction/python/
cp ${BASEDIR}/B2G-RunIISummer20UL17wmLHEGEN-03275-fragment.py Configuration/GenProduction/python/B2G-RunIISummer20UL17wmLHEGEN-03275-fragment.py
sed -i -e 's@<GRIDPACKS>@'\'$GRIDPACKS\''@g' Configuration/GenProduction/python/B2G-RunIISummer20UL17wmLHEGEN-03275-fragment.py
sed -i -e 's/<MA>/'$MA'/g' Configuration/GenProduction/python/B2G-RunIISummer20UL17wmLHEGEN-03275-fragment.py
sed -i -e 's/<MH>/'$MH'/g' Configuration/GenProduction/python/B2G-RunIISummer20UL17wmLHEGEN-03275-fragment.py
sed -i -e 's/<NEVENTS>/'$EVENTS'/g' Configuration/GenProduction/python/B2G-RunIISummer20UL17wmLHEGEN-03275-fragment.py

scram b
cd ../..

# cmsRun command
sed -i -e 's@<GRIDPACKS>@'\'$GRIDPACKS\''@g' step1_GEN.py
sed -i -e 's/<MA>/'$MA'/g' step1_GEN.py
sed -i -e 's/<MH>/'$MH'/g' step1_GEN.py
sed -i -e 's/<NEVENTS>/'$EVENTS'/g' step1_GEN.py
cmsRun step1_GEN.py


#############################################################
# 2) SIM
#############################################################
export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_17_patch1/src ] ; then
  echo release CMSSW_10_6_17_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_17_patch1
fi
cd CMSSW_10_6_17_patch1/src
eval `scram runtime -sh`

scram b
cd ../..

# cmsRun command
cmsRun step2_SIM.py

#############################################################
# 3) DIGI2RAW
# #############################################################
export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_17_patch1/src ] ; then
  echo release CMSSW_10_6_17_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_17_patch1
fi
cd CMSSW_10_6_17_patch1/src
eval `scram runtime -sh`

scram b
cd ../..

# cmsRun command
cmsRun step3_DIGI2RAW.py


#############################################################
# 4) HLT
#############################################################
export SCRAM_ARCH=slc7_amd64_gcc630

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_9_4_14_UL_patch1/src ] ; then
  echo release CMSSW_9_4_14_UL_patch1 already exists
else
  scram p CMSSW CMSSW_9_4_14_UL_patch1
fi
cd CMSSW_9_4_14_UL_patch1/src
eval `scram runtime -sh`

scram b
cd ../..

# cmsRun command
cmsRun step4_HLT.py


#############################################################
# 5) RECO
#############################################################
export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_17_patch1/src ] ; then
  echo release CMSSW_10_6_17_patch1 already exists
else
  scram p CMSSW CMSSW_10_6_17_patch1
fi
cd CMSSW_10_6_17_patch1/src
eval `scram runtime -sh`

scram b
cd ../..

# cmsRun command
cmsRun step5_RECO.py


#############################################################
# 6) PAT / MINIAOD
#############################################################
export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_20/src ] ; then
  echo release CMSSW_10_6_20 already exists
else
  scram p CMSSW CMSSW_10_6_20
fi
cd CMSSW_10_6_20/src
eval `scram runtime -sh`

scram b
cd ../..

# cmsRun command
cmsRun step6_MiniAOD.py

