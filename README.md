# Computer-aided Design of Cranial Implants: A Deep learning Approach

The main goal of this project is proposing an approach towards the automatization of the Computer-aided Design (CAD) process of cranial implants for neurosurgery,  allowing the design process to be less-user dependent and less time consuming
while still obtaining accurate implant models. 

The problem of generating a cranial implant, which is essentially filling in a hole in a skull, can be thought of as a 3D shape completion task.

In this project, a Volumetric Denoising Autoencoder (DAE) is implemented and trained with a dataset of 3D models of healthy skulls (with no cranial defects). So that when given a 3D model of a defected skull, it is able to complete the missing part and output the same skull but completed. Then, the implant would be a subtraction of the defected skull to the completed skull.

This repository is divided into two main folders:
* `data-prep/`: contains the necessary scripts to pre-process the data, from collecting it from the Connectome Database until having it represented as a 4D array and ready to be given as input to the deep neural network.

* `deep learning/`: contains the source code for implementing the volumetric denoising autoencoder in the deep learning framework PyTorch.
