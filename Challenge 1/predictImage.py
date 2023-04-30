#!/usr/bin/env python3

import os
import sys
from BinaryClassificationModel import BinaryClassificationModel
import torch
from torchvision import transforms
import torchvision.transforms.functional as TF
from PIL import Image
from colorama import Fore, Style


######## ====== labels shown in output ======== ########
OKN_LABEL = 'OKN'
OK_LABEL = 'OK'
######## ======== change as desired =========== ########


# load model 
model = torch.load('model.pth')
model.eval()

transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5)),
    transforms.Lambda(lambda img: TF.crop(img, top=125, left=350, height=225, width=250))
])


def predict_image(img_path):
    """
    Predict an image and return its binary label, either 0 or 1.
    """
    image = Image.open(img_path)
    tensor_image = transform(image).unsqueeze(0)
    output = model(tensor_image)
    prediction = torch.max(output, 1)[1].item()
    return prediction


def get_all_images(dir_path):
    """
    Return a list of all images filenames found in the given directory, 
    including those found in subfolders.
    """
    image_files = []
    for foldername, subfolders, filenames in os.walk(dir_path):
        for filename in filenames:
            file_name = os.path.join(foldername, filename)
            if file_name.endswith('.jpg'): 
                image_files.append(os.path.join(foldername, filename))
    return image_files


def main():
    """
    Executes the script to predict image(s).
    """
    # process user input
    args = sys.argv[1:]
    if len(args) != 1:
        print(f'ERROR: Invalid number of arguments (must be 1).'); return

    file_path = args[0]
    if os.path.isfile(file_path):
        image_files = [file_path]
    elif os.path.isdir(file_path):
        image_files = get_all_images(file_path)
    else:
        print(f'ERROR: Invalid folder or image path.'); return

    # predict images
    predictions = [predict_image(image) for image in image_files]

    # aesthetics for printed output
    class_labels = {0: OK_LABEL, 1: OKN_LABEL} 
    colors = {0: Fore.GREEN, 1: Fore.RED}
    counts = {0: 0, 1: 0}

    for i in range(len(predictions)):
        image_path = image_files[i]
        pred = predictions[i]
        counts[pred] += 1
        print(f'{colors[pred] + class_labels[pred] + Style.RESET_ALL} - {image_path}') # OK/OKN - image.jpg

    if len(predictions) > 1:
        print('-------------')
        print(f'{counts[0]} {class_labels[0]} {"image" if counts[0] == 1 else "images"} ({round(counts[0]/len(predictions)*100, 1)}%)')
        print(f'{counts[1]} {class_labels[1]} {"image" if counts[1] == 1 else "images"} ({round(counts[1]/len(predictions)*100, 1)}%)')
        print('-------------')


if __name__ == '__main__':
    main()