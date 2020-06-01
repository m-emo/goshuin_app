import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State<Footer> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.collections),
          title: Text('Contacts'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          title: Text('御朱印登録'),
        ),
      ],
      onTap: (int index) {
        setState(
              () {
            if (index == 1) {
              Navigator.pushNamed(context, '/addContents');
            } else {
              _navIndex = index;
            }
          },
        );
      },
      currentIndex: _navIndex,
    );
  }
}
