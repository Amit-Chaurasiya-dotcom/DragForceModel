function Set-TestCases{
	param(
		[int]$TestCaseNo,
		[double]$Mach,
		[double]$Density,
		[double]$Velocity,
		[double]$Diameter
	)
	
	mkdir "Case$TestCaseNo"
	Set-Location "Case$TestCaseNo"
	Copy-Item /home/lhotse_usr1/SCIMITAR_CASES/SingleParticle/* ./
	make makefolders
	
	(Get-Content -Path ./input.Field.txt) | ForEach-Object {
		if($_ -match "^domain size x\s*="){
			"domain size x                                   =$(20*$Diameter)"
		}
		elseif($_ -match "^domain size y\s*="){
			"domain size y                                   =$(10*$Diameter)"
		}
		elseif($_ -match "^grid spacing dx\s*="){
			"grid spacing dx                                 =$(0.16*$Diameter)"
		}
		elseif($_ -match "^grid spacing dy\s*="){
			"grid spacing dy                                 =$(0.16*$Diameter)"
		}
		elseif($_ -match "^Time step control mode(0=steps/1=time)\s*="){
			"Time step control mode(0=steps/1=time)          =1"
		}
		else{
			$_
		}
	} | Set-Content -Path ./input.Field.txt

	(Get-Content -Path ./input.Material_0.txt) | ForEach-Object{
		if($_ -match "^Mach number\s*="){
			"Mach number                                     =$Mach"
		}
		elseif($_ -match "^Shock location\s*="){
			"Shock location                                  =$(4.25*$Diameter)"
		}
		else{
			$_
		}
		
	} | Set-Content -Path ./input.Material_0.txt

	(Get-Content -Path ./input.Objects.txt) | ForEach-Object{
		if($_ -match "^Center x\s*="){
			"Center x                                        =$(4.25*$Diameter + 0.25 + ($Diameter/2))"
		}
		elseif($_ -match "^Center y\s*="){
			"Center y                                        =$(5*$Diameter)"
		}
		elseif($_ -match "^Radius\s*="){
			"Radius                                          =$($Diameter/2)"
		}
		else{
			$_
		}
		
	} | Set-Content -Path ./input.Objects.txt

	makeE3D		
}

[int] $lineNo = 0
(Get-Content -Path "Import/ObjectData.txt")|ForEach-Object{
	if(lineNo -eq 0){lineNo++}
	else{
		$objectDataLine = -split $_ 
		$Mach = [double]$objectDataLine[1]
		$Density = [double]$objectDataLine[2]
		$Velocity = [double]$objectDataLine[3]
		$Diameter = [double]$objectDataLine[4]	
		
		Set-TestCases -TestCaseNo $lineNo -Mach $Mach -Density $Density -Velocity $Velocity -Diameter $Diameter
			
		$lineNo++
	}
}