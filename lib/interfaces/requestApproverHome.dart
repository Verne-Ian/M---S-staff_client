import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RequestApproving extends StatefulWidget {
  const RequestApproving({super.key});

  @override
  State<RequestApproving> createState() => _RequestApprovingState();
}

class _RequestApprovingState extends State<RequestApproving> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ListTile(
          title: const Text('Appointments'),
          subtitle: const Text('Manage Appointments'),
          onTap: () => Navigator.pushNamed(context, '/allAppointments'),
        ),
        ListTile(
          title: const Text('Ambulance'),
          subtitle: const Text('Manage Ambulance Requests'),
          onTap: () => Navigator.pushNamed(context, '/ambieRequests'),
        )
      ],
    ));
  }
}
