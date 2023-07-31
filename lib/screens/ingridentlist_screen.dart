import 'dart:convert';

import 'package:demoapplication_deep/model/ingridentlistmodel.dart';
import 'package:demoapplication_deep/screens/allingridentmeals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IngridentListScreens extends StatefulWidget {
  const IngridentListScreens({Key? key}) : super(key: key);

  @override
  State<IngridentListScreens> createState() => _IngridentListScreensState();
}

class _IngridentListScreensState extends State<IngridentListScreens> {
  List<Ingredient> ingredients = []; // List of ingredients
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ingredientData();
  }

  Future<void> ingredientData() async {
    const url = "https://www.themealdb.com/api/json/v1/1/list.php?i=list";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the API call is successful, parse the JSON response
      final jsonData = json.decode(response.body);
      final meals = jsonData['meals'] as List<dynamic>;
      setState(() {
        ingredients = meals.map((meal) => Ingredient.fromJson(meal)).toList();
        _isLoading = false;
      });
    } else {
      // Handle errors if the API call fails
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllIngridentMealsScreen(
                                            ingredient: ingredients[index])));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(ingredients[index].id),
                            ),
                            title: Text(ingredients[index].name),
                            // You can display more information about the ingredient here if needed.
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
