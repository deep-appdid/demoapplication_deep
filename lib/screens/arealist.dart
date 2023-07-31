import 'dart:convert';

import 'package:demoapplication_deep/model/areamodel.dart';
import 'package:demoapplication_deep/screens/allareameals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests

class AreaListScreen extends StatefulWidget {
  const AreaListScreen({Key? key}) : super(key: key);

  @override
  State<AreaListScreen> createState() => _AreaListScreenState();
}

class _AreaListScreenState extends State<AreaListScreen> {
  List<dynamic> areaMealsList = []; // This list will store the 'strArea' strings
  @override
  void initState() {
    super.initState();
    fetchMealsData(); // Fetch the JSON data when the screen is loaded
  }

  Future<void> fetchMealsData() async {
    const url = "https://www.themealdb.com/api/json/v1/1/list.php?a=list";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> meals = data["meals"];
      setState(() {
        areaMealsList = meals.map((meal) => MealArea(meal["strArea"])).toList();
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Area List'),
      ),
      body: ListView.builder(
        itemCount: areaMealsList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllAreaMealsScreen(area: areaMealsList[index].name),
                ),
              );
            },
            child: ListTile(
              title: Text(areaMealsList[index].name ?? ""),
              // Add any other widgets you want to show for each item
            ),
          );
        },
      ),

    );
  }
}
