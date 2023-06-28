import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecepAppoint extends StatefulWidget {
  const RecepAppoint({super.key});

  @override
  State<RecepAppoint> createState() => _RecepAppointState();
}

class _RecepAppointState extends State<RecepAppoint> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> cancel(String docId) async {
    try {
      await firestore
          .collection('appointments')
          .doc(docId)
          .delete()
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment canceled.'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel appointment request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('appointments')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final appointments = snapshot.data!.docs;
              if (appointments.isNotEmpty) {
                // User has pending or ongoing requests
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment =
                        appointments[index].data() as Map<String, dynamic>;
                    final status = appointment['status'] ?? '';
                    final name = appointment['name'] ?? '';
                    final date = appointment['date'] ?? '';
                    final time = appointment['time'] ?? '';
                    final service = appointment['service'] ?? '';
                    final docId = appointments[index].id;

                    return Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Appointment Request: $status'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: $name'),
                                  Text('Date: $date'),
                                  Text('Time: $time'),
                                  Text('Service: $service'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Cancel button action
                                  cancel(docId);
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [Text('No Appointments Yet')],
            );
          },
        ),
      ),
    );
  }
}
