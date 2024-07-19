const express = require("express");
const admin = require("firebase-admin");
const http = require("http");
const app = express();
const server = http.createServer(app);
const WebSocket = require("ws");


app.use(express.json());

const wss = new WebSocket.Server({ server: server });

const serviceAccount = require("./key.json");
admin.initializeApp({
   credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

wss.on("connection", (ws) => {
   console.log("Client connected");

   let prevLedGreenOn = null; // Variabel untuk menyimpan data ledGreenOn sebelumnya

   // mengirim data ke klien WebSocket
   const sendDataToClient = (data) => {
      if (ws.readyState === WebSocket.OPEN) {
         console.log("data json: " + JSON.stringify(data));
         ws.send(JSON.stringify(data));
      }
   };

   // mengambil data dari Firestore
   const fetchDataFromFirestore = () => {
      const todayQ = new Date();
      todayQ.setHours(todayQ.getHours() + 7);
      const currentDateQ = todayQ.toISOString().split("T")[0];

      const docPathP = "Devices/Zcwv49VGsDc6RdCq4l5N";
      const docRefP = db.doc(docPathP);

      const docPathQ = `Devices/Zcwv49VGsDc6RdCq4l5N/DateTime/${currentDateQ}`;
      const docRefQ = db.doc(docPathQ);

      // Mengambil data alarms saat aplikasi dimulai
      docRefP.get().then((docSnapshotP) => {
         if (docSnapshotP.exists) {
            const dataP = docSnapshotP.data();
            const alarmsQ = dataP.Alarm || [];
            console.log("Initial Alarm Data:", alarmsQ);

            // Kirim data ke ESP melalui WebSocket
            sendDataToClient({ alarmsQ });
         } else {
            console.log("Dokumen tidak ditemukan:", docPathP);
         }
      });

      // Memperbarui data alarms ketika terjadi perubahan
      docRefP.onSnapshot((docSnapshotP) => {
         if (docSnapshotP.exists) {
            const dataP = docSnapshotP.data();
            const alarmsQ = dataP.Alarm || [];
            console.log("Updated Alarm Data:", alarmsQ);

            // Kirim data ke ESP melalui WebSocket
            sendDataToClient({ alarmsQ });
         }
      });

      docRefQ.onSnapshot((docSnapshot) => {
         if (docSnapshot.exists) {
            const dataQ = docSnapshot.data();
            const switchOnQ = 1;
            const inputSoilEndQ = dataQ.inputSoilEnd;
            const inputSoilStartQ = dataQ.inputSoilStart;

            console.log("Data dari Firestore:", {
               switchOnQ,
               inputSoilEndQ,
               inputSoilStartQ,
            });

            // Kirim data ke ESP melalui WebSocket
            sendDataToClient({ switchOnQ, inputSoilEndQ, inputSoilStartQ });
         } else {
            console.log(
               "Dokumen tidak ditemukan untuk hari ini:",
               currentDateQ
            );
         }
      });
   };

   // untuk mengambil data dari Firestore saat klien terhubung
   fetchDataFromFirestore();

   ws.on("message", (message) => {
      const data = JSON.parse(message);
      console.log(
         "\n===============================================================\n\nData from ESP:",
         data
      );

      const humidity = parseFloat(data.humidity);
      const moisture = parseFloat(data.moisture);
      const temperature = parseInt(data.temperature);
      const ledGreenOn = data.ledGreenOn === true;

      const today = new Date();
      today.setHours(today.getHours() + 7);
      console.log(today);

      // Format tanggal sesuai dengan format yang diinginkan
      const currentDate = today.toISOString().split("T")[0];

      const docPath = `Devices/Zcwv49VGsDc6RdCq4l5N/DateTime/${currentDate}`;

      // Mengecek apakah dokumen sudah ada atau belum
      const docRef = db.doc(docPath);

      docRef.get().then((docSnapshot) => {
         if (docSnapshot.exists) {
            const switchOnInFirestore = docSnapshot.data().SwitchOn;
            console.log("\nDokumen sudah ada untuk hari ini:", currentDate);

            // Dapatkan data dari dokumen
            const docData = docSnapshot.data();

            // Periksa jika nilai yang ingin dimasukkan sama dengan nilai sebelumnya di array
            const lastHumidity = docData.Humidity[docData.Humidity.length - 1];
            const lastSoil = docData.Soil[docData.Soil.length - 1];
            const lastTemperature =
               docData.Temperature[docData.Temperature.length - 1];

            if (humidity !== lastHumidity) {
               docData.Humidity.push(humidity);
            }
            if (moisture !== lastSoil) {
               docData.Soil.push(moisture);
            }
            if (temperature !== lastTemperature) {
               docData.Temperature.push(temperature);
            }

            // Memperbarui nilai SwitchOn berdasarkan ledGreenOn yang diterima
            docRef
               .update({
                  Humidity: docData.Humidity,
                  Soil: docData.Soil,
                  Temperature: docData.Temperature,
               })
               .then(() => {
                  if (prevLedGreenOn == null) {
                     prevLedGreenOn = switchOnInFirestore;
                  }
                  
                  if (
                     prevLedGreenOn !== ledGreenOn &&
                     ledGreenOn !== switchOnInFirestore
                  ) {
                     docRef.update({ SwitchOn: ledGreenOn });
                     prevLedGreenOn = ledGreenOn;
                     console.log("\nNilai SwitchOn berhasil diperbarui.");
                  }

                  // Dapatkan waktu saat ini
                  const currentTime = new Date();

                  // Buat ID dokumen baru dengan waktu sebagai bagian dari ID
                  const docId = currentTime.getTime().toString();

                  const pumpStatusRef = docRef.collection("Pump");

                  pumpStatusRef
                     .get()
                     .then((snapshot) => {
                        if (snapshot.empty && ledGreenOn == true) {
                           pumpStatusRef
                              .doc(docId)
                              .set({
                                 status: ledGreenOn,
                                 time: admin.firestore.Timestamp.fromDate(
                                    new Date()
                                 ),
                              })
                              .then(() => {
                                 console.log(
                                    "Collection 'Pump' created and initial status added."
                                 );
                                 if (ledGreenOn) {
                                    docRef
                                       .update({
                                          countOn:
                                             admin.firestore.FieldValue.increment(
                                                1
                                             ),
                                       })
                                       .then(() => {
                                          console.log(
                                             "\nNilai countOn berhasil ditambahkan."
                                          );
                                       })
                                       .catch((error) => {
                                          console.error(
                                             "\nGagal menambahkan nilai countOn:",
                                             error
                                          );
                                       });
                                 }
                              })
                              .catch((error) => {
                                 console.error(
                                    "Error creating 'Pump' collection:",
                                    error
                                 );
                              });
                        }
                     })
                     .catch((error) => {
                        console.error(
                           "Error checking 'Pump' collection:",
                           error
                        );
                     });

                  pumpStatusRef
                     .orderBy("time", "desc")
                     .limit(1)
                     .get()
                     .then((querySnapshot) => {
                        querySnapshot.forEach((doc) => {
                           const lastStatus = doc.data().status;
                           if (lastStatus !== ledGreenOn) {
                              pumpStatusRef
                                 .doc(docId)
                                 .set({
                                    status: ledGreenOn,
                                    time: admin.firestore.Timestamp.fromDate(
                                       new Date()
                                    ),
                                 })
                                 .then(() => {
                                    console.log(
                                       "\nPerubahan status pompa berhasil ditambahkan ke Firestore."
                                    );

                                    // Jika ledGreenOn true, tambahkan nilai countOn
                                    if (ledGreenOn) {
                                       docRef
                                          .update({
                                             countOn:
                                                admin.firestore.FieldValue.increment(
                                                   1
                                                ),
                                          })
                                          .then(() => {
                                             console.log(
                                                "\nNilai countOn berhasil ditambahkan."
                                             );
                                          })
                                          .catch((error) => {
                                             console.error(
                                                "\nGagal menambahkan nilai countOn:",
                                                error
                                             );
                                          });
                                    }
                                 })
                                 .catch((error) => {
                                    console.error(
                                       "\nGagal menambahkan perubahan status pompa:",
                                       error
                                    );
                                 });
                           }
                        });
                     });
               })
               .catch((error) => {
                  console.error("\nGagal memperbarui nilai SwitchOn:", error);
               });
         } else {
            // Membuat dokumen baru dengan field "Date" berisi tanggal saat ini
            docRef
               .set({
                  Date: admin.firestore.Timestamp.fromDate(today),
                  Humidity: [humidity],
                  Soil: [moisture],
                  SwitchOn: ledGreenOn,
                  Temperature: [temperature],
                  countOn: 0,
                  inputSoilEnd: 100,
                  inputSoilStart: 90,
               })
               .then(() => {
                  console.log(
                     "\nDokumen berhasil dibuat untuk hari ini:",
                     currentDate
                  );
               })
               .catch((error) => {
                  console.error("\nGagal membuat dokumen:", error);
               });
         }
      });
   });

   ws.on("close", () => {
      console.log("\nClient disconnected");
   });
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
   console.log(`Server is running on http://localhost:${PORT}`);
});
