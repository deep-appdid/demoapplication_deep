import 'dart:convert';

import 'package:demoapplication_deep/model/mealdetailmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomMealScreen extends StatefulWidget {
  const RandomMealScreen({Key? key}) : super(key: key);

  @override
  State<RandomMealScreen> createState() => _RandomMealScreenState();
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  Meal? mealDetail;

  @override
  void initState() {
    super.initState();
    randomMealsDetail();
  }

  Future<void> randomMealsDetail() async {
    const url = "https://www.themealdb.com/api/json/v1/1/random.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      MealModel mealModel = MealModel.fromJson(jsonData);
      mealDetail = mealModel.meals[0];

      if (context.mounted) {
        setState(() {});
      }
    } else {
      // Handle error if needed
    }
  }

  Future<void> _onRefresh() async {
    // Call the API to get a new random meal detail
    await randomMealsDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mealDetail != null)
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Image.network(mealDetail!.strMealThumb!),
                  ),
                Divider(),
                Text("Meal Name: ${mealDetail?.strMeal ?? ''}"),
                Divider(),
                Text("Category: ${mealDetail?.strCategory ?? ''}"),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Instructions:  ${mealDetail?.strInstructions ?? ''}",
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
