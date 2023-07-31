import 'package:demoapplication_deep/screens/arealist.dart';
import 'package:demoapplication_deep/screens/ingridentlist_screen.dart';
import 'package:demoapplication_deep/screens/mealcategory.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MealCategoryScreen()));
                  },
                  child: ListTile(
                    leading: Image.network(
                        "https://static.vecteezy.com/system/resources/previews/001/541/600/non_2x/large-set-of-different-food-and-other-items-on-white-background-free-vector.jpg"),
                    title: const Text("Categories"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AreaListScreen()));
                  },
                  child: ListTile(
                    leading: Image.network(
                        "https://img.favpng.com/1/25/18/geography-clipart-clip-art-png-favpng-V43D2JaBaPDdhrRc5SDMJM5B9.jpg"),
                    title: const Text("Area"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IngridentListScreens()));
                  },
                  child: ListTile(
                    leading: Image.network(
                        "https://media.istockphoto.com/id/1241569277/vector/ingredient-composition-of-homemade-healthy-and-fresh-bakery-item-like-cake-bread-or-pizza.jpg?s=612x612&w=0&k=20&c=3joX_0SQTaAjUf-8InGbblQ0J4Eorfv1i7UHnvtwnfQ="),
                    title: const Text("Ingredients"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
