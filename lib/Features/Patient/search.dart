import 'package:flutter/material.dart';

class DoctorSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results here
    return ListView(
      children: [
        ListTile(
          title: const Text('Dr. John Doe'),
          subtitle: const Text('Cardiologist'),
          onTap: () {
            // Handle doctor detail view
          },
        ),
        ListTile(
          title: const Text('Dr. Jane Smith'),
          subtitle: const Text('Dermatologist'),
          onTap: () {
            // Handle doctor detail view
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions here
    return ListView(
      children: [
        ListTile(
          title: const Text('Dr. John Doe'),
          subtitle: const Text('Cardiologist'),
          onTap: () {
            query = 'Dr. John Doe';
            showResults(context);
          },
        ),
        ListTile(
          title: const Text('Dr. Jane Smith'),
          subtitle: const Text('Dermatologist'),
          onTap: () {
            query = 'Dr. Jane Smith';
            showResults(context);
          },
        ),
      ],
    );
  }
}
