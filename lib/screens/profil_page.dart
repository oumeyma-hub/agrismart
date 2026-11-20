
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/providers/auth_provider.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> _confirmerDeconnexion(BuildContext context) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text(
            'Voulez-vous vraiment vous déconnecter ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirmation == true && context.mounted) {
      await context.read<AuthProvider>().deconnexion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombreZones = context.select<ZonesProvider, int>(
          (p) => p.nombre,
    );

    final utilisateur = context.watch<AuthProvider>().utilisateur;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          const Center(
            child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.agriculture, size: 40),
            ),
          ),

          const SizedBox(height: 12),

          const Center(
            child: Text(
              'Exploitation AgriSmart',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Center(
            child: Text('Kébili, Tunisie'),
          ),

          const SizedBox(height: 16),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Adresse email'),
            subtitle: Text(
              utilisateur?.email ?? 'Aucun utilisateur connecté',
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text(
              '$nombreZones',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () => _confirmerDeconnexion(context),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
