import 'package:evidya/lms/home_screen.dart';
import 'package:evidya/model/profile.dart';
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/livestreaming/live_stremaing_screen.dart';
import 'package:evidya/screens/meet/meetlist/view/meet_screen.dart';
import 'package:evidya/screens/messenger/tabview.dart';
import 'package:evidya/screens/setting/settinghome.dart';
import 'package:evidya/screens/user/user_profile.dart';
//import 'package:evidya/screens/messenger/tabview.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../foram.dart';

class BottomNavbar extends StatefulWidget {
  final int index;
  const BottomNavbar({this.index, Key key}) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    MeetList_Screen(),
    LiveStreamingScreen(),
    MessengerTab(),
    HomeScreen(),
    UserProfile()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/back_ground.jpg"),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/back_ground.jpg"),
                  fit: BoxFit.fill),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent, //Color(0xFF111a21),
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    height: 8.5.h,
                    width: 9.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedIndex == 0
                            ? Colors.white
                            : Colors.transparent),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/bottombar/bmeet.png",
                          color: _selectedIndex == 0
                              ? AppColors.appNewDarkThemeColor
                              : Colors.white,
                          height: 4.h,
                          width: 4.h,
                        ),
                        Text(
                          'bmeet',
                          style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 0
                                  ? AppColors.appNewDarkThemeColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 8.5.h,
                    width: 9.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedIndex == 1
                            ? Colors.white
                            : Colors.transparent),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/bottombar/blive.png",
                          color: _selectedIndex == 1
                              ? AppColors.appNewDarkThemeColor
                              : Colors.white,
                          height: 4.h,
                          width: 4.h,
                        ),
                        Text(
                          'blive',
                          style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 1
                                  ? AppColors.appNewDarkThemeColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 8.5.h,
                    width: 9.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedIndex == 2
                            ? Colors.white
                            : Colors.transparent),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/bottombar/bchat.png",
                          color: _selectedIndex == 2
                              ? AppColors.appNewDarkThemeColor
                              : Colors.white,
                          height: 4.h,
                          width: 4.h,
                        ),
                        Text(
                          'bchat',
                          style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 2
                                  ? AppColors.appNewDarkThemeColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 8.5.h,
                    width: 9.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedIndex == 3
                            ? Colors.white
                            : Colors.transparent),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/bottombar/blearn.png",
                          color: _selectedIndex == 3
                              ? AppColors.appNewDarkThemeColor
                              : Colors.white,
                          height: 4.h,
                          width: 4.h,
                        ),
                        Text(
                          'blearn',
                          style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 3
                                  ? AppColors.appNewDarkThemeColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 8.5.h,
                    width: 9.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedIndex == 4
                            ? Colors.white
                            : Colors.transparent),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/bottombar/Profile.png",
                          color: _selectedIndex == 4
                              ? AppColors.appNewDarkThemeColor
                              : Colors.white,
                          height: 3.5.h,
                          width: 3.5.h,
                        ),
                        SizedBox(
                          height: 3.5,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 4
                                  ? AppColors.appNewDarkThemeColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  label: '',
                ),
              ],
              selectedItemColor: Colors.white,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              unselectedItemColor: Colors.white,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          )),
    );
  }
}
