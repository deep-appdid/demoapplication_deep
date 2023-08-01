import 'package:demoapplication_deep/model/categorymodel.dart';
import 'package:demoapplication_deep/model/slider.dart';
import 'package:demoapplication_deep/screens/allmeals.dart';
import 'package:demoapplication_deep/screens/login_screen.dart';
import 'package:demoapplication_deep/screens/navdrawer.dart';
import 'package:demoapplication_deep/screens/search_screen.dart';
import 'package:demoapplication_deep/screens/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<CategoryElement> categories = []; // Update the data type
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  Future<void> getCategory() async {
    const url = "https://www.themealdb.com/api/json/v1/1/categories.php";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (context.mounted) {
        setState(() {
          categories = categoryFromJson(response.body);
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Text(
                      'Search...',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WishListScreen()));
              },
              icon: Icon(Icons.favorite)),
          IconButton(
              onPressed: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
              ),
              items: imageList.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 180.0,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          // Adjust the border radius as desired
                          border: Border.all(
                            color: Colors.black,
                            // Set the color of the border
                            width: 2.0, // Set the width of the border
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          // Adjust the border radius to match the container
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  CategoryElement categoryElement = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllMealsScreen(category: categoryElement)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            categoryElement.strCategoryThumb ?? '',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            categoryElement.strCategory ?? '',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
