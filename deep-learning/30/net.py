"""Defines the neural network and the loss function"""


import torch
from torch import nn, optim

class VolAutoEncoder(nn.Module):
    """
       This is the standard way to define a network in PyTorch. The components
       (layers) of the network are defined in the __init__ function.
       Then, in the forward function it is defined how to apply these layers on the input step-by-step.
    """

    def __init__(self):
        super(VolAutoEncoder, self).__init__()

        self.encoder=nn.Sequential(
            nn.Dropout(p=0.5),  # dropout_P=0.5
            nn.Conv3d(1, 64, (9, 9, 9), stride=3),
            nn.ReLU(inplace=True),
            nn.Conv3d(64, 256, (4, 4, 4), stride=2),
            nn.ReLU(inplace=True),
        )

        self.linear = nn.Sequential(
            nn.Linear(6912, 6912),
            nn.ReLU(inplace=True),
            nn.Dropout(p=0.5),  # dropout_P=0.5
        )

        self.decoder = nn.Sequential(
            nn.ConvTranspose3d(256, 64, (5, 5, 5), stride=2),
            nn.ReLU(inplace=True),
            nn.ConvTranspose3d(64, 1, (6, 6, 6), stride=3),
        )

        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        """
        This function defines how to use the components of the network to operate on an input batch.
        """
        x = self.encoder(x)
        x = x.view(6912)
        x = self.linear(x)
        x = x.view((256, 3, 3, 3))
        x=x.unsqueeze(0)
        x = self.decoder(x)
        x = x.view(27000)  #30*30*30=27000
        x = self.sigmoid(x)

        return x

def loss_fn(outputs, targets):
    """
    Computes the cross entropy loss given outputs and labels
    """
    loss = nn.BCELoss()

    return loss(outputs, targets)