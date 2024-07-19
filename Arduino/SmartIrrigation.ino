#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <DHT.h>
LiquidCrystal_I2C lcd(0x27, 16, 2);
#include <SoftwareSerial.h>
SoftwareSerial espCom(2, 3);

#define soil A2
#define relay 7
#define relayON 1
#define relayOFF 0
#define ledRed 9
#define ledGreen 4
#define buttonRed 6
#define buttonGreen 5
#define dhtPin 8
#define dhtType DHT11
DHT dht(dhtPin, dhtType);

bool ledGreenOn = false;
bool ledRedOn = true;


int switchOnValue = 0;

float soilStart = 0.0, soilEnd = 0.0, mean = 0.0;

String dateTime;

enum DisplayState {
  INITIAL,
  HUMIDITY_TEMP,
  SOIL_MOISTURE
};

DisplayState currentState = DisplayState::INITIAL;

unsigned long previousDisplayMillis = 0;
const long displayInterval = 4000;

void setup() {
  Serial.begin(9600);
  espCom.begin(115200);
  dht.begin();
  lcd.init();
  lcd.backlight();
  pinMode(soil, INPUT);
  pinMode(relay, OUTPUT);
  pinMode(ledRed, OUTPUT);
  pinMode(ledGreen, OUTPUT);
  pinMode(buttonRed, INPUT_PULLUP);
  pinMode(buttonGreen, INPUT_PULLUP);

  // init awal
  digitalWrite(relay, relayOFF);
  digitalWrite(ledRed, HIGH);
  digitalWrite(ledGreen, LOW);
}

void loop() {
  int rBtnRed = digitalRead(buttonRed);
  int rBtnGreen = digitalRead(buttonGreen);
  float humidity, moisture, temperature, moisturePercent;
  if (millis() - previousDisplayMillis >= displayInterval) {
    humidity = dht.readHumidity();
    moisture = analogRead(soil);
    temperature = dht.readTemperature();

    moisturePercent = map(moisture, 284, 568, 100, 0);
    if (moisturePercent < 0) {
      moisturePercent = 0;
    } else if (moisturePercent > 100) {
      moisturePercent = 100;
    }

    switch (currentState) {
      case DisplayState::INITIAL:
        lcd.clear();
        lcd.setCursor(5, 0);
        lcd.print("Smart");
        lcd.setCursor(3, 1);
        lcd.print("Irrigation");
        currentState = DisplayState::HUMIDITY_TEMP;
        break;

      case DisplayState::HUMIDITY_TEMP:
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Humidity: " + String(humidity, 1) + " %");
        lcd.setCursor(0, 1);
        lcd.print("Temperature: " + String(temperature, 0) + "C");
        currentState = DisplayState::SOIL_MOISTURE;
        break;

      case DisplayState::SOIL_MOISTURE:
        lcd.clear();
        lcd.setCursor(2, 0);
        lcd.print("Soil: " + String(moisturePercent) + " %");
        currentState = DisplayState::INITIAL;
        break;
    }

    previousDisplayMillis = millis();  // Update time after display update
  }
// 
  // Button handling for LED and relay control
  if (rBtnRed == 0 || moisturePercent >= mean) {
    ledGreenOn = false;
    ledRedOn = true;
  }
  

  if (rBtnGreen == 0) {
    ledGreenOn = true;
    ledRedOn = false;
  }

  // Relay and LED control based on LED state
  if (ledRedOn ) {
    digitalWrite(relay, relayOFF);
    digitalWrite(ledRed, HIGH);
    digitalWrite(ledGreen, LOW);
  }

  if (ledGreenOn) {
    digitalWrite(relay, relayON);
    digitalWrite(ledRed, LOW);
    digitalWrite(ledGreen, HIGH);
  }

  // SEND DATA KE ESP
  String dataToSend = "/a/" + String(humidity) + ";" + String(moisturePercent) + ";" + String(temperature) + ";" + String(ledGreenOn) + ";";
  espCom.println(dataToSend);

  // Data dari ESP8266
  if (espCom.available()) {                              // Periksa apakah ada data yang tersedia dari ESP8266
    String receivedData = espCom.readStringUntil('\n');  // Baca data dari ESP8266

    // terima data alarm
    if (receivedData.startsWith("/m/")) {

      String data = receivedData.substring(3);  // Hapus penanda dari data

      if (data.toInt() == 1) {
        ledGreenOn = true;
        ledRedOn = false;
      }
    } else if( receivedData.startsWith("/n/") ){
        String data = receivedData.substring(3);  // Hapus penanda dari data
        // Pisahkan data menjadi bagian-bagian terpisah
        int separatorIndex = data.indexOf(';');
        String switchOn = data.substring(0, separatorIndex);
        data = data.substring(separatorIndex + 1);
        separatorIndex = data.indexOf(';');
        String inputSoilStart = data.substring(0, separatorIndex);
        String inputSoilEnd = data.substring(separatorIndex + 1);

        // Konversi string
        switchOnValue = switchOn.toInt();
        float inputSoilStartValue = inputSoilStart.toFloat();
        float inputSoilEndValue = inputSoilEnd.toFloat();

        // if(switchOnValue == 1){
        //   ledGreenOn = true;
        //   ledRedOn = false;
        // }
        // else if(switchOnValue == 0){
        //   ledGreenOn = false;
        //   ledRedOn = true;
        // }

        soilStart = inputSoilStartValue;

        soilEnd = inputSoilEndValue;

        mean = (soilEnd - soilStart) / 2;

        if(moisturePercent < soilStart){
          ledGreenOn = true;
          ledRedOn = false;
        }

        if(moisturePercent >= soilStart){
          ledGreenOn = false;
          ledRedOn = true;
        }

      }
  }

  delay(5000);
}