# Converts yolo output file (result.json) to individual yolo format .txt files
# output format: <class_id><confidence>x_center><y_center><width><height> (RELATIVE)

################################################################################
#
# 2021 University of California, San Diego
#
# Authors:
#  Joseph Chang (jdchang@ucsd.edu)
#
################################################################################

import argparse
import json
from pathlib import Path

LABEL_MAP = {
    "car": 2,
    "bus": 5,
    "person": 0,
    "bicycle": 1,
    "truck": 7,
    "motorbike": 3,
    "train": 6,
    "horse": 17,
    "stop sign": 11,
    "traffic light": 9,
    "cup": 41,
    "bowl": 45,
    "chair": 56,
    "cell phone": 67,
    "fire hydrant": 10,
    "tvmonitor": 62,
    "umbrella": 25,
    "pottedplant": 57,
    "backpack": 24,
    "clock": 74,
    "handbag": 26,
    "bird": 14,
    "boat": 8,
    "laptop": 63,
    "skateboard": 36,
    "parking meter": 12,
    "keyboard": 66,
    "suitcase": 28,
    "bottle": 39,  # start here
    "aeroplane": 4,
    "remote": 65,
    "surfboard": 37,
    "dog": 16,
    "bench": 13,
    "wine glass": 40,
    "tie": 27,
    "toilet": 61,
    "sports ball": 32,
    "oven": 69,
    "mouse": 64,
    "snowboard": 31,
    "book": 73,
    "frisbee": 29
}

IMG_WIDTH = 1280
IMG_HEIGHT = 720


def box2d_to_yolo(box2d):
    x1 = box2d["left_x"] / IMG_WIDTH
    x2 = (box2d["left_x"] + box2d["width"]) / IMG_WIDTH
    y1 = (box2d["top_y"] - box2d["height"]) / IMG_HEIGHT
    y2 = box2d["top_y"] / IMG_HEIGHT

    y1_pixels = (box2d["top_y"] - box2d["height"])
    y2_pixels = box2d["top_y"]

    print(y1_pixels)
    print(y2_pixels)

    width = abs(x2 - x1)
    height = abs(y2 - y1)
    cx = (x1 + x2) / 2
    cy = ((y2_pixels - ((y2_pixels-y1_pixels)/2)) / IMG_HEIGHT) + height

    print(cy)

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
        img_name = Path(frame["filename"][-21:])
        print(img_name)
        assert img_name.suffix == ".jpg"
        frame_name = str(img_name.stem)
        frame_file = output_dir / (frame_name + ".txt")

        # Creates, opens, and adds to a txt file with the name of each image.jpg
        with open(frame_file, "w+") as f:
            # For each sub label of each image, get the box2d variable
            # Get the relative center point compared to the image size 1280/720
            for label in frame["objects"]:
                if "relative_coordinates" not in label:
                    continue
                box2d = label["relative_coordinates"]
                if box2d["width"] <= 0 or box2d["height"] <= 0:
                    continue
                cx, cy, width, height = box2d_to_yolo(box2d)
                lbl = LABEL_MAP[label["name"]]
                confidence = label["confidence"]

                f.write("{} {} {} {} {} {}\n".format(lbl, confidence, cx, cy, width, height))


def convert_labels(label_path, output_dir):
    """
    Intermediate method called to pass the argument in to the label2txt folder.

    :params
        label_path  : The path where image labels are present. Basically the .json file
        det_path    : The path for the output detection file
    """

    frames = json.load(open(label_path, "r"))
    print('Size',len(frames))
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


    # label_json = Path(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_8k\yolo_output_enhanced\result.json')
    # output_dir = Path(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_8k\yolo_output_enhanced\labels_txt')
    label_json = Path(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_7130\yolo_output_normal\result.json')
    output_dir = Path(r'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_7130\yolo_output_normal\labels_txt')

    assert label_json.is_file(), "Given argument is not a label.json file"
    output_dir.mkdir(parents=True, exist_ok=True)

    convert_labels(label_json, output_dir)


if __name__ == "__main__":
    main()