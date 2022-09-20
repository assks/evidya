import 'package:evidya/utils/SizeConfigs.dart';
import 'package:evidya/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../welcome_screen/welcome_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class Policy extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<Policy> {
  String button = "Next";
  bool valuefirst = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fill
          ),),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Disclosure",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 4.h),
                const Text("bVidya collects some user data to provide better service to our users. Mentioned below are the various types of data we collect and the purpose for collecting them.",style: TextStyle(fontSize: 20),),
               SizedBox(height: 4.h,),
                const Text("•	We collect contact list data to display and sync your phone book contacts with your bVidya contacts.",style: TextStyle(fontSize: 15,color: Colors.black
                ),),
                SizedBox(height: 2.h),
                const Text('•	We collect user image data to display the user’s image on the profile for other bVidya users to identify.',style: TextStyle(fontSize: 15,color: Colors.black),),
                SizedBox(height: 2.h),
                const Text('•	We collect user email information for communication purposes regarding account activity, promotions, class schedules, Privacy Policy updates, newsletters, etc.',style: TextStyle(fontSize: 15,color: Colors.black),),
                SizedBox(height: 4.h),
                const Text('Please note that we DO NOT sell your data to third parties. Your data will only be used by us to provide you with better services. By creating an account on bVidya and using the website or mobile app, you agree to provide such data for the reasons mentioned above.'),
                SizedBox(height: 6.h),
                CheckboxListTile(
                  title: const Text('I Agree'),
                  value: valuefirst,
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      valuefirst = value;
                    });
                  },
                ),
                _submitButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _submitButton(Size size) {
    return GradiantButton(
        buttonName: "Next",
        onPressed: () {
          if(valuefirst!=false) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WelcomeScreen()));
          }else{
             EasyLoading.showToast("Please approve first", toastPosition: EasyLoadingToastPosition.bottom, duration: const Duration(seconds: 3));

          }
        });
  }

}
