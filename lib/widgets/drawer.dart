import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_buzz_bytes/pages/aboutus.dart';
import 'package:vit_buzz_bytes/pages/login.dart';
import 'package:vit_buzz_bytes/pages/profile.dart';

final textStyle = GoogleFonts.inter(
  fontSize: 21,
  fontWeight: FontWeight.w600,
);
AppBar appBarForDrawerScreens(String title) {
  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.outfit(
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: const Color.fromARGB(255, 203, 203, 203)),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
        children: <Widget>[
          Row(
            children: [
              Image.asset(
                'assets/images/app_icon.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'VITBuzzBytes',
                style: GoogleFonts.outfit(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 203, 203, 203)),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('About Us', style: textStyle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                        appBar: appBarForDrawerScreens("About Us"),
                        body: const AboutUs())),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('My Profile', style: textStyle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                        appBar: appBarForDrawerScreens("My Profile"),
                        body: const ProfileScreen())),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text('Sign Out', style: textStyle),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('vitBuzzBytesToken');
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
