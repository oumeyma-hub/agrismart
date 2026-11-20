
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/models/meteo.dart';
import 'package:agrismart/providers/meteo_provider.dart';

class MeteoCard extends StatelessWidget {
  const MeteoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MeteoProvider>();

    late final Widget contenu;

    switch (provider.etat) {
    // État de chargement
      case EtatMeteo.chargement:
        contenu = const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Chargement de la météo...'),
              ],
            ),
          ),
        );
        break;

    // État d'erreur
      case EtatMeteo.erreur:
        contenu = Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_off,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                provider.erreur,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () {
                  context.read<MeteoProvider>().charger();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        );
        break;

    // État de succès
      case EtatMeteo.succes:
        final meteo = provider.meteo;

        if (meteo == null) {
          contenu = const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Aucune donnée météo disponible.'),
          );
        } else {
          contenu = _Contenu(meteo: meteo);
        }
        break;
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: contenu,
    );
  }
}

// Contenu de la météo lorsque le chargement réussit
class _Contenu extends StatelessWidget {
  final Meteo meteo;

  const _Contenu({
    required this.meteo,
  });

  static const List<String> _jours = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim',
  ];

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;

    final pluie = meteo.pluieTotale;

    final conseil = pluie >= 5
        ? 'Pluie prévue (${pluie.toStringAsFixed(1)} mm) : '
        "repoussez l'irrigation"
        : 'Pas de pluie significative prévue';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            'Météo à Kébili',
            style: texte.titleMedium,
          ),

          const SizedBox(height: 8),

          // Température et informations météo
          Row(
            children: [
              Text(
                '${meteo.temperature.toStringAsFixed(0)} °C',
                style: texte.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Humidité de l'air : ${meteo.humiditeAir} %",
                  ),
                  Text(
                    'Vent : ${meteo.vent.toStringAsFixed(0)} km/h',
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 24),

          // Prévisions des trois jours
          for (final p in meteo.previsions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      _jours[p.date.weekday - 1],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${p.tMin.toStringAsFixed(0)}° / '
                          '${p.tMax.toStringAsFixed(0)}°',
                    ),
                  ),
                  const Icon(
                    Icons.water_drop_outlined,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${p.pluie.toStringAsFixed(1)} mm',
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Conseil d'irrigation
          Text(
            conseil,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
