# Container Alignment Classifer

`model.pth` is binary image classifier used to predict whether or not a container is properly aligned on a conveyor belt. 


## Model Assumptions

This model makes the following assumptions:
- images are of size `640x360`
- images are of type `.jpg`
- container is in the same relative position in each image

Given the automated nature of the provided training images (all images taken from the same angle at the same point time along the conveyor belt), I felt it was appriate to keep these assumptions.

If future images do not meet either condition, both the model and script will need to be updated.


##  Running From Command Line:
`predictImage.py` takes exactly one argument, either a path to a specific image, or a path to a folder containing images to predict. The script will terminate early if the wrong number of arguments is passed, or if an invalid argument is passed. 

```
$ ./predictImage.py image.jpg
```
```
$ ./predictImage.py images_folder
```
When passed a folder, `predictImage.py` will walk through the entire folder, including subfolders, and find every `.jpg` image to predict. `images_folder` can have any type of structure. Here are two examples:

```
images_folder
    | 
    img1.jpg
    img2.jpg
    img3.jpg
    img4.jpg
```

```
images_folder
    | 
    2022_10_13
    |   |
    |   img1.jpg
    |   img2.jpg
    | 
    2022_10_14
        |
        img3.jpg
        img4.jpg
```
Both folder structures will produce the same output, disregarding the differences in relative filepaths. Note that a summary is only printed when more than one image is found.

```
$ ./predictImage.py images_folder
GOOD - images_folder/img1.jpg
GOOD - images_folder/img2.jpg
BAD - images_folder/img3.jpg
GOOD - images_folder/img4.jpg
-------------
3 GOOD images
1 BAD image
-------------
```


## User Output Preferences

Within `predictImage.py` there are several variables that can be changed to alter the printed output. They can be found at the top of the script. 
- `OK_LABEL`: name for the properly-aligned containers (default `'OK'`)
- `OKN_LABEL`: name for the misaligned containers (default `'OKN'`) 

The code is very straightforward, so any other desirerd changes to the printed output would be easy. The script prodces a list of class predictions (`predictions`), and a list of image file names (`image_files`). The first index of `predictions` corresponds to the first index of `image_files`, and so forth. 
