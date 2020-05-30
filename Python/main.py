import cv2
import math
import monta
import numpy as np
import matcompat
from scipy import signal
import matplotlib.pyplot as plt

lammbda=6
pi = math.pi
theta = np.arange(0, (np.pi-np.pi/8)+(np.pi/8), np.pi/8)
psi = 0
gamma = np.linspace(.4,1,4)
gamma = np.arange(.4, 1.2, .2)
b = 4
sigma = (1/pi)*math.sqrt((math.log(2)/2))*((2**b+1)/(2**b-1))*lammbda
l = int(12/2)
gt = 0
imagen0 = np.float32(cv2.imread('images/NegroyYo4.jpg'))
imagen0 = cv2.cvtColor(imagen0,cv2.COLOR_BGR2RGB)
imagen0 = cv2.resize(imagen0, (320, 240))
imagen1 = (imagen0-128)/127
imagen = np.zeros((240,320,4))
imagen[:,:,0]=(imagen1[:,:,0]-imagen1[:,:,1])/2
imagen[:,:,1]=(imagen1[:,:,0]+imagen1[:,:,1]-2*imagen1[:,:,2])/4
imagen[:,:,2]=(imagen1[:,:,0]+imagen1[:,:,1]+imagen1[:,:,2])/3
s = matcompat.size(imagen0)
for i in np.arange(1., (s[0])+1):
    for j in np.arange(1., (s[1])+1):
        imagen[int(i)-1,int(j)-1,3] = ((imagen1[int(i)-1,int(j)-1,:]).max()-(imagen1[int(i)-1,int(j)-1,:]).min())/2
contador = 0
g = np.zeros((13,13))
imagenSalida=np.zeros((240,320,4,32))
for i in range(len(theta)):
	for f in range(len(gamma)):
		for j in range(-l,l+1):
			for k in range(-l,l+1):
				x = j*math.cos(theta[i])+k*math.sin(theta[i])
				y = k*math.cos(theta[i])-j*math.sin(theta[i])
				g[j+l,k+l]=math.exp(-(x**2 + (gamma[f]**2)*(y**2))/(2*sigma**2))*math.cos((2*pi*x/lammbda)+psi)
		imagenSalida[:,:,0,contador] = signal.convolve2d(imagen[:,:,0], g,  boundary='symm', mode='same')
		imagenSalida[:,:,1,contador] = signal.convolve2d(imagen[:,:,1], g,  boundary='symm', mode='same')
		imagenSalida[:,:,2,contador] = signal.convolve2d(imagen[:,:,2], g,  boundary='symm', mode='same')
		imagenSalida[:,:,3,contador] = signal.convolve2d(imagen[:,:,3], g,  boundary='symm', mode='same')
		contador = contador + 1
s = matcompat.size(imagenSalida)
FM = np.zeros(s)
area = []
for i in range(s[3]):
	alpha = .6
	m1 = alpha*imagenSalida[:,:,0,k].max().max()
	m2 = alpha*imagenSalida[:,:,1,k].max().max()
	m3 = alpha*imagenSalida[:,:,2,k].max().max()
	m4 = alpha*imagenSalida[:,:,3,k].max().max()
	for i in range(s[0]):
		for j in range(s[1]):
			if imagenSalida[i,j,0,k]>m1:
				FM[i,j,0,k] = 1
			if imagenSalida[i,j,1,k]>m2:
				FM[i,j,1,k]=1
			if imagenSalida[i,j,2,k]>m3:
				FM[i,j,2,k]=1
			if imagenSalida[i,j,3,k]>m4:
				FM[i,j,3,k]=1
	[area,num] = monta.monta(FM[:,:,0,k])

cv2.imshow("input",  imagen)
cv2.waitKey(0)
cv2.destroyAllWindows()


#theta = [round(float(i)/10000000,4) for i in range(0,int((pi-pi/8)*10000000),int((pi/8)*10000000))]
#gamma = [float(i)/10 for i in range(4,11,2)]