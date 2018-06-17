"""Tests the model"""

import argparse
import logging
import math
import os

import data_loader
import torch
from scipy.io import savemat
from torch import nn

import net
import utils

parser = argparse.ArgumentParser()
parser.add_argument('--test_data_dir', default='./data/test_data.mat', help="Path containing the testing dataset")
parser.add_argument('--model_dir', default='./logs/', help="Directory containing the model")


def test_all(model, test_data, test_labels, tesize):
    """
    -- takes all the test samples and outputs the completion and the average denoising error
    """

    # set model to evaluation mode
    model.eval()

    #load test data
    test_data.cuda()

    inputs = torch.Tensor(tesize, 1, 30, 30, 30).cuda()
    outputs = torch.Tensor(tesize, 30*30*30).cuda()
    perfect_cubes = torch.Tensor(tesize, 1, 30, 30, 30).cuda()

    for k in range(tesize):
        input = test_data[k]
        input = input.double()


        perfect_input = test_labels[k]
        perfect_input = perfect_input.double()

        perfect_cubes[k] = perfect_input
        inputs[k] = input

        input = input.cuda()
        output=model.forward(input)
        outputs[k] = output

    #inputs=inputs.cuda()
    #outputs=model.forward(inputs)
    outputs=outputs.double()
    outputs=outputs.reshape(tesize, 1,30,30,30)

    #now that we have the output, estimate the error on the denoising task by only considering those voxels which were shut down at test time randomly
    #error = reconstructed - original input
    err = 0

    #TODO: alterar este for para que os inputs sejam dados como (1,1,30,30,30) e não tudo de uma vez (222,1,30,30,30)
    for i in range(tesize):
        output = outputs[i]

        bin_output = torch.gt(output, 0.5)  # gt means >
        bin_output = bin_output.double()

        perfect_cube = perfect_cubes[i]
        perfect_cube = perfect_cube.double()
        perfect_cube = perfect_cube.cuda()
        noisey_voxels_tensor = torch.ne(bin_output, perfect_cube)  # this will give me a zero one tensor (1,30,30,30)indicating 1 where the cubes are equal in value and 0 otherwise; --ne means not equal (!=)
        noisey_voxels_idx = torch.nonzero(noisey_voxels_tensor)  # this will give x by 4 (2 dims) matrix

        dummy = torch.numel(noisey_voxels_idx)  # numel counts the number of elements in the matrix "noisey_voxels_idx" - ou seja conta o numero de voxels em que a reconstrucao é diferente do original/correto

        if dummy > 0:
            err = err + noisey_voxels_idx.size()[0]

        else:
            print('no error in this example')

    aa = err/tesize

    te_err = aa * 100 / 13824  # 13824 is the total number of voxels in the grid for this specific resolution (24x24x24=13824)
    return te_err

def test_instance(model, i, test_data, test_labels, tesize):
    """
    this function is meant to feed the corrupted 3D test data to the network and save the output in binary format
--this output is then read and visualized in matlab.
    """
    # set model to evaluation mode
    model.eval()

    #MSELoss
    loss_fn = nn.MSELoss()

    test_labels = test_labels.reshape(tesize, 30*30*30)
    model.encoder.__delitem__(0) #remove the dropout layer

    inputs=torch.Tensor(1,1,30,30,30)
    inputs=inputs.cuda()

    input=test_data[i]
    input=input.cuda()
    inputs[0]=input

    target=test_labels[i]
    outputs=model.forward(inputs)
    outputs=outputs.float()
    target=target.float()

    outputs=outputs.cuda()
    target=target.cuda()

    err = loss_fn(outputs, target)

    return err, outputs

def save_output(outputs, filename):
    outputs=outputs.reshape(30,30,30)
    outputs=torch.squeeze(outputs)

    dims=outputs.ndimension()

    if dims > 1:
        for i in range(math.floor(dims/2)-1):
            outputs=torch.transpose(outputs, i, dims-i-1)
        outputs=outputs.contiguous()

    outputs=outputs.cpu()
    np_outputs=outputs.numpy()
    np_outputs.astype(float)
    savemat(filename, dict([('output', np_outputs)]))



if __name__ == '__main__':

    args = parser.parse_args()

    # Set the random seed for reproducible experiments
    #torch.manual_seed(230)

    # Get the logger
    utils.set_logger(os.path.join(args.model_dir, 'evaluate.log'))

    # Create the input data pipeline
    logging.info("Loading the test dataset...")

    # LOAD TESTING DATA
    test_data, tesize = data_loader.load_data(args.test_data_dir, 'dataset')
    logging.info("Number of testing examples: {}".format(tesize))

    test_labels, tesize_labels = data_loader.load_data(args.test_data_dir, 'labels')

    #initialize the model
    autoencoder = net.VolAutoEncoder()
    autoencoder.cuda()


    #reload weights from the saved file
    utils.load_checkpoint(os.path.join(args.model_dir, 'last.pth.tar'), autoencoder)

    #...and test!
    #test all
    #te_err = test_all(autoencoder, test_data, test_labels, tesize)
    #print('the test error is ' + str(te_err) + '%')


    #------test instance-----------
    te_err, outputs=test_instance(autoencoder,145,test_data,test_labels,tesize)
    logging.info("The test error is {} %".format(te_err))

    i=145
    filename= './recons'+str(i)
    save_output(outputs,filename)
