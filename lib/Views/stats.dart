import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Classe représentant les données d'utilisation de l'eau pour l'histogramme
class WaterUsageData {
  final String date;
  final int total;

  WaterUsageData(this.date, this.total);
}

// Widget pour afficher l'histogramme d'utilisation de l'eau
class WaterUsageHistogram extends StatefulWidget {
  final List<WaterUsageData> data;

  WaterUsageHistogram({required this.data});

  @override
  _WaterUsageHistogramState createState() => _WaterUsageHistogramState();
}

class _WaterUsageHistogramState extends State<WaterUsageHistogram> {
  WaterUsageData? selectedData; // Donnée sélectionnée dans l'histogramme

  @override
  Widget build(BuildContext context) {
    // Configuration de la série pour l'histogramme
    List<charts.Series<WaterUsageData, String>> series = [
      charts.Series(
        id: 'WaterUsage (Litres)',
        data: widget.data,
        domainFn: (WaterUsageData usage, _) => usage.date,
        measureFn: (WaterUsageData usage, _) => usage.total,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (WaterUsageData usage, _) {
          return usage == selectedData
              ? charts.ColorUtil.fromDartColor(
                  Color.fromRGBO(33, 150, 243, 0.7))
              : charts.MaterialPalette.blue.shadeDefault;
        },
        labelAccessorFn: (WaterUsageData usage, _) => '${usage.total}',
      ),
    ];

    // Widget de l'histogramme avec les interactions et les légendes
    return GestureDetector(
      onTap: () {
        // Réinitialiser la donnée sélectionnée lorsqu'on appuie
        setState(() {
          selectedData = null;
        });
      },
      child: charts.BarChart(
        series,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [
          charts.SeriesLegend(),
          charts.SelectNearest(
            eventTrigger: charts.SelectionTrigger.tapAndDrag,
          ),
        ],
        domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            labelRotation: 45,
          ),
        ),
        selectionModels: [
          new charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: (model) {
              // Mettre à jour la donnée sélectionnée lorsqu'elle change
              if (model.hasDatumSelection) {
                setState(() {
                  selectedData = model.selectedDatum.first.datum;
                });
              }
            },
          ),
        ],
        defaultRenderer: charts.BarRendererConfig(
          barRendererDecorator: charts.BarLabelDecorator<String>(
            labelPosition: charts.BarLabelPosition.inside,
            insideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
            ),
          ),
        ),
      ),
    );
  }
}

// Page pour afficher les statistiques d'utilisation de l'eau
class PageStats extends StatefulWidget {
  const PageStats({Key? key}) : super(key: key);

  @override
  _PageStatsState createState() => _PageStatsState();
}

class _PageStatsState extends State<PageStats> {
  TextEditingController tapWaterController = TextEditingController();
  TextEditingController showerController = TextEditingController();
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  late DatabaseReference waterUsageRef;
  WaterUsageData? selectedData; // Donnée sélectionnée pour afficher les détails

  @override
  void initState() {
    super.initState();
    waterUsageRef = dbRef.child('water_usage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Usage Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: waterUsageRef.onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    Map<dynamic, dynamic>? data = snapshot.data!.snapshot.value;
                    if (data != null) {
                      List<MapEntry<String, dynamic>> dateList = [];
                      data.forEach((key, value) {
                        if (value is int) {
                          dateList.add(MapEntry(key, value));
                        }
                      });

                      dateList.sort((a, b) {
                        var dateA = a.key;
                        var dateB = b.key;
                        return dateA.compareTo(dateB);
                      });

                      final currentDate = DateTime.now();
                      final formattedDate =
                          "${currentDate.year}-${currentDate.month}-${currentDate.day}";

                      dateList
                          .removeWhere((entry) => entry.key == formattedDate);

                      List<WaterUsageData> histogramData =
                          dateList.map((entry) {
                        return WaterUsageData(entry.key, entry.value);
                      }).toList();

                      return WaterUsageHistogram(data: histogramData);
                    } else {
                      return Text('No data available.');
                    }
                  } else {
                    return Text('Loading...');
                  }
                },
              ),
            ),
            if (selectedData != null)
              Text(
                'Selected Data: ${selectedData!.date} - Total: ${selectedData!.total}',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  // Fonction pour calculer et enregistrer l'utilisation totale dans la base de données
  void calculateTotalUsage() {
    double tapWaterUsage = double.tryParse(tapWaterController.text) ?? 0.0;
    int showerUsage = int.tryParse(showerController.text) ?? 0;
    double totalUsage = tapWaterUsage + showerUsage;

    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";

    waterUsageRef.child(formattedDate).set(ServerValue.increment(totalUsage));
  }
}
