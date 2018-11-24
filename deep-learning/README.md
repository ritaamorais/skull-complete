# Deep Learning

This folder contains the source code for implementing the Volumetric Denoising Autoencoder in PyTorch.
The code is organized as follows:
* `data_loader.py` – specifies how the data is loaded and with which form is given as
input to the network;
* `utils.py` – contains utility functions for logging and saving and loading the model;

* `30 or 60 or 120/` – folders where the necessary code for implementing the network to
the resolutions of 303, 603 and 1203, respectively, are located.
  - `data/` – folder where the training and testing data files are located;
  - `net.py` – defines the neural network architecture by initializing its layers and
then by defining in the forward function how they are applied to the input. The
loss function is also specified in this file;
  - `train.py` – contains the main training loop, which consists of passing a batch of
inputs through the model, calculating the loss, performing backpropagation and
updating the parameters;
  - `test.py` – contains the code for testing the model. Namely, there are two possible
ways to test the model: with the function test_all, which takes all the
test samples and outputs the completion and the average denoising error, or by
feeding one defected instance from the test set to the network with the function
test_instance and saving the completion output in a file that can later be
visualized in Matlab.
