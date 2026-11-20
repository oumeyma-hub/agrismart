
import 'package:flutter/foundation.dart';

import 'package:agrismart/models/meteo.dart';
import 'package:agrismart/services/meteo_service.dart';

enum EtatMeteo {
  chargement,
  succes,
  erreur,
}

class MeteoProvider extends ChangeNotifier {
  final MeteoService _service;

  MeteoProvider({MeteoService? service})
      : _service = service ?? MeteoService();

  EtatMeteo _etat = EtatMeteo.chargement;

  Meteo? _meteo;

  String _erreur = '';

  DateTime? _derniereMiseAJour;

  EtatMeteo get etat => _etat;

  Meteo? get meteo => _meteo;

  String get erreur => _erreur;

  DateTime? get derniereMiseAJour => _derniereMiseAJour;

  Future<void> charger() async {
    // État de chargement
    _etat = EtatMeteo.chargement;
    notifyListeners();

    try {
      // Récupération des données météo
      _meteo = await _service.charger();

      // Mise à jour de la date
      _derniereMiseAJour = DateTime.now();

      // État de succès
      _etat = EtatMeteo.succes;
      _erreur = '';

    } on MeteoException catch (e) {
      // Erreur connue
      _erreur = e.message;
      _etat = EtatMeteo.erreur;

    } catch (e) {
      // Erreur inattendue
      _erreur = 'Une erreur inattendue est survenue';
      _etat = EtatMeteo.erreur;
    }

    // Actualisation de l'interface
    notifyListeners();
  }
}
