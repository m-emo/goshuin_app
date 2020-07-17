import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          icon: FaIcon(FontAwesomeIcons.toriiGate),
          title: Text('御朱印'),
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.cameraRetro),
          title: Text('登録'),
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
