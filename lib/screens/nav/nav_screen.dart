import 'package:flutter/material.dart';


class NavScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Text('Nav Screen'),
       ),
   ),
    );
  }
}