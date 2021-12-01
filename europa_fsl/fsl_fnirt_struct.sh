#!/usr/bin/bash

"""
The test script for fnirt command

Input:
	T1: T1.nii.gz
	reference: MNI152_T1_1mm
	aff: T1_to_MNI_linear.mat
	configuration: bb_fnirt.cnf
	refernce_mask: MNI152_T1_1mm_brain_mask_dil_GD7
Output:
	log: bb_T1_to_MNI_fnirt.log
	cout,fout, jout, iout: T1_to_MNI/T1_brain_to_MNI


"""



ml load fsl

#FSLDIR=/opt/ohpc/pub/unpackaged/apps/fslbinary/6.0.4

baseDir=./struct

${FSLDIR}/bin/fnirt --in=$baseDir/T1 --ref=$FSLDIR/data/standard/MNI152_T1_1mm --aff=$baseDir/T1_to_MNI_linear.mat \
  --config=$baseDir/bb_fnirt.cnf --refmask=$baseDir/MNI152_T1_1mm_brain_mask_dil_GD7 \
  --logout=bb_T1_to_MNI_fnirt.log --cout=T1_to_MNI_warp_coef --fout=T1_to_MNI_warp \
  --jout=T1_to_MNI_warp_jac --iout=T1_brain_to_MNI.nii.gz --interp=spline
