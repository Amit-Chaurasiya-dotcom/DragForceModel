from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import time
import numpy as np

# Configure the webdriver 
driver = webdriver.Chrome()   # type: ignore

# URL of the Gas Dynamics Calculator
url = 'https://silver.neep.wisc.edu/~shock/tools/gdcalc.html'

# Open the website
driver.get(url)

initialPressure = 101325
initialTemperature = 293
n = 8

machNo = np.linspace(3,6.5,n)
density = np.zeros(n)
velocity = np.zeros(n)

# Iterate over the desired Mach numbers
for i in range(0,n):
    # Find the input fields and fill them
    drivenGas = driver.find_element(By.NAME,"drivengas")  
    drivenGasSelector = Select(drivenGas)
    drivenGasSelector.select_by_visible_text("Air")
    
    machInput = driver.find_element(By.NAME,"mach") 
    machInput.clear()
    machInput.send_keys(str(machNo[i]))

    pressureInput = driver.find_element(By.NAME,"pinit") 
    pressureInput.clear()
    pressureInput.send_keys(str(initialPressure))

    temperatureInput = driver.find_element(By.NAME,"tinit") 
    temperatureInput.clear()
    temperatureInput.send_keys(str(initialTemperature))

    # Submit the form
    Calculate = driver.find_element(By.NAME,"convert")   
    Calculate.click()

    # Wait for the results to load
    time.sleep(2)

    # Scrape the result 
    shockedDensity = driver.find_element(By.NAME,"dshocked").get_attribute("value")
    density[i] = float(shockedDensity) # type: ignore

    shockedVelocity = driver.find_element(By.NAME,"ushocked").get_attribute("value")
    velocity[i] = float(shockedVelocity) # type: ignore

# Close the browser
driver.quit()

# Save the results to a file
with open('InitialShockData.txt', 'w') as f:
    f.write("Mach No. Density Velocity\n")
    for i in range(n):
        f.write(f'{machNo[i]} {density[i]} {velocity[i]}\n')
