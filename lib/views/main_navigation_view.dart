import 'package:flutter/material.dart';
import 'package:studants/views/EmergencyListView.dart';
import 'package:studants/views/SettingsDrawerview.dart';
import 'package:studants/views/home_view.dart';
import 'package:studants/views/lectures_view.dart';
import 'package:studants/views/my_requests_view.dart';
import 'package:studants/widgets/widgets_home/bottom_nav.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 1;

  void _onNavItemTapped(int index) {
    if (index == 4) {
      _scaffoldKey.currentState?.openDrawer();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _scaffoldKey,
      drawer: SettingsDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          LecturesView(showBackButton: false),
          const HomeView(),
          const MyRequestsView(showBackButton: false),
          const EmergencyListView(showBackButton: false),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}