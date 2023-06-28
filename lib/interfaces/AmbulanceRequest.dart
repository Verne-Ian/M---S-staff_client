import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AmbRequets extends StatefulWidget {
  const AmbRequets({super.key});

  @override
  State<AmbRequets> createState() => _AmbRequetsState();
}

class _AmbRequetsState extends State<AmbRequets> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> update(String docId) async {
    try {
      await firestore
          .collection('ambulance_requests')
          .doc(docId)
          .update({'status': 'Ongoing'}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ambulance request ongoing.'),
            backgroundColor: Colors.blue,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> cancel(String docId) async {
    try {
      await firestore
          .collection('ambulance_requests')
          .doc(docId)
          .delete()
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ambulance request canceled.'),
            backgroundColor: Colors.blue,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambulance Requests'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('ambulance_requests')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final requests = snapshot.data!.docs;
              if (requests.isNotEmpty) {
                // User has pending or ongoing requests
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request =
                        requests[index].data() as Map<String, dynamic>;
                    final status = request['status'] ?? '';
                    final location = request['location'] ?? '';
                    final contact = request['contact'] ?? '';
                    final patientName = request['name'] ?? '';
                    final docId = requests[index].id;

                    return Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Patient: $patientName'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Status: $status'),
                                  Text('Location: $location'),
                                  Text('Contact: $contact'),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                status == 'Ongoing'
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) {
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return Colors.grey;
                                                }
                                                return Colors.grey;
                                              }),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)))),
                                          onPressed: null,
                                          child: const Text('Approve'),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Cancel button action
                                            update(docId);
                                          },
                                          child: const Text('Approve'),
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
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Column();
          },
        ),
      ),
    );
  }
}
