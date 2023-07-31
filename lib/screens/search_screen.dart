import 'dart:convert';

import 'package:demoapplication_deep/model/mealdetailmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Meal? mealDetail;
  TextEditingController searchController = TextEditingController();

  Future<void> searchMeal() async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/search.php?s=${searchController.text.trim()}";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      MealModel mealModel = MealModel.fromJson(jsonData);
      mealDetail = mealModel.meals[0];
      print(mealDetail);
      setState(() {});
    } else {
      // Handle error if needed
      print("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchMeal();
                  },
                ),
                hintText: '   Search...',
                border: InputBorder.none),
          ),
        ),
      )),
      body: SafeArea(
        child: SingleChildScrollView(
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
              const Divider(),
              Text("Meal Name: ${mealDetail?.strMeal ?? ''}"),
              const Divider(),
              Text("Category: ${mealDetail?.strCategory ?? ''}"),
              const Divider(),
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
    );
  }
}
