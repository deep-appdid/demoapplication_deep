import 'package:demoapplication_deep/databases/wishlist_database.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  WishListScreenState createState() => WishListScreenState();
}

class WishListScreenState extends State<WishListScreen> {
  List<Map<String, dynamic>>? getwishlistData;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<void> _handleRefresh() async {
    getwishlistData = await WishlistDatabase.getWishlistItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _handleRefresh,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (getwishlistData == null || getwishlistData!.isEmpty
                ? Center(
                    child: Image.asset('assets/images/empty.png'),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: getwishlistData!.length,
                    itemBuilder: (context, index) {
                      final getWishlistIndex = getwishlistData![index];

                      return InkWell(
                        onTap: () {
                          //   Navigator.push(context, MaterialPageRoute(builder: (c)))
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade100),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Image.network(
                                        getWishlistIndex[
                                            WishlistDatabase.columnImage],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Text(
                                      getWishlistIndex[
                                          WishlistDatabase.columnTitle],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showBottomSheet(getWishlistIndex);
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
      ),
    );
  }

  void _showBottomSheet(Map<String, dynamic> getWishlistIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Share.share(
                    'check out my website https://example.com',
                    subject: 'Look what I made!',
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () async {
                  // Call the delete method of WishlistDatabase here
                  await WishlistDatabase.removeFromWishlist(
                      getWishlistIndex[WishlistDatabase.columnTitle]);
                  if (context.mounted) Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
