import 'package:flutter/material.dart';
import 'package:mini_projet/Views/stats.dart';
import 'package:mini_projet/Views/pagenav.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a light background color
      body: Center(
        child: SingleChildScrollView(
          // Enable scrolling
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bienvenue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.lightBlueAccent, // Use a softer color
                ),
              ),
              Text(
                "Bien être",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                "Consommateurs",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                // Use a rounded rectangle clip
                borderRadius:
                    BorderRadius.circular(125), // Circular border radius
                child: Image.asset(
                  "assets/water.png",
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // Add a gradient to the button
                    colors: [Colors.blue.shade900, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                  boxShadow: [
                    // Add a shadow for depth
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NavPage()),
                    );
                  },
                  child: Text(
                    "Commencer",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent, // Apply transparent background
                    shadowColor: Colors.transparent, // No shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
