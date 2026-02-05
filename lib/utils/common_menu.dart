import 'package:flutter/material.dart';

class CommonMenuIcon extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CommonMenuIcon({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        scaffoldKey.currentState?.openDrawer();
      },
      borderRadius: BorderRadius.circular(20),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.menu_sharp, color: Colors.black),
      ),
    );
  }
}