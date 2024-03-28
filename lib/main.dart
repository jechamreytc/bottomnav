import 'package:bottomnav/Main%20Page/main_page.dart';
import 'package:bottomnav/Page/page1.dart';
import 'package:bottomnav/Page/page2.dart';
import 'package:bottomnav/Page/page3.dart';
import 'package:bottomnav/Page/page4.dart';
import 'package:bottomnav/Page/page5.dart';
import 'package:bottomnav/QR%20CODE/qr_code_scanner.dart';
import 'package:bottomnav/QR%20CODE/qr_code_scanner_1.dart';
import 'package:bottomnav/QR%20CODE/qr_code_scanner_2.dart';
import 'package:bottomnav/Room%20Page/create_room_page.dart';
import 'package:bottomnav/Room%20Page/room_page.dart';
import 'package:bottomnav/Security/login_admin.dart';
import 'package:bottomnav/Security/sign_up.dart';
import 'package:bottomnav/User%20Side/user_chamber.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
    const Page5(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 6, 73, 216),
            Color.fromARGB(255, 6, 109, 10)
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Stack(
            children: [
              BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    label: "Time",
                    backgroundColor: Colors.grey,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.assignment,
                      color: Colors.white,
                    ),
                    label: "Assign",
                    backgroundColor: Colors.grey,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.qr_code,
                      color: Colors.white,
                    ),
                    label: "QR Code",
                    backgroundColor: Colors.grey,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    label: "Message",
                    backgroundColor: Colors.grey,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: "Profile",
                    backgroundColor: Colors.grey,
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.normal),
                selectedFontSize: 14,
                unselectedFontSize: 12,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedIconTheme: const IconThemeData(size: 35),
                unselectedIconTheme: const IconThemeData(size: 20),
                backgroundColor: Colors.grey[200],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * _selectedIndex / 5,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: 5,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
