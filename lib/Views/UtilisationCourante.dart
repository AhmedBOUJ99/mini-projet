import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:audioplayers/audioplayers.dart';

class UtilisationCourante extends StatefulWidget {
  @override
  _UtilisationCouranteState createState() => _UtilisationCouranteState();
}

class _UtilisationCouranteState extends State<UtilisationCourante> {
  late DatabaseReference _databaseReference;
  late StreamController<int> _streamController;
  final player = AudioPlayer();
  int utilisationCourante = 0;

  @override
  void initState() {
    super.initState();

    // Obtenez la date actuelle pour former la clé dans la base de données
    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";

    // Référencez le nœud 'water_usage' avec la date spécifique dans la base de données
    _databaseReference = FirebaseDatabase.instance
        .reference()
        .child('water_usage')
        .child('$formattedDate');

    // Utilisez un StreamController pour gérer les mises à jour en temps réel
    _streamController = StreamController<int>();

    // Écoutez les changements dans le nœud 'water_usage' avec la date spécifique
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        // Mettez à jour la valeur actuelle et ajoutez-la au flux
        int nouvelleValeur = event.snapshot.value as int;
        _streamController.add(nouvelleValeur);

        // Vérifiez si l'utilisation courante est supérieure à 1000
        if (nouvelleValeur > 1000) {
          _playAlertSound();
          _afficherAlerte();
        }
      }
    });
  }

  // Fonction pour afficher une alerte avec un son
  void _afficherAlerte() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerte'),
          content: Text('L\'utilisation actuelle est supérieure à 1000 L !'),
          actions: [
            TextButton(
              onPressed: () {
                // Arrêtez le son quand l'alerte est fermée
                player.stop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Jouez le son d'alerte lors de l'affichage de l'alerte
    _playAlertSound();
  }

  // Fonction pour jouer le son d'alerte
  void _playAlertSound() async {
    await player.play(AssetSource("Alarmsoundeffect.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          int valeurActuelle = snapshot.data ?? utilisationCourante;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: valeurActuelle <= 1000
                    ? [
                        Colors.blue.shade100,
                        Colors.blue.shade200,
                        Colors.blue.shade300,
                        Colors.blueAccent
                      ]
                    : [
                        Colors.red.shade100,
                        Colors.red.shade200,
                        Colors.red.shade300,
                        Colors.red.shade500
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'Utilisation Courante : $valeurActuelle L',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Fermez le contrôleur de flux lorsque le widget est supprimé
    _streamController.close();
    super.dispose();
  }
}
