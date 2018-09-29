# Data Preparation
This folder contains all the necessary scripts to process the MRI data into 3D skull models and prepare them to be given as input to the Volumetric Denoising Autoencoder (DAE). The scripts are divided by their type (bash scripts, matlab scripts or mevislab network).

## Collecting the Data
The dataset used in this project consists of 1113 3D skull models that were obtained from real MRI images from the 1200 Subjects Release (S1200), an open-access dataset provided by the Human Connectome Project (HCP) and available in https://humanconnectome.org/study/hcp-young-adult/document/1200-subjects-data-release/.

This dataset was collected between 2012 and 2015 and contains high-resolution 3 Tesla (3T) structural T1w MRI scans from 1113 healthy young adults in the age range of 22 to 35 years old.

The extraction of the T1w MRI scans from each subject of this dataset is possible by using the bash script `./bash-scripts/parse.bat`.

## Skull Extraction from MRI Scans
For this step, the MRI analysis software tool BrainSuite is required - http://brainsuite.org/

With BrainSuite’s Cortical Surface Extraction sequence, it is possible to produce surface mesh models of the brain, the skull and the scalp in an automated way.

Only the first two steps of this sequence are needed to extract surface mesh models of the skull:
* **skull stripping** (`bse`)
* **skull and scalp modelling** (`skullfinder`)

**Output:** 4 DFS surface representation files of the brain, inner and outer skull surfaces and the scalp, for each subject.

In order to use BrainSuite’s tools to automatically process all the 1113 T1w MRI scans in the dataset, the bash script `./bash-scripts/cortical_extraction.cmd`, which is provided along with the BrainSuite software, was adapted so that only the first two steps of the cortical surface extraction sequence are executed.

## Skull Mesh Generation
For this step, Matlab and the iso2mesh toolbox are required - http://iso2mesh.sourceforge.net/cgi-bin/index.cgi

Running the Matlab script `./matlab-scripts/skull_mesh_stl.m` processes the inner and outer skull DFS surface files of each of the 1113 subjects in the dataset, by merging the inner and outer skull surfaces together in one single volumetric mesh and converting the resulting mesh to the STL file format. This results in 1113 STL files of 3D models of healthy skulls (with no cranial defects).
