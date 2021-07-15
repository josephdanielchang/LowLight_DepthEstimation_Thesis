# Converts .npy file to .mat Matlab array

################################################################################
#
# 2021 University of California, San Diego
#
# Authors:
#  Joseph Chang (jdchang@ucsd.edu)
#
################################################################################

from scipy.io import savemat
import numpy as np
import glob
import os

def main():

    arr = np.load(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Godard_monodepth2\results\unmodified_net\left\01_enhanced\01_enhanced_disp.npy')
    print(np.max(arr))
    print(arr.shape)
    savemat(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Godard_monodepth2\results\unmodified_net\left\01_enhanced\01_enhanced_disp.mat', mdict={'arr': arr})

if __name__ == "__main__":
    main()