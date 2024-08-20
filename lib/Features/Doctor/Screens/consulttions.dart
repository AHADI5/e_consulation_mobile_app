import 'package:flutter/material.dart';
import 'package:doctor_app/Features/Patient/drawer_menu.dart';

class Consultation {
  final int id;
  final String patientName;
  final DateTime consultationDate;
  final String notes;

  Consultation({
    required this.id,
    required this.patientName,
    required this.consultationDate,
    required this.notes,
  });
}

class DoctorConsultationsPage extends StatelessWidget {
  final List<Consultation> consultations = [
    Consultation(
      id: 1,
      patientName: 'Alice Johnson',
      consultationDate: DateTime.now().subtract(Duration(days: 3)),
      notes: 'Patient is recovering well, follow-up in 2 weeks.',
    ),
    Consultation(
      id: 2,
      patientName: 'Bob Williams',
      consultationDate: DateTime.now().subtract(Duration(days: 1)),
      notes: 'Patient needs additional tests, schedule a follow-up.',
    ),
    // Add more consultations as needed
  ];

  DoctorConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations Terminées'),
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: consultations.length,
        itemBuilder: (context, index) {
          return _buildConsultationTile(context, consultations[index]);
        },
      ),
    );
  }

  Widget _buildConsultationTile(BuildContext context, Consultation consultation) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: ${consultation.patientName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text('Date: ${consultation.consultationDate}'),
            const SizedBox(height: 8.0),
            Text('Notes:'),
            const SizedBox(height: 4.0),
            Text(consultation.notes),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _updateNotes(context, consultation);
                  },
                  child: const Text('Modifier les Notes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateNotes(BuildContext context, Consultation consultation) {
    // Implement note update logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _notesController =
        TextEditingController(text: consultation.notes);

        return AlertDialog(
          title: const Text('Modifier les Notes'),
          content: TextField(
            controller: _notesController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Entrez les nouvelles notes...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Save updated notes here
              },
              child: const Text('Enregistrer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}
