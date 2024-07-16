#!/bin/bash

set_test_cases() {
    local TestCaseNo=$1
    local Mach=$2
    local Density=$3
    local Velocity=$4
    local Diameter=$5

    mkdir "Case${TestCaseNo}"
    cd "Case${TestCaseNo}"
    cp /home/lhotse_usr1/SCIMITAR_CASES/SingleParticle/* ./
    mkdir Log
    make makefolders &> "./Log/makefolder.log" && echo "Initialized RESULTS and RESTART directories." || echo "Case:${TestCaseNo} makefolder encountered an error. See makefolder.log for details."

    domain_x=$(echo "scale=4;$Diameter*20" | tr -d $'\r' | bc)
    domain_y=$(echo "scale=4;$Diameter*10" | tr -d $'\r' | bc)
    grid_dx=$(echo "scale=4;$Diameter*0.16" | tr -d $'\r' | bc)
    grid_dy=$(echo "scale=4;$Diameter*0.16" | tr -d $'\r' | bc)
    shock_loc=$(echo "scale=4;$Diameter*4.25" | tr -d $'\r' | bc)
    center_x=$(echo "scale=4;($Diameter*4.25) + 0.25 + ($Diameter / 2)" | tr -d $'\r' | bc)
    center_y=$(echo "scale=4;$Diameter*5" | tr -d $'\r' | bc)
    radius=$(echo "scale=4;$Diameter / 2" | tr -d $'\r' | bc)

    

    sed -i "s/^domain size x\s*=.*/domain size x                                   =$domain_x/" ./input.Field.txt
    sed -i "s/^domain size y\s*=.*/domain size y                                   =$domain_y/" ./input.Field.txt
    sed -i "s/^grid spacing dx\s*=.*/grid spacing dx                                 =$grid_dx/" ./input.Field.txt
    sed -i "s/^grid spacing dy\s*=.*/grid spacing dy                                 =$grid_dy/" ./input.Field.txt
    sed -i "s/^Time step control mode(0=steps\/1=time)\s*=.*/Time step control mode(0=steps\/1=time)          =0/" ./input.Field.txt
    sed -i "s/^interval to compute(INT\/REAL)\s*=.*/interval to compute(INT\/REAL)                   =50/" ./input.Field.txt

    sed -i "s/^Mach number\s*=.*/Mach number                                     =$Mach/" ./input.Material_0.txt
    sed -i "s/^Shock location\s*=.*/Shock location                                  =$shock_loc/" ./input.Material_0.txt

    sed -i "s/^Center x\s*=.*/Center x                                        =$center_x/" ./input.Objects.txt
    sed -i "s/^Center y\s*=.*/Center y                                        =$center_y/" ./input.Objects.txt
    sed -i "s/^Radius\s*=.*/Radius                                          =$radius/" ./input.Objects.txt

    make E3D &> "./Log/E3D.log" && echo "E3D executed" || echo "Case${TestCaseNo}: E3D encountered an error. See E3D.log for details."
    
    cd ..

}
declare -a ObjectDataArray

while IFS= read -r line; 
do
    ObjectDataArray+=("$line")
done < "ObjectData.txt"

len=${#ObjectDataArray[@]}
for ((i=0; i<len; i++));
do
    if [ $i -eq 0 ]; then
        continue
    fi

    ObjectDataLine=(${ObjectDataArray[i]})

    Re=${ObjectDataLine[0]}
    Mach=${ObjectDataLine[1]}
    Density=${ObjectDataLine[2]}
    Velocity=${ObjectDataLine[3]}
    Diameter=${ObjectDataLine[4]}

    echo "Case:$i Mach:$Mach Reynolds:$Re Particle size:$Diameter"
    
    set_test_cases $i $Mach $Density $Velocity $Diameter

done 
