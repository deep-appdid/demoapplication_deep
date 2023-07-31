// To parse this JSON data, do
//
//     final meals = mealsFromJson(jsonString);

import 'dart:convert';

Meals mealsFromJson(String str) => Meals.fromJson(json.decode(str));

String mealsToJson(Meals data) => json.encode(data.toJson());

class Meals {
  final List<MealAll>? meals;

  Meals({
    this.meals,
  });

  factory Meals.fromJson(Map<String, dynamic> json) => Meals(
    meals: json["meals"] == null ? [] : List<MealAll>.from(json["meals"]!.map((x) => MealAll.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meals": meals == null ? [] : List<dynamic>.from(meals!.map((x) => x.toJson())),
  };
}

class MealAll {
  final String? strMeal;
  final String? strMealThumb;
  final String? idMeal;

  MealAll({
    this.strMeal,
    this.strMealThumb,
    this.idMeal,
  });

  factory MealAll.fromJson(Map<String, dynamic> json) => MealAll(
    strMeal: json["strMeal"],
    strMealThumb: json["strMealThumb"],
    idMeal: json["idMeal"],
  );

  Map<String, dynamic> toJson() => {
    "strMeal": strMeal,
    "strMealThumb": strMealThumb,
    "idMeal": idMeal,
  };
}
