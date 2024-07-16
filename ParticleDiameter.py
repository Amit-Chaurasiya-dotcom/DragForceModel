import numpy as np

with open('InitialShockData.txt','r') as file:
    fileLines = file.readlines()
    fileLines.pop(0)

machNo,density,velocity = [],[],[]
for line in fileLines:
    valList = line.split()
    machNo.append(float(valList[0]))
    density.append(float(valList[1]))
    velocity.append(float(valList[2]))

n = 8
airViscosity = (1.813)*1e-5
reynoldsNo = np.linspace(400,1100,n)
particleDiameter = []
for j in range(n):
    Re = float(reynoldsNo[j])
    temp = []
    for i in range(n):
        dia = (Re*airViscosity*1e6)/(density[i]*velocity[i])
        temp.append(dia)
    particleDiameter.append(temp)

with open("ObjectData.txt",'w') as f:
    f.write("Re Mach Density Velocity Diameter\n")
    for i in range(n):
        Re = float(reynoldsNo[i])
        for j in range(n):
            f.write(f"{Re} {machNo[j]} {density[j]} {velocity[j]} {particleDiameter[i][j]}\n")
