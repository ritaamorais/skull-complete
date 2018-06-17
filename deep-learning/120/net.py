"""Defines the neural network, losss function and metrics"""

import torch
from torch import nn, optim

class VolAutoEncoder(nn.Module):
    """
       This is the standard way to define your own network in PyTorch. You typically choose the components
       (e.g. LSTMs, linear layers etc.) of your network in the __init__ function.
       You then apply these layers on the input step-by-step in the forward function.
       You can use torch.nn.functional to apply functions such as F.relu, F.sigmoid, F.softmax.
       Be careful to ensure your dimensions are correct after each step.
    """

    def __init__(self):
        super(VolAutoEncoder, self).__init__()

        self.encoder=nn.Sequential(
            nn.Dropout(p=0.5),  # dropout_P=0.5
            nn.Conv3d(1, 64, (9, 9, 9), stride=3),
            nn.ReLU(inplace=True),
            nn.Conv3d(64, 256, (8, 8, 8), stride=4),
            nn.ReLU(inplace=True),
        )

        self.linear = nn.Sequential(
            nn.Linear(186624, 186624),
            nn.ReLU(inplace=True),
            nn.Dropout(p=0.5),  # dropout_P=0.5
        )

        self.decoder = nn.Sequential(
            nn.ConvTranspose3d(256, 64, (5, 5, 5), stride=2),
            nn.ReLU(inplace=True),
            nn.ConvTranspose3d(64, 1, (20, 20, 20), stride=5),
        )

        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        """
        This function defines how we use the components of our network to operate on an input batch.
        """
        encoded = self.encoder(x)
        y = encoded.reshape(186624)
        z = self.linear(y)
        w = z.reshape((256, 9, 9, 9))
        decoded = self.decoder(w)
        r = decoded.reshape(1728000)  # featuresOut=inD*inD*inD=120*120*120=1728000
        out = self.sigmoid(r)

        return out

def loss_fn(outputs, targets):
    """
    Computes the cross entropy loss given outputs and labels
    """
    loss = nn.BCELoss()

    return loss(outputs, targets)

def err(outputs,labels): #denoising error
    return 0

#maintain all metrics required in this dictionary - these are used in the training and evaluation loops
metrics = {
    'err': err,
}