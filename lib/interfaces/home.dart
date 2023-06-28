import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m_n_s_staff_client/addons/drawer.dart';

import 'OldAppointments.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String? name = user!.displayName;
  late String? userId = user!.uid;
  late String? role;
  String appBar = '';

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const MainSideBar(),
      appBar: AppBar(
        title: const Text('Hello, welcome to the staff portal.'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.02, h * 0.04, w * 0.02, h * 0.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Staff_Users')
              .where('UserId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          w * 0.05, h * 0.01, w * 0.05, h * 0.0),
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(h * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Opening your DashBoard'),
                              const SizedBox(
                                width: 15.0,
                              ),
                              SpinKitDualRing(
                                color: Colors.green.shade600,
                                size: 25.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          w * 0.05, h * 0.01, w * 0.05, h * 0.0),
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(h * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Connecting'),
                              const SizedBox(
                                width: 15.0,
                              ),
                              SpinKitPianoWave(
                                color: Colors.green.shade600,
                                size: 25.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            }

            var redirectData =
                snapshot.data!.docs[0].data() as Map<String, dynamic>;
            var role = redirectData['Role'];

            switch (role) {
              case 'Doctor': //Case for when a doctor logs in
                appBar = 'Hello Dr.${user!.displayName}';
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OldAppoint(where: 'Doctor')));
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/schedule.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('My Appointments'),
                            subtitle: const Text('Manage Appointments'),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OldAppoint(where: 'Doctor'))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/docHome');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/patient.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Patient Interactions'),
                            onTap: () =>
                                Navigator.pushNamed(context, '/docHome'),
                          ),
                        ),
                      ],
                    )
                  ],
                );

              case 'Receptionist': //Case for when the receptionist log's in
                appBar = 'Hello ${user!.displayName}';
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/allAppointments');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/schedule.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Appointments'),
                            subtitle: const Text('Manage Appointments'),
                            onTap: () => Navigator.pushNamed(
                                context, '/allAppointments'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/ambieRequests');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/ambulance.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Ambulance'),
                            subtitle: const Text('Manage Ambulance Requests'),
                            onTap: () =>
                                Navigator.pushNamed(context, '/ambieRequests'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              case 'Physician': //Case for when the receptionist log's in

                appBar = 'Hello Dr.${user!.displayName}';
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OldAppoint(where: 'Physician')));
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/schedule.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('My Appointments'),
                            subtitle: const Text('Manage Appointments'),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OldAppoint(where: 'Physician'))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/docHome');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/patient.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Patient Interactions'),
                            onTap: () =>
                                Navigator.pushNamed(context, '/docHome'),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              case 'Dentist': //Case for when the receptionist log's in

                appBar = 'Hello Dr.${user!.displayName}';
                return Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OldAppoint(where: 'Dentist')));
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/schedule.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('My Appointments'),
                            subtitle: const Text('Manage Appointments'),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OldAppoint(where: 'Dentist'))),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/docHome');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/patient.png'),
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Patient Interactions'),
                            onTap: () =>
                                Navigator.pushNamed(context, '/docHome'),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              default:
                // Handle unknown role or other cases
                return const SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/allStaff');
        },
        tooltip: 'Chat with Staff',
        child: const Icon(Icons.chat_bubble_outline_sharp),
      ),
    );
  }
}
