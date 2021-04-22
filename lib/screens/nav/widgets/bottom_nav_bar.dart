import 'package:flutter/material.dart';
import 'package:flutter_gram/enums/bottom_nav_item.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;

  const BottomNavBar({
    @required this.items, 
    @required this.selectedItem, 
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: BottomNavItem.values.indexOf(selectedItem),
      onTap: onTap,
      items: items.map((item, icon) => MapEntry(
        item.toString(),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(icon, size: 30.0)
        )
      )).values.toList(),
      
    );
  }
}