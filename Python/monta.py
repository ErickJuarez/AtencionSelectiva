import cv2
import math
import kmeans
import numpy as np
import matcompat
from scipy import signal
import matplotlib.pyplot as plt

def monta(imagen):

	ret,imagen = cv2.threshold(imagen,0,255,cv2.THRESH_BINARY)
	imagen = np.float32(imagen)
	P = np.argwhere(imagen>=1)
	[x, y] = matcompat.size(imagen)
	M = np.zeros((x,y))
	F = np.arange(0, (x)+(10), 10)
	C= np.arange(0, (y)+(10), 10)
	M2 = np.zeros((np.size(F),np.size(C)))
	alpha = 1.5
	beta = .01
	delta = 1
	suma = 0
	for x in range(len(F)):
		for y in range(len(C)):
			for z in range(P.shape[1]):
				d=math.sqrt((P[0,z]-F[x])**2+(P[0,z]-C[y])**2)
				m=math.exp(-alpha*d)
				M[x,y]=suma+m
				suma=M[x,y]
			suma=0
	k=1
	delta=np.zeros(k)
	c=np.zeros(k)
	mc=0
	pf = np.zeros(k)
	pc = np.zeros(k)
	delta[0]=1
	while delta.any()<15:
		M=np.amax(M,axis=0)
		c[k-1]=M.max().max()

#		for x in range(len(F)):
#			for y in range(len(C)):
#
#				if M[x,y] == c[k-1]:
#					pf[k-1]=x
#					pc[k-1]=y
#		for x in range(len(F)):
#			for y in range(len(C)):
#				for z in range(k):
#					dc = math.sqrt((F[0,int(pf[k-1])]-F[0,x])**2+(C[0,int(pc[k-1])]-C[0,y])**2)
#					mc = mc + math.exp(-beta*dc)
#				M2[x,y]=M[x,y]-M[int(pf[k-1]),int(pc[k-1])]*mc
#				mc=0
#		k=k+1
#		c2 = M2.max().max()
#		delta[k-2]=abs(c[k-2]/c2)
#		M = M2
	#u=kmeans.kmeansS(P,(pf-2)*10,(pc-2)*10)
	return 0,0