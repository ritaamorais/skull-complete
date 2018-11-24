# Deep Learning

This folder contains the source code for implementing the Volumetric Denoising Autoencoder (DAE) in **PyTorch**.
The code is organized as follows:
* `data_loader.py` – specifies how the data is loaded and with which form is given as
input to the network;
* `utils.py` – contains utility functions for logging and saving and loading the model;

* `30 or 60 or 120/` – folders where the necessary code for implementing the network to
the resolutions of 30<sup>3</sup>, 60<sup>3</sup> and 120<sup>3</sup>, respectively, are located.
  - `data/` – folder where the training and testing data files are located;
  - `net.py` – defines the neural network architecture by initializing its layers and
then by defining in the forward function how they are applied to the input. The
loss function is also specified in this file;
  - `train.py` – contains the main training loop, which consists of passing a batch of
inputs through the model, calculating the loss, performing backpropagation and
updating the parameters;
  - `test.py` – contains the code for testing the model. Namely, there are two possible
ways to test the model: with the function `test_all`, which takes all the
test samples and outputs the completion and the average denoising error, or by
feeding one defected instance from the test set to the network with the function
`test_instance` and saving the completion output in a file that can later be
visualized in Matlab.

# Data
Experiments with the Volumetric DAE were carried out for inputs with three different voxel resolutions: 30<sup>3</sup>, 60<sup>3</sup> and 120<sup>3</sup>, resulting in three different datasets with the same 3D skull models but at different voxel resolutions. For each of these datasets, all the instances of each training and testing set are stored in the same 4D array.

Therefore, each dataset is stored as follows, taking into account that *d* denotes the chosen voxel resolution:
* `train_data.mat` - .mat file which contains a 4D array variable named `healthy`, shaped as *(891, d, d, d)* and that stores the 891 instances of healthy skulls which are used for training;
* `test_data.mat` - .mat file containing two 4D array variables named `healthy` and `defected`, both shaped as *(222, d, d, d)*. `healthy` stores the 222 instances of healthy skulls which are used for testing as ground-truth, and `defected` stores the 222 instances of defected skulls which are used for testing to be reconstructed.
