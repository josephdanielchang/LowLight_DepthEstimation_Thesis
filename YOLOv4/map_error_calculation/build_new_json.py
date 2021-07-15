# Input: ground truth labels.json, filenames of selected images
# Output: new labels.json with labels of selected images
# Things to edit for use: labels path, jsonFile path, images path

################################################################################
#
# 2021 University of California, San Diego
#
# Authors:
#  Joseph Chang (jdchang@ucsd.edu)
#
################################################################################

import json
import os

def main():

    # load ground truth json
    with open(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_(Untouched)\labels\det_20\det_train.json') as f:
        labels = json.load(f)

    # create json file to write to
    jsonFile = open(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_7130\ground_truth\det_train_7130.json', 'w')
    print('json file created')

    # loop through all image file names
    jsonFile.write('[\n')
    for file in os.listdir(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_7130\ground_truth\images'):
        print(file)
        # write to json file
        for aDict in labels:
            if aDict['name'] == file:
                jsonString = json.dumps(aDict, indent=2)
                jsonFile.write(jsonString)

                jsonFile.write(',\n')
                print(aDict)
                break

    jsonFile.write(']')
    jsonFile.close()

if __name__ == "__main__":
    main()