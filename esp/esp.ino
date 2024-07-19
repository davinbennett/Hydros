#include <ESP8266WiFi.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <WebSocketsClient.h>
#include <ArduinoJson.h>
#include <TimeLib.h>


String serverHost = "192.168.128.149";
int serverPort = 8080;

WebSocketsClient webSocket;

// Data Sending Time
unsigned long previousMillis = 0;
const long interval = 5000;

#define ssid "hard-work"
#define passwordWifi "qwerty12"

#define API_KEY "AIzaSyBfqMvdy6sBZKTbLueiTOg1fB0M2Q83knU"
#define FIREBASE_PROJECT_ID "hydros-firebase-4ac58"
#define USER_EMAIL "user@user.com"
#define USER_PASSWORD "user123"

#define MAX_ALARMS 100  // Maksimum jumlah alarm

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

const long utcOffsetInSeconds = 7 * 3600;

String lastDocumentID = "";

float humidity;
int moisture, temperature;
bool ledGreenOn;

bool clientConnect = false;

String alarmList[MAX_ALARMS];

int numAlarms = 0;

String timeToString(time_t time) {
  char buffer[6];  // hh:mm membutuhkan 5 karakter, ditambah satu untuk null-terminator
  sprintf(buffer, "%02d:%02d", hour(time), minute(time));
  return String(buffer);
}


void webSocketEvent(WStype_t type, uint8_t* payload, size_t length) {
  switch (type) {
    case WStype_DISCONNECTED:
      {
        // Serial.println("Disconnected from WebSocket server");
        clientConnect = false;
        break;
      }

    case WStype_CONNECTED:
      {
        // Serial.println("Connected to WebSocket server");
        clientConnect = true;
        break;
      }

    case WStype_TEXT:
      {
        DynamicJsonDocument jsonDoc(1024);
        deserializeJson(jsonDoc, (char*)payload);

        // Memeriksa apakah pesan JSON memiliki kunci 'alarmsQ'
        if (jsonDoc.containsKey("alarmsQ")) {
          // Reset alarmList menjadi array kosong
          numAlarms = 0;
          JsonArray alarmsArray = jsonDoc["alarmsQ"].as<JsonArray>();

          // Menyimpan nilai waktu alarm yang sudah diubah formatnya
          for (int i = 0; i < alarmsArray.size(); i++) {
            // Mendapatkan nilai timestamp dari Firestore
            unsigned long timestamp = alarmsArray[i]["_seconds"];

            // Ubah timestamp menjadi waktu lokal
            time_t localTime = timestamp + 3600 * 7;

            // Format waktu menjadi string hh:mm
            String formattedTime = timeToString(localTime);

            // Simpan dalam array alarmList
            alarmList[numAlarms] = formattedTime;
            numAlarms++;  // Increment jumlah alarm
          }
        } else {
          int inputSoilStart = jsonDoc["inputSoilStartQ"] | 0;
          int inputSoilEnd = jsonDoc["inputSoilEndQ"] | 0;
          bool switchOn = true;

          // Kirim data ke serial
          String serialData = "/n/" + String(switchOn ? 1 : 0) + ";" + String(inputSoilStart) + ";" + String(inputSoilEnd) + ";";
          Serial.println(serialData);
        }
        break;
      }
    default:
      break;
  }
}

void wifiConnect() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, passwordWifi);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  wifiConnect();

  timeClient.begin();
  timeClient.setTimeOffset(utcOffsetInSeconds);

  webSocket.begin(serverHost, serverPort, "/", "hydros");
  webSocket.onEvent(webSocketEvent);

  webSocket.setReconnectInterval(5000);
}

void getDataFromArduino() {
  // Membaca data dari Arduino hanya jika tersedia dalam satu iterasi
  while (Serial.available() > 0) {
    String receivedData = Serial.readStringUntil('\n');  // Baca data dari Arduino

    // Jika data dikirim oleh Arduino
    if (receivedData.startsWith("/a/")) {
      String data = receivedData.substring(3);
      // Pisahkan data menjadi bagian-bagian
      String values[4];
      int index = 0;
      int separatorIndex = 0;
      while (separatorIndex != -1) {
        separatorIndex = data.indexOf(';');
        if (separatorIndex != -1) {
          values[index] = data.substring(0, separatorIndex);
          data = data.substring(separatorIndex + 1);
          index++;
        }
      }

      // // Proses data
      humidity = values[0].toFloat();
      moisture = values[1].toFloat();
      temperature = values[2].toInt();
      if (values[3].equalsIgnoreCase("1"))
        ledGreenOn = true;
      if (values[3].equalsIgnoreCase("0"))
        ledGreenOn = false;

      // // SEND DATA KE SERVER
      StaticJsonDocument<1001> jsonDoc;
      jsonDoc["humidity"] = humidity;
      jsonDoc["moisture"] = moisture;
      jsonDoc["temperature"] = temperature;
      jsonDoc["ledGreenOn"] = ledGreenOn;

      String jsonString;
      serializeJson(jsonDoc, jsonString);

      webSocket.sendTXT(jsonString);

      // Kirim respons kembali ke Arduino
      // String response = "/e/" + String(humidity);
      // Serial.println(response);
    }
  }
}



void loop() {
  // getDataFromArduino();
  // dapetin DateTime dari NTP
  timeClient.update();
  unsigned long epochTime = timeClient.getEpochTime();
  time_t time_t_epochTime = (time_t)epochTime;
  struct tm* timeinfo;
  timeinfo = localtime(&time_t_epochTime);
  char currentTime[6];
  sprintf(currentTime, "%02d:%02d", timeinfo->tm_hour, timeinfo->tm_min);

  // Pengecekan jika currentTime ada di dalam alarmList
  for (int i = 0; i < numAlarms; i++) {
    if (strcmp(alarmList[i].c_str(), currentTime) == 0) {
      Serial.println("/m/1");

      // Menghapus nilai di alarmList yang sama dengan currentTime
      for (int j = i; j < numAlarms - 1; j++) {
        alarmList[j] = alarmList[j + 1];
      }
      numAlarms--;  // Mengurangi jumlah alarm
      break;
    }
  }


  webSocket.loop();

  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    getDataFromArduino();
  }

  // Serial.print("Connected to ");
  // Serial.println(ssid);
  // Serial.print("IP Address: ");
  // Serial.println(WiFi.localIP());
}
