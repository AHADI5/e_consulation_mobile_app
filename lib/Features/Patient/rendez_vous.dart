import 'package:flutter/material.dart';

import 'drawer_menu.dart';

class RendezVousPage extends StatelessWidget {
  const RendezVousPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rendez-vous'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Réjeté'),
              Tab(text: 'Attente'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        drawer: CustomDrawer(),
        body: const TabBarView(
          children: [
            Center(child: Text('Rejected')),
            Center(child: Text('Accepted')),
            Center(child: Text('Done')),
          ],
        ),
      ),
    );
  }
}
