import 'package:flutter/material.dart';
import 'package:vit_buzz_bytes/widgets/buzzes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'General',
                ),
                Tab(text: 'Lost and Found'),
                Tab(text: 'Events'),
                Tab(text: 'FFCS'),
                Tab(text: 'Cab Sharing'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Buzzes(category: 'general'),
            Buzzes(category: 'lostandfound'),
            Buzzes(category: 'events'),
            Buzzes(category: 'ffcs'),
            Buzzes(category: 'cabsharing'),
          ],
        ),
      ),
    );
  }
}
