# Converts Berkeley Deep Drive labels (det_Train.json) to individual yolo format .txt files
# note: no confidences in output
# Things to edit for use: LABEL_MAP, label_json, output_dir

################################################################################
#
# 2021 University of California, San Diego
#
# Authors:
#  Joseph Chang (jdchang@ucsd.edu)
#
################################################################################

import json
from pathlib import Path

LABEL_MAP = {
    "car": 2,
    "bus": 5,
    "pedestrian": 0,
    "bicycle": 1,
    "truck": 7,
    "motorcycle": 3,
    "train": 6,
    "rider": 17,
    "traffic sign": 11,
    "traffic light": 9
}

IMG_WIDTH = 1280
IMG_HEIGHT = 720


def box2d_to_yolo(box2d):
    x1 = box2d["x1"] / IMG_WIDTH
    x2 = box2d["x2"] / IMG_WIDTH
    y1 = box2d["y1"] / IMG_HEIGHT
    y2 = box2d["y2"] / IMG_HEIGHT

    cx = (x1 + x2) / 2
    cy = (y1 + y2) / 2
    width = abs(x2 - x1)
    height = abs(y2 - y1)

    return cx, cy, width, height


def label2txt(frames, output_dir: Path):
    """
    This function converts the labels into a .txt file with the same name as the image.
    It extracts the bounding box, class info from the .json file and converts it into
    the darknet format.

    The darknet format is
        <object id> <x> <y> <width> <height>

    :params
        frames : each image with labeled information in the .json file.
        det_path : The path to output detection file.
    """
    assert output_dir.is_dir(), "Output directory doesn't exist"
    output_dir = output_dir.absolute()

    for frame in frames:
        img_name = Path(frame["name"])
        assert img_name.suffix == ".jpg"
        frame_name = str(img_name.stem)
        frame_file = output_dir / (frame_name + ".txt")

        # Creates, opens, and adds to a txt file with the name of each image.jpg
        with open(frame_file, "w+") as f:
            # For each sub label of each image, get the box2d variable
            # Get the relative center point compared to the image size 1280/720
            for label in frame["labels"]:
                if "box2d" not in label:
                    continue
                box2d = label["box2d"]
                if box2d["x1"] >= box2d["x2"] or box2d["y1"] >= box2d["y2"]:
                    continue
                cx, cy, width, height = box2d_to_yolo(box2d)

                # Exclude classes that are in BDD, but not YOLO
                if label["category"] == "other vehicle":
                    break
                if label["category"] == "other person":
                    break

                lbl = LABEL_MAP[label["category"]]
                f.write("{} {} {} {} {}\n".format(lbl, cx, cy, width, height))


def convert_labels(label_path, output_dir):
    """
    Intermediate method called to pass the argument in to the label2txt folder.

    :params
        label_path  : The path where image labels are present. Basically the .json file
        det_path    : The path for the output detection file
    """

    frames = json.load(open(label_path, "r"))
    label2txt(frames, output_dir)


def main():

    # ap = argparse.ArgumentParser()
    # ap.add_argument("-l", "--label_path", help="path to the label file")
    # ap.add_argument("-d", "--det_path", help="path to output detection file")
    # # ap.add_argument('-n', '--folder_name', help='name of the label folder')
    # args = ap.parse_args()
    #
    # label_json = Path(args.label_path).absolute()
    # output_dir = Path(args.det_path).absolute()


    label_json = Path(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_7130\ground_truth\det_train_7130.json')
    output_dir = Path(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_7130\ground_truth\labels_txt')

    assert label_json.is_file(), "Given argument is not a label.json file"
    output_dir.mkdir(parents=True, exist_ok=True)

    convert_labels(label_json, output_dir)


if __name__ == "__main__":
    main()