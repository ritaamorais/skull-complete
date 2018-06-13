#loadmat
#torch

import torch
from scipy.io import loadmat

def load_data(data_path, type):
    """
    loads the data from the mat files
    :param data_path: directory where the path to the mat file containing the data is located
    :param type: labels or dataset (variable to load from the mat file)

    :return: return data in tensor form and size (number of samples)
    """

    data_mat=loadmat(data_path)[type]

    data_mat=data_mat.astype(float) #convert to float

    data=torch.from_numpy(data_mat)

    data_size=data_mat.shape[0]

    return data, data_size
