import 'package:flutter/foundation.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';

class ZonesProvider extends ChangeNotifier {
  final List<Zone> _zones = jeuDeDonnees();

  // Copie en lecture seule : on ne modifie la liste que par les méthodes
  List<Zone> get zones => List.unmodifiable(_zones);

  int get nombre => _zones.length;

  int get nombreAIrriguer => _zones.where((z) => z.besoinIrrigation).length;

  // Noms des zones (sauf une), pour refuser un doublon dans le formulaire
  List<String> noms({Zone? sauf}) {
    return _zones.where((z) => z != sauf).map((z) => z.nom).toList();
  }

  void modifierHumidite(Zone zone, double delta) {
    // TODO 1 : modifier l'humidité, puis prévenir les écrans
    zone.humidite = (zone.humidite + delta).clamp(0, 100).toDouble();
    notifyListeners();
  }

  void ajouter(Zone zone) {
    // TODO 2 : ajouter la zone à _zones, puis notifyListeners()
    _zones.add(zone);
    notifyListeners();
  }

  void remplacer(Zone ancienne, Zone nouvelle) {
    // TODO 3 : trouver l'index de l'ancienne zone (indexOf). Si elle
    // n'existe pas (-1) : return. Sinon remplacer, puis notifyListeners()
    final index = _zones.indexOf(ancienne);
    if (index != -1) {
      _zones[index] = nouvelle;
      notifyListeners();
    }
  }

  void supprimer(Zone zone) {
    // TODO 4 : retirer la zone de _zones, puis notifyListeners()
    _zones.remove(zone);
    notifyListeners();
  }
}