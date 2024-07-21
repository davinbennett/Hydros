# Hydros

Hydros is an automatic drip irrigation tool based on IoT. Through its board, the pump can be turned on and off, and humidity, air temperature, and soil temperature can be monitored. Through a mobile device, sensor results can be viewed, the pump's activation can be set according to the desired soil moisture, an alarm can be set to schedule the pump activation, and history can be displayed.

### How it works:
1. For every purchase of this device, users will pair the application with the device to establish a connection. Pairing can be done by entering a shared unique code or scanning a QR code.
2. Soil moisture sensors are placed in each pot.
3. Data from the sensors is received by an Arduino, then the data is displayed on the application (Sensors -> Arduino -> ESP -> Server -> Firestore -> App).
4. Users set the minimum soil moisture through the application.
5. If the soil moisture is less than the user-set level, the pump will turn on until the soil moisture exceeds the input level.

### Features:
1. Display sensor data on LCD and application
2. Turn the device on and off through the board
3. Alarm to schedule pump activation time
4. Users can select a date to display history according to the chosen date

### Components:
1. Arduino UNO R3 Built-in wifi
2. NodeJs + ExpressJs
3. WebSocket
4. Soil Moisture V1.2
5. DHT11
6. Firestore
7. Flutter

### Photo of the equipment:
1. [Photo 1](Documentation/Brida-HariLahirPancasila/290186_0.jpg)

### Photo of the application:
1. [Photo 1](Documentation/290200_0.jpg)
2. [Photo 2](Documentation/290195_0.jpg)
3. [Photo 3](Documentation/290196_0.jpg)
4. [Photo 4](Documentation/290197_0.jpg)
5. [Photo 5](Documentation/290198_0.jpg)
6. [Etc](Documentation)
