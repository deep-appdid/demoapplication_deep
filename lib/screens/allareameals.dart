import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:demoapplication_deep/model/mealmodel.dart';
import 'package:demoapplication_deep/screens/mealdetail_screen.dart';

class AllAreaMealsScreen extends StatefulWidget {
  final String area; // Add the area parameter

  const AllAreaMealsScreen({Key? key, required this.area}) : super(key: key);

  @override
  State<AllAreaMealsScreen> createState() => _AllAreaMealsScreenState();
}

class _AllAreaMealsScreenState extends State<AllAreaMealsScreen> {
  List<MealAll> allMeals = [];

  @override
  void initState() {
    super.initState();
    getAllMeals(); // Fetch all meals for the specified area
  }

  Future<void> getAllMeals() async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/filter.php?a=${widget.area}"; // Use the widget.area to get the specified area

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        allMeals = mealsFromJson(response.body).meals ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: allMeals.length,
                itemBuilder: (context, index) {
                  MealAll meal = allMeals[index];
                  return InkWell(
                    onTap: () {
                      print("Tap");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailScreen(meal: meal),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(
                          meal.strMealThumb ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(meal.strMeal ?? ''),
                        onTap: () {
                          // Handle tapping on a meal item, navigate to meal details screen, etc.
                        },
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
