# Converts yolov5 output label .txt files from
# <class_id><x_center><y_center><width><height><confidence> (RELATIVE)
# to
# <class_id><confidence>x_center><y_center><width><height> (RELATIVE)
# and saves to new .txt files to reformatted folder

################################################################################
#
# 2021 University of California, San Diego
#
# Authors:
#  Joseph Chang (jdchang@ucsd.edu)
#
################################################################################

import argparse
from pathlib import Path
import os
from glob import glob


def read_write_text_file(input_file_path, output_file_path):
    f1 = open(input_file_path, 'r')
    f2 = open(output_file_path, 'w')

    lines = f1.readlines()
    for line in lines:
        nums = line.split()
        print(nums)
        new_output_line = nums[0] + ' ' + nums[5] + ' ' + nums[1] + ' ' + nums[2] + ' ' + nums[3] + ' ' + nums[4] + '\n'
        print(new_output_line)
        f2.write(new_output_line)

    f1.close()
    f2.close()


def main():
    # input_dir_string = r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv5\labels_txt_normal'
    # output_dir_string = r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv5\labels_txt_normal_reformatted'
    input_dir_string = r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv5\labels_txt_enhanced'
    output_dir_string = r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv5\labels_txt_enhanced_reformatted'
    input_dir = Path(input_dir_string)
    output_dir = Path(output_dir_string)

    os.chdir(output_dir)

    for file in os.listdir(input_dir):
        if file.endswith('.txt'):
            input_file_path = input_dir_string + '\\' + file
            output_file_path = output_dir_string + '\\' + file

            read_write_text_file(input_file_path, output_file_path)
            print(file)


if __name__ == "__main__":
    main()
