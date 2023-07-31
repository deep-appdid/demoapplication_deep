import 'package:demoapplication_deep/model/ingridentlistmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:demoapplication_deep/model/mealmodel.dart';
import 'package:demoapplication_deep/screens/mealdetail_screen.dart';

class AllIngridentMealsScreen extends StatefulWidget {
  final Ingredient ingredient;

  const AllIngridentMealsScreen({Key? key, required this.ingredient})
      : super(key: key);

  @override
  State<AllIngridentMealsScreen> createState() =>
      _AllIngridentMealsScreenState();
}

class _AllIngridentMealsScreenState extends State<AllIngridentMealsScreen> {
  List<MealAll> allMeals = [];

  @override
  void initState() {
    super.initState();
    getAllMeals(); // Fetch all meals for the specified area
  }

  Future<void> getAllMeals() async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/filter.php?i=${widget.ingredient.name}"; // Use the widget.area to get the specified area

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
        title: Text(widget.ingredient.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
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
                  return const Divider(
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
