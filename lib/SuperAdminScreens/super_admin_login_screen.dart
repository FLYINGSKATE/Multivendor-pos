import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/SuperAdminScreens/super_admin_homepage_screen.dart';
import 'package:rdipos/Utility/widget_helper.dart';

class SuperAdminLoginPage extends StatefulWidget {
  const SuperAdminLoginPage({Key? key}) : super(key: key);

  @override
  _SuperAdminLoginPageState createState() => _SuperAdminLoginPageState();
}

class _SuperAdminLoginPageState extends State<SuperAdminLoginPage> {
  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _userNameTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  bool showUsernameErrorMessgae = false;
  bool showPasswordErrorMessage = false;

  String userErrorMessage = "Wrong Username";
  String passwordErrorMessage = "Wrong Password";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper().RdiAppBar(),
        body:SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,100,10.0,100),
        child: Column(
          children: [
            Icon(Icons.perm_contact_cal,size: 60,),
            Text('Admin Login', textAlign: TextAlign.center, style: TextStyle(
                color: Color.fromRGBO(38, 50, 56, 1),
                fontFamily: 'MPLUSRounded',
                fontSize: 40,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.bold,
                height: 1.400000028610228
            ),),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 0),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Username",Icons.perm_contact_cal_sharp,_userNameTextEditingController,showUsernameErrorMessgae,userErrorMessage),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Password",Icons.remove_red_eye,_passwordTextEditingController,showPasswordErrorMessage,passwordErrorMessage),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        //await databaseRef.child("Shops").orderByChild("Username").equalTo(_userNameTextEditingController.text).once().then((DataSnapshot snapshot){
                          //Map<dynamic, dynamic> values = snapshot.value;
                          //values.forEach((key,values) {
                            if("admin"==_passwordTextEditingController.text){
                              print("Admin Logged In Successfully");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => SuperAdminHomePage()));
                            }
                            else{
                              showPasswordErrorMessage = true;
                              setState(() {});
                            }
                          },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 150, vertical: 25),
                        textStyle: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                      ),),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: Text('Forgot Password ?', textAlign: TextAlign.center, style: TextStyle(
                color: Colors.black,
                fontFamily: 'MPLUSRounded',
                fontSize: 15,
                letterSpacing: 0.20000001788139343,
                fontWeight: FontWeight.w200,
                height: 1.400000028610228
            ),),)
          ],
        ),
      ),
    ));
  }
}