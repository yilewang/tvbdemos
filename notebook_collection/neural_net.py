#!/bin/usr/python

import torch
from matplotlib import pyplot as plt
from torch import nn
from torch.nn import functional
from torch import optim
import torchvision


def plot_curve(data):
    fig = plt.figure()
    plt.plot(range(len(data)), data, color='blue')
    plt.legend(['value'], loc='upper right')
    plt.xlabel('step')
    plt.ylabel('value')
    plt.show()


def plot_image(img, label, name):
    fig = plt.figure
    for i in range(6):
        plt.subplot(2,3,i+1)
        plt.tight_layout()
        plt.imshow(img[i][0]*0.3081+0.1307, cmap='gray', interpolation='none')
        plt.title("{}:{}".format(name, label[i].item()))
        plt.xticks([])
        plt.yticks([])
    plt.show()

# one_hot can help to make the labels to [0,1,0,0,0] mode, instead of [1], [2], [3]
def one_hot(label, depth=10):
    out = torch.zeros(label.size(0), depth)
    idx = torch.LongTensor(label).view(-1,1)
    out.scatter_(dim=1, index=idx, value=1)
    return out

#step 1. load dataset
batch_size = 512
train_loader = torch.utils.data.DataLoader(
    torchvision.datasets.MNIST('mnist_data', train=True, download=True, transform=torchvision.transforms.Compose([torchvision.transforms.ToTensor(), torchvision.transforms.Normalize((0.1307,), (0.3081,))])), # uniformally distributed around zero, which will improve the training quality
    batch_size=batch_size, shuffle=True
)


test_loader = torch.utils.data.DataLoader(
    torchvision.datasets.MNIST('mnist_data', train=False, download=False, transform=torchvision.transforms.Compose([torchvision.transforms.ToTensor(), torchvision.transforms.Normalize((0.1307,), (0.3081,))])), batch_size=batch_size, shuffle=False
)

x,y = next(iter(train_loader))
# print(x.shape, y.shape)
# plot_image(x, y, 'image sample')


class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        # xw+b layers
        self.fc1 = nn.Linear(28*28, 256)
        self.fc2 = nn.Linear(256, 64)
        self.fc3 = nn.Linear(64, 10)
    
    def forward(self, x):
        # x: [b, 1, 28, 28]
        # h1 = relu(xw+b)
        x = functional.relu(self.fc1(x))
        # h2 = relu(h1w2 + b2)
        x = functional.relu(self.fc2(x))
        # h3 = h2w3+b3
        x = self.fc3(x)
        return x


net = Net()
# [w1, b1, w2, b2, w3, b3]
optimizer = optim.SGD(net.parameters(), lr=0.01, momentum=0.9) # momentum for optimization
train_loss = []
for epoch in range(3):
    for batch_idx, (x,y) in enumerate(train_loader):
        # x:[b, 1, 28, 28] y:[512]
        # [b,1,28,28] -> [b, feature]
        x = x.view(x.size(0), 28*28)
        # -> [b, 10]
        out = net(x)
        # [b,10]
        y_onehot = one_hot(y)

        loss = functional.mse_loss(out, y_onehot)

        optimizer.zero_grad()
        loss.backward()
        # w` = w - lr*grad
        optimizer.step()

        train_loss.append(loss.item())

        # if batch_idx % 10 == 0:
        #     print(epoch, batch_idx, loss.item())


# we get optimal [w1, b1, w2,b2,w3, b3]
# plot_curve(train_loss)

total_correct = 0
for x, y in test_loader:
    x = x.view(x.size(0), 28*28)
    out = net(x)
    # out: [b, 10] => pred:[b]
    pred = out.argmax(dim=1)
    correct = pred.eq(y).sum().float().item()
    total_correct += correct
total_num = len(test_loader.dataset)
acc = total_correct / total_num
print(f'test accuracy is {acc}')


x,y = next(iter(test_loader))
out = net(x.view(x.size(0), 28*28))
pred = out.argmax(dim=1)
plot_image(x, pred, 'test')