import 'package:demoapplication_deep/model/meallistcategorymodel.dart';
import 'package:demoapplication_deep/screens/allmeals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealCategoryScreen extends StatefulWidget {
  const MealCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MealCategoryScreen> createState() => _MealCategoryScreenState();
}

class _MealCategoryScreenState extends State<MealCategoryScreen> {
  List<MealCategory> _mealCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<MealCategory> mealCategories = await fetchMealCategories();
      setState(() {
        _mealCategories = mealCategories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  Future<List<MealCategory>> fetchMealCategories() async {
    const url = "https://www.themealdb.com/api/json/v1/1/list.php?c=list";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return parseMealCategories(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _mealCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllMealsScreen(
                                mealCategories: _mealCategories[index])));
                  },
                  child: ListTile(
                    title: Text(_mealCategories[index].strCategory),
                  ),
                );
              },
            ),
    );
  }
}
