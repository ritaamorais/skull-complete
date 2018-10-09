"""Tests the model"""

import argparse
import logging
import math
import os

import data_loader
import net
import torch
import utils
from scipy.io import savemat
from torch import nn

parser = argparse.ArgumentParser()
parser.add_argument('--i', default=25, help="Index of example instance for testing")
parser.add_argument('--test_data_dir', default='./data/test_data.mat', help="Path containing the testing dataset")
parser.add_argument('--model_dir', default='./logs/', help="Directory containing the model")


def test_all(model, test_data, test_labels, tesize):
    """
    Takes all the test samples and outputs the completion and the average denoising error
    """

    # set model to evaluation mode
    model.eval()

    test_data.cuda()

    inputs = torch.Tensor(tesize, 1, 60, 60, 60).cuda()
    outputs=torch.Tensor(tesize, 60*60*60).cuda()
    perfect_cubes = torch.Tensor(tesize, 1, 60, 60, 60).cuda()

    for k in range(tesize):
        input = test_data[k]
        input=input.double()
        input=input.cuda()

        perfect_input = test_labels[k]
        perfect_input = perfect_input.double()

        perfect_cubes[k] = perfect_input
        inputs[k] = input

    inputs=inputs.cuda()
    outputs=model.forward(inputs)
    outputs=outputs.double()
    outputs=outputs.reshape(tesize, 1,60,60,60)

    #After computing the outputs, estimate the error on the denoising task
    #error = reconstructed - original inputt
    err = 0

    for i in range(tesize):
        output = outputs[i]

        bin_output = torch.gt(output, 0.5)  # gt means >
        bin_output = bin_output.double()

        perfect_cube = perfect_cubes[i]
        perfect_cube = perfect_cube.double()
        perfect_cube = perfect_cube.cuda()
        noisey_voxels_tensor = torch.ne(bin_output, perfect_cube)  #This will give a binary tensor (1,30,30,30) indicating 1 where the cubes are equal in value and 0 otherwise; --ne means not equal (!=)
        noisey_voxels_idx = torch.nonzero(noisey_voxels_tensor)  #matrix containing the voxels in which the reconstruction is different than the original

        dummy = torch.numel(noisey_voxels_idx)  #numel counts the number of elements in the matrix "noisey_voxels_idx" 

        if dummy > 0:
            err = err + noisey_voxels_idx.size()[0]

        else:
            print('no error in this example')

    aa = err/tesize

    te_err = aa * 100 / 157464  # 157464 is the total number of voxels in the grid for this specific resolution (54x54x54=157464)
    return te_err


def test_instance_recons_error(model, i, test_data, test_labels, tesize):
    """
    this function is meant to feed the corrupted 3D test data to the network and save the output in binary format
    -- this output can then be read and visualized in matlab.
    -- computes the reconstruction error and the BCE loss for this instance
    """

    # set model to evaluation mode
    model.eval()
    
    #error = reconstructed - original input
    err = 0
    
    test_labels = test_labels.reshape(tesize, 60*60*60)
    model.encoder.__delitem__(0) #remove the dropout layer

    inputs=torch.Tensor(1,1,60,60,60)
    inputs=inputs.cuda()

    input=test_data[i]
    input=input.cuda()
    inputs[0]=input

    perfect_cube=test_labels[i]
    outputs=model.forward(inputs)
    outputs=outputs.float()

    outputs=outputs.cuda()
    
    bin_output = torch.gt(outputs, 0.5)  # gt means >
    bin_output = bin_output.double()
    
    perfect_cube = perfect_cube.double()
    perfect_cube = perfect_cube.cuda()
    noisey_voxels_tensor = torch.ne(bin_output, perfect_cube)
    noisey_voxels_idx = torch.nonzero(noisey_voxels_tensor) 

    dummy = torch.numel(noisey_voxels_idx)

    if dummy > 0:
        err = err + noisey_voxels_idx.size()[0]
        err = (err/157464)*100
    else:
        print('no error in this example')
    
    perfect_cube=perfect_cube.float()
    loss_fn = nn.BCELoss()
    bce=loss_fn(outputs, perfect_cube)
    
    return err, bce, outputs


def save_output(outputs, filename):

    """
    Saves the reconstruction output in a .mat file
    """

    outputs=outputs.reshape(60,60,60)
    outputs=torch.squeeze(outputs)

    dims=outputs.ndimension()

    if dims > 1:
        for i in range(math.floor(dims/2)-1):
            outputs=torch.transpose(outputs, i, dims-i-1)
        outputs=outputs.contiguous()

    outputs=outputs.data    
    outputs=outputs.cpu()
    np_outputs=outputs.numpy()
    np_outputs.astype(float)
    savemat(filename, dict([('output', np_outputs)]))



if __name__ == '__main__':

    args = parser.parse_args()
    i=args.i
    i=int(i)

    # Get the logger
    utils.set_logger(os.path.join(args.model_dir, 'evaluate.log'))

    #Load testing data
    logging.info("Loading the test dataset...")
    test_data, tesize = data_loader.load_data(args.test_data_dir, 'dataset')
    logging.info("Number of testing examples: {}".format(tesize))

    test_labels, tesize_labels = data_loader.load_data(args.test_data_dir, 'labels')

    #initialize the model
    autoencoder = net.VolAutoEncoder()
    autoencoder.cuda()

    #reload weights from the saved file
    utils.load_checkpoint(os.path.join(args.model_dir, 'last.pth.tar'), autoencoder)


    #------test all-----------
    #te_err = test_all(autoencoder, test_data, test_labels, tesize)
    #logging.info("Test AlL: The test error is {} %".format(te_err))


    #------test instance-----------w/ Recons Error and BCE loss
    te_err, bce, outputs=test_instance_recons_error(autoencoder,i,test_data,test_labels,tesize)
    logging.info("Test instance {}: The reconstruction error is {} % and BCE Loss is {}".format(i,te_err,bce))

    filename= './recons'+str(i)
    save_output(outputs,filename)
