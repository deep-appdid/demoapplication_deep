import 'package:demoapplication_deep/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  GoogleSignInAccount? _googleUser;

  @override
  void initState() {
    super.initState();
    _loadGoogleUser();
  }

  void _loadGoogleUser() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final googleUser = await _googleSignIn.signInSilently();
      setState(() {
        _googleUser = googleUser;
      });
    } catch (e) {
      print('Error loading Google User: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _googleUser?.photoUrl != null
                      ? NetworkImage(_googleUser!.photoUrl.toString())
                      : null,
                  child: _googleUser?.photoUrl == null
                      ? Text(
                          _googleUser?.displayName?.substring(0, 1) ?? "",
                          style: TextStyle(fontSize: 30),
                        )
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  _googleUser?.displayName ?? 'Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _googleUser?.email ?? 'Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: _handleSignOut,
          ),
        ],
      ),
    );
  }

  void _handleSignOut() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      await _googleSignIn.signOut();

      setState(() {
        _googleUser = null;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // You can add more sign-out logic here if needed.
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
