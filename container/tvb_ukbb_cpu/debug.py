#!/usr/bin/bash
import os
import sys
import glob
import math

from random import shuffle

import numpy as np

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms

import nibabel as nib

# import util

gpath = '/work/08008/yilewang/ls6/hsam/tvb-ukbb/bb_diffusion_pipeline/tvb_SynB0/src'
sys.path.append(gpath)
from model import UNet3D


if __name__ == '__main__':
    # Get input arguments ----------------------------------#
    pth = gpath+'/train_lin/num_fold_1_total_folds_5_seed_1_num_epochs_100_lr_0.0001_betas_(0.9, 0.999)_weight_decay_1e-05_num_epoch_97.pth'

    model_path = pth
    # model_path = "/home/yat-lok/workspace/container/num_fold_1_total_folds_5_seed_1_num_epochs_100_lr_0.0001_betas_(0.9, 0.999)_weight_decay_1e-05_num_epoch_97.pth"
    print('Model path: ' + model_path)

    # Run code ---------------------------------------------#

    # Get device
    device = torch.device("cpu")

    # Get model
    model = UNet3D(2, 1).to(device)
    model.load_state_dict(torch.load(model_path, map_location=device))
