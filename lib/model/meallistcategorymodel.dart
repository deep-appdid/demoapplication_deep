import 'dart:convert';

class MealCategory {
  final String strCategory;

  MealCategory(this.strCategory);
}

List<MealCategory> parseMealCategories(String responseBody) {
  final parsed =
      json.decode(responseBody)['meals'].cast<Map<String, dynamic>>();
  return parsed
      .map<MealCategory>((json) => MealCategory(json['strCategory']))
      .toList();
}
