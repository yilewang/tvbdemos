#!/usr/bin/bash


#The test script for fsl eddy.
#
#Input:
#	main DWI data: DWI.nii.gz
#	mask: rawDTI_B0_brain_mask.nii.gz
#	acqp: acqparames.txt
#	index: eddy_index.txt
#	bvecs: bvecs
#	bvalues: bvals
#Output:
#	data.* files




ml load fsl

#FSLDIR=/opt/ohpc/pub/unpackaged/apps/fslbinary/6.0.4

baseDir=.

$FSLDIR/bin/eddy_openmp --imain=$baseDir/dMRI/dMRI/DWI.nii.gz --mask=$baseDir/dMRI/dMRI/rawDTI_B0_brain_mask.nii.gz --acqp=$baseDir/dMRI/dMRI/acqparams.txt --index=$baseDir/dMRI/dMRI/eddy_index.txt --bvecs=$baseDir/dMRI/dMRI/bvecs --bvals=$baseDir/dMRI/dMRI/bvals --out=$baseDir/dMRI/dMRI/data --flm=quadratic --resamp=jac --slm=linear --fwhm=2 --ff=5  --sep_offs_move --nvoxhp=1000 --repol --rms --cnr_maps 
