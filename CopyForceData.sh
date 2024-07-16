#!/bin/bash

copy_force_data(){
    local TotalCases=$1
    for ((i=1;i<=TotalCases;i++))
    do
        cd "Case${i}"
        cp "./RESULTS/input.forces.ls1.obj1.dat" "/home/lhotse_usr1/Desktop/TestCases/Import/case${i}_input.forces.ls1.obj1.dat"
        cd ..
    done
}

copy_force_data 64

echo "All input.forces.ls1.obj1.dat files have been successfully copied."