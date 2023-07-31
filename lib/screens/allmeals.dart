import 'package:demoapplication_deep/model/categorymodel.dart';
import 'package:demoapplication_deep/model/meallistcategorymodel.dart';
import 'package:demoapplication_deep/model/mealmodel.dart';
import 'package:demoapplication_deep/screens/mealdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllMealsScreen extends StatefulWidget {
  final CategoryElement? category;
  final MealCategory? mealCategories;

  const AllMealsScreen({Key? key, this.category, this.mealCategories})
      : super(key: key);

  @override
  State<AllMealsScreen> createState() => _AllMealsScreenState();
}

class _AllMealsScreenState extends State<AllMealsScreen> {
  List<MealAll> allMeals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMeals();
  }

  Future<void> getAllMeals() async {
    String categoryName = widget.category?.strCategory ??
        widget.mealCategories?.strCategory ??
        '';

    if (categoryName.isEmpty) {
      // Handle the case when both category and mealCategories are empty or null.
      return;
    }

    final url =
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName";

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
        title: Text(widget.category?.strCategory ?? ""),
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
                    color: Colors
                        .grey, // You can choose your preferred color for the separator line.
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
