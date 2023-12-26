import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_buzz_bytes/pages/add_buzz.dart';
import 'package:vit_buzz_bytes/pages/home.dart';
import 'package:vit_buzz_bytes/pages/profile.dart';
import 'package:vit_buzz_bytes/widgets/bottom_nav.dart';
import 'package:vit_buzz_bytes/widgets/drawer.dart';

class BaseScreen extends ConsumerWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int indexOfBottomNav = ref.watch(navBarIndexProvider);
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: const Icon(Icons.menu, size: 35), // Change size here
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          title: Text(
            "VITBuzzBytes",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 35,
                  )),
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (indexOfBottomNav == 0)
              ? const HomeScreen()
              : (indexOfBottomNav == 1)
                  ? const AddBuzzScreen()
                  : const ProfileScreen(),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar());
  }
}
