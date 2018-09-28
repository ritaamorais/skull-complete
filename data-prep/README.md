# Data Preparation
This folder contains all the necessary scripts to process the MRI data into 3D skull models and prepare them to be given as input to the Volumetric Denoising Autoencoder (DAE).

# Data
The dataset used in this project consists of 1113 3D skull models that were obtained from real MRI images from the 1200 Subjects Release (S1200), an open-access dataset provided by the Human Connectome Project (HCP) and available in https://humanconnectome.org/study/hcp-young-adult/document/1200-subjects-data-release/.

This dataset was collected between 2012 and 2015 and contains high-resolution 3 Tesla (3T) structural T1w MRI scans from 1113 healthy young adults in the age range of 22 to 35 years old.

The extraction of the T1w MRI scans from each subject of this dataset is possible by using the bash script `parse.bat`.

# Skull Extraction from MRI Scans
TODO
