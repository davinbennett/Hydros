import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smartirrigation/controller/home_controller.dart';
import 'package:smartirrigation/controller/save_controller.dart';

class FirestoreController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference device = firestore.collection('Devices');
    return device.snapshots();
  }

  Future<List<String>> getDocumentIDs() async {
    List<String> documentIDs = [];
    try {
      QuerySnapshot<Object?> snapshot =
          await firestore.collection('Devices').get();

      snapshot.docs.forEach((doc) {
        documentIDs.add(doc.id);
      });

      return documentIDs;
    } catch (error) {
      print('Error getting document IDs: $error');
      return [];
    }
  }

  Stream<QuerySnapshot<Object?>> getDataNow(
      String collectionName, String subcollectionName) async* {
    Future<String?> loginID = SaveController.readLogin();
    final documentID = await loginID;

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    Timestamp startOfDayTimestamp =
        Timestamp.fromMillisecondsSinceEpoch(startOfDay.millisecondsSinceEpoch);
    Timestamp endOfDayTimestamp =
        Timestamp.fromMillisecondsSinceEpoch(endOfDay.millisecondsSinceEpoch);

    yield* FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentID)
        .collection(subcollectionName)
        .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
        .where('Date', isLessThan: endOfDayTimestamp)
        .snapshots();
  }

  Future<void> updateSwitchInFirestore(
      String collectionName, String subcollectionName, bool valueSwitch) async {
    try {
      final documentID = await SaveController.readLogin();

      if (documentID != null) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            startOfDay.millisecondsSinceEpoch);
        Timestamp endOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            endOfDay.millisecondsSinceEpoch);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID)
            .collection(subcollectionName)
            .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
            .where('Date', isLessThan: endOfDayTimestamp)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'SwitchOn': valueSwitch});
          });
        });

        print('berhasil diperbarui di Firestore: ${valueSwitch}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat memperbarui: $error');
    }
  }

  Future<void> updateSoilStartInFirestore(String collectionName,
      String subcollectionName, double valueStart) async {
    try {
      final documentID = await SaveController.readLogin();

      if (documentID != null) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            startOfDay.millisecondsSinceEpoch);
        Timestamp endOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            endOfDay.millisecondsSinceEpoch);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID)
            .collection(subcollectionName)
            .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
            .where('Date', isLessThan: endOfDayTimestamp)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'inputSoilStart': valueStart});
          });
        });

        print('berhasil diperbarui di Firestore: ${valueStart}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat memperbarui: $error');
    }
  }

  Future<void> updateSoilEndInFirestore(
      String collectionName, String subcollectionName, double valueEnd) async {
    try {
      final documentID = await SaveController.readLogin();

      if (documentID != null) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            startOfDay.millisecondsSinceEpoch);
        Timestamp endOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            endOfDay.millisecondsSinceEpoch);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID)
            .collection(subcollectionName)
            .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
            .where('Date', isLessThan: endOfDayTimestamp)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'inputSoilEnd': valueEnd});
          });
        });

        print('berhasil diperbarui di Firestore: ${valueEnd}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat memperbarui: $error');
    }
  }

  Future<void> updateCountOn(
      String collectionName, String subcollectionName, int count) async {
    try {
      final documentID = await SaveController.readLogin();

      if (documentID != null) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            startOfDay.millisecondsSinceEpoch);
        Timestamp endOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            endOfDay.millisecondsSinceEpoch);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID)
            .collection(subcollectionName)
            .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
            .where('Date', isLessThan: endOfDayTimestamp)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'countOn': count});
          });
        });

        print('berhasil diperbarui di Firestore: ${count}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat memperbarui: $error');
    }
  }

  Future<void> updatePump(
      String collectionName, String subcollectionName, bool valueSwitch) async {
    try {
      final documentID = await SaveController.readLogin();

      if (documentID != null) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            startOfDay.millisecondsSinceEpoch);
        Timestamp endOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            endOfDay.millisecondsSinceEpoch);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID)
            .collection(subcollectionName)
            .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
            .where('Date', isLessThan: endOfDayTimestamp)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({'SwitchOn': valueSwitch});
          });
        });

        print('berhasil diperbarui di Firestore: ${valueSwitch}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat memperbarui: $error');
    }
  }

  Future<void> addAlarmTimestamp(int hour, int minute) async {
    try {
      final documentID = await SaveController.readLogin();
      if (documentID != null) {
        DateTime now = DateTime.now();

        DateTime dateTime =
            DateTime(now.year, now.month, now.day, hour, minute);

        if (dateTime.isBefore(now)) {
          dateTime = dateTime.add(Duration(days: 1));
        }

        Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
            dateTime.millisecondsSinceEpoch);

        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('Devices').doc(documentID);

        DocumentSnapshot documentSnapshot = await documentReference.get();

        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('Alarm')) {
          List<dynamic> alarms = data['Alarm'] ?? [];
          alarms.add(timestamp);
          await documentReference.update({'Alarm': alarms});
        }
      }
    } catch (error) {
      print(
          'Terjadi kesalahan saat menambahkan timestamp ke array Alarm: $error');
    }
  }

  Future<void> removeAlarmTimestamp(int index) async {
    try {
      final documentID = await SaveController.readLogin();
      if (documentID != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Devices')
            .doc(documentID)
            .get();

        if (snapshot.exists) {
          List<Timestamp> alarms = List<Timestamp>.from(snapshot['Alarm']);
          if (index >= 0 && index < alarms.length) {
            alarms.removeAt(index);
            await snapshot.reference.update({'Alarm': alarms});
          }
        }
      }
    } catch (error) {
      print(
          'Terjadi kesalahan saat menghapus timestamp dari array Alarm: $error');
    }
  }

  Stream<List<Timestamp>> loadAlarmsStream() async* {
    try {
      final documentID = await SaveController.readLogin();
      if (documentID != null) {
        yield* FirebaseFirestore.instance
            .collection('Devices')
            .doc(documentID)
            .snapshots()
            .map((docSnapshot) {
          List<Timestamp> alarms = [];
          if (docSnapshot.exists) {
            alarms = List<Timestamp>.from(docSnapshot['Alarm']);
          }
          return alarms;
        });
      }
      yield [];
    } catch (error) {
      print('Terjadi kesalahan saat memuat data alarm: $error');
      yield [];
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPumpData(
      DateTime selectedDate) async* {
    try {
      final documentID = await SaveController.readLogin();

      DateTime startOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
      DateTime endOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          startOfDay.millisecondsSinceEpoch);
      Timestamp endOfDayTimestamp =
          Timestamp.fromMillisecondsSinceEpoch(endOfDay.millisecondsSinceEpoch);

      var dateTimeSnapshot = await FirebaseFirestore.instance
          .collection('Devices')
          .doc(documentID)
          .collection('DateTime')
          .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
          .where('Date', isLessThan: endOfDayTimestamp)
          .get();

      for (final dateTimeDoc in dateTimeSnapshot.docs) {
        if (dateTimeDoc != null) {
          // Memeriksa apakah dateTimeDoc tidak null
          final pumpRef = dateTimeDoc.reference.collection('Pump');
          final pumpSnapshot = await pumpRef.get();
          if (pumpSnapshot.docs.isNotEmpty) {
            // Memeriksa apakah ada dokumen dalam koleksi 'Pump'
            final firstPumpDoc = pumpSnapshot.docs.first;
            if (firstPumpDoc.data().containsKey('status') &&
                firstPumpDoc.data().containsKey('time')) {
              final pumpStream = pumpRef.snapshots();
              yield* pumpStream;
            }
          }
        }
      }
    } catch (error) {
      print('Terjadi kesalahan saat mengambil data pump: $error');
      yield* Stream.empty();
    }
  }

  Stream<QuerySnapshot<Object?>> getDataSelectedDate(
      DateTime selectedDate) async* {
    try {
      final documentID = await SaveController.readLogin();

      DateTime startOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
      DateTime endOfDay = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

      Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          startOfDay.millisecondsSinceEpoch);
      Timestamp endOfDayTimestamp =
          Timestamp.fromMillisecondsSinceEpoch(endOfDay.millisecondsSinceEpoch);

      yield* FirebaseFirestore.instance
          .collection('Devices')
          .doc(documentID)
          .collection('DateTime')
          .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
          .where('Date', isLessThan: endOfDayTimestamp)
          .snapshots();
    } catch (error) {
      print('Terjadi kesalahan saat mengambil data pump: $error');
      yield* Stream.empty();
    }
  }

  Future<void> addPumpCollection(
      String collectionName, String subcollectionName, bool valueSwitch) async {
    try {
      final documentID = await SaveController.readLogin();

      if (documentID != null) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        Timestamp startOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            startOfDay.millisecondsSinceEpoch);
        Timestamp endOfDayTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            endOfDay.millisecondsSinceEpoch);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID)
            .collection(subcollectionName)
            .where('Date', isGreaterThanOrEqualTo: startOfDayTimestamp)
            .where('Date', isLessThan: endOfDayTimestamp)
            .get()
            .then((QuerySnapshot querySnapshot) {
          var pumpStatusRef =
              querySnapshot.docs[0].reference.collection('Pump');

          String docId = DateTime.now().millisecondsSinceEpoch.toString();

          pumpStatusRef.get().then((snapshot) => {
                if (snapshot.docs.isEmpty && valueSwitch == true)
                  {
                    pumpStatusRef.doc(docId).set({
                      'status': valueSwitch,
                      'time': Timestamp.fromMillisecondsSinceEpoch(
                          now.millisecondsSinceEpoch)
                    }).then((val) => {
                          print(
                              'Collection "Pump" created and initial status added.')
                        })
                  }
              });

          pumpStatusRef
              .orderBy('time', descending: true)
              .limit(1)
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((DocumentSnapshot doc) {
              bool lastStatus = doc.get('status');
              if (lastStatus != valueSwitch) {
                pumpStatusRef.doc(docId).set({
                  'status': valueSwitch,
                  'time': Timestamp.fromMillisecondsSinceEpoch(
                      now.millisecondsSinceEpoch)
                }).then((_) {
                  print(
                      'Perubahan status pompa berhasil ditambahkan ke Firestore.');
                }).catchError((error) {
                  print('Gagal menambahkan perubahan status pompa: $error');
                });
              }
            });
          });
        });

        // print('berhasil diperbarui di Firestore: ${valueSwitch}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat memperbarui: $error');
    }
  }
}
