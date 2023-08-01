import 'dart:convert';

import 'package:demoapplication_deep/databases/wishlist_database.dart';
import 'package:demoapplication_deep/model/mealdetailmodel.dart';
import 'package:demoapplication_deep/model/mealmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealDetailScreen extends StatefulWidget {
  final MealAll meal;

  const MealDetailScreen({Key? key, required this.meal}) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Future<Meal?>? _mealDetailFuture;
  bool isFavorite = false; // Track the favorite status
  Meal? mealDetail; // Move mealDetail to class level

  @override
  void initState() {
    super.initState();
    _mealDetailFuture = mealsDetail();
  }

  Future<Meal?> mealsDetail() async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.meal.idMeal}";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      MealModel mealModel = MealModel.fromJson(jsonData);
      return mealModel.meals.isNotEmpty ? mealModel.meals[0] : null;
    } else {
      // Handle error if needed
      print("Failed to fetch data");
      return null;
    }
  }

  void toggleFavorite(Meal mealDetail) async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      try {
        await WishlistDatabase.addToWishlist(
          title: mealDetail.strMeal.toString(), // Corrected title
          image: mealDetail.strMealThumb.toString(), // Corrected image
          mealid: '',
        );
        print("Added to wishlist");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to wishlist'),
          ),
        );
      } catch (e) {
        print("Failed to add to wishlist: $e");
      }
    } else {
      try {
        await WishlistDatabase.removeFromWishlist(
            mealDetail.strMeal.toString());
        print("Removed from wishlist");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from wishlist'),
          ),
        );
      } catch (e) {
        print("Failed to remove from wishlist: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Meal?>(
              future: _mealDetailFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  // Error state
                  return const Center(
                      child: Text("Failed to fetch meal details"));
                } else {
                  // Success state
                  Meal? mealDetail = snapshot.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.network(mealDetail!.strMealThumb!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    toggleFavorite(mealDetail);
                                    print("Favourite Tap");
                                  },
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text("Meal Name: ${mealDetail.strMeal ?? ''}"),
                      const Divider(),
                      Text("Category: ${mealDetail.strCategory ?? ''}"),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Instructions: ${mealDetail.strInstructions ?? ''}",
                            textAlign: TextAlign.start),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
