import numpy as np 
from matplotlib import pyplot as plt 


seq = [10, 50 , 100, 150, 200, 250, 300, 350, 400, 450, 500, 600]
cuda = [10, 50 , 100, 150, 200, 250, 300, 350, 400, 450, 500, 600]

tSeq = np.array([0.00573, 0.07302, 0.30349, 0.72906, 1.18598, 1.79565, 2.89917, 3.58589, 4.92186, 6.24880, 7.65693, 10.17146])

tCuda = np.array([0.34998, 0.63018, 0.41670, 0.44291, 0.42106, 0.45907, 0.49811, 0.69072, 0.81882, 1.05226, 0.93162, 1.19168])

xc = 10*np.array(range(len(cuda)))

plt.plot( seq, tSeq, 'go', color='green') 
plt.plot( cuda, tCuda, 'go', color='red') 

plt.grid(True)
plt.xlabel("Número de linhas e colunas")
plt.ylabel("Tempo (ms)")
plt.show()
