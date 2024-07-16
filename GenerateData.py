from tkinter import NO
import numpy as np

def AverageDragCoefficient(fileLocation,velocity,density,diameter):
    try:
        averageTime = 10*(diameter/(velocity))
        averageForce = 0
        timeStep = 0
        with open(fileLocation,'r') as file:
            fileLines = file.readlines()
            fileLines.pop(0)
            fileLines.pop(0)

        for line in fileLines:
            valList = line.split()
            time = float(valList[0])
            force = float(valList[1])
            if(time <= averageTime):
                averageForce += force
                timeStep += 1
            else:
                break
        averageForce /= timeStep
        dragCoefficient = (2*averageForce)/(density*(velocity**2)*diameter)

        return dragCoefficient
    
    except IOError:
        print(f"{fileLocation} not found.")
        return None
    except ValueError:
        print("Error coverting string to float")
        return None
    except ZeroDivisionError:
        print(f"Least value of time in {fileLocation} is greater than average time.")


with open("./Import/ObjectData.txt",'r') as f:
    fileLines = f.readlines()
    fileLines.pop(0)

Reynolds,Mach,Density,Velocity,Diameter = [],[],[],[],[]

for line in fileLines:
    objectDataLine = line.split()
    Reynolds.append(float(objectDataLine[0]))
    Mach.append(float(objectDataLine[1]))
    Density.append(float(objectDataLine[2]))
    Velocity.append(float(objectDataLine[3]))
    Diameter.append(float(objectDataLine[4]))


Data = []
n = 64
for i in range(n):
    dragCoefficient = AverageDragCoefficient(f"./Import/case{i+1}_input.forces.ls1.obj1.dat",Velocity[i],Density[i],Diameter[i])
    Data.append([Reynolds[i],Mach[i],dragCoefficient])

with open("Data.txt",'w') as f:
    f.write("Re Mach DragCoefficient\n")
    for i in range(n):
        f.write(f"{Data[i][0]} {Data[i][1]} {Data[i][2]}\n")


print("Data Generated")











