import 'package:flutter/material.dart';
import 'package:mini_projet/Views/UtilisationCourante.dart';
import 'package:mini_projet/Views/stats.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Le widget Hero pour une transition fluide entre les pages
            Hero(
              tag: 'utilisation_courante_tag',
              child: ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page UtilisationCourante
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UtilisationCourante(),
                    ),
                  );
                },
                // Style du bouton
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                // Contenu du bouton
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.access_time, size: 30),
                    Text(
                      'Utilisation Courante',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Le widget Hero pour une transition fluide entre les pages
            Hero(
              tag: 'statistique_tag',
              child: ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page PageStats
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageStats(),
                    ),
                  );
                },
                // Style du bouton
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                // Contenu du bouton
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.insert_chart, size: 30),
                    Text(
                      'Statistique',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
