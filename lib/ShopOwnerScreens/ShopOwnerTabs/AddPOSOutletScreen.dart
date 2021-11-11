import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/Utility/widget_helper.dart';



class AddPOSOutletScreen extends StatefulWidget {
  final String shopName;
  const AddPOSOutletScreen({Key? key, required this.shopName}) : super(key: key);

  @override
  _AddPOSOutletScreenState createState() => _AddPOSOutletScreenState();
}

class _AddPOSOutletScreenState extends State<AddPOSOutletScreen> {


  final databaseRef = FirebaseDatabase.instance.reference();

  TextEditingController _posUserNameTextEditingController = TextEditingController();
  TextEditingController _posPasswordTextEditingController = TextEditingController();
  TextEditingController _posContactNumberTextEditingController = TextEditingController();


  bool _posUserNameErrorMessage = false;
  bool _posPasswordErrorMessage = false;
  bool _pOSContactNumberErrorMessage = false;

  String shopNameErrorMessage = "POS User Name Cannot Be Blank";
  String shopUserPasswordErrorMessage = "POS Password Cannot Be Blank";
  String shopContactNumberErrorMessage = "POS Contact Number Cannot Be Blank";


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,50,10.0,100),
        child: Column(
          children: [
            Icon(Icons.shopping_basket,size: 60,),
            Text('ADD NEW POS OUTLET', textAlign: TextAlign.center, style: TextStyle(
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
                    WidgetHelper().CustomTextField("Enter POS User Name",Icons.perm_contact_cal_sharp,_posUserNameTextEditingController,_posUserNameErrorMessage,shopNameErrorMessage,context),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Enter POS User Password",Icons.remove_red_eye,_posPasswordTextEditingController,_posPasswordErrorMessage,shopUserPasswordErrorMessage,context),
                    SizedBox(height: 20,),
                    WidgetHelper().CustomTextField("Enter POS User Contact Number",Icons.phone,_posContactNumberTextEditingController,_pOSContactNumberErrorMessage,shopContactNumberErrorMessage,context),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        _posUserNameErrorMessage =  _posUserNameTextEditingController.text.isEmpty;
                        _posPasswordErrorMessage = _posPasswordTextEditingController.text.isEmpty;
                        _pOSContactNumberErrorMessage =  _posContactNumberTextEditingController.text.isEmpty;
                        setState(() {

                        });
                        if(((_posUserNameTextEditingController.text.isNotEmpty)
                            &&(_posPasswordTextEditingController.text.isNotEmpty ))&& (_posContactNumberTextEditingController.text.isNotEmpty)
                        ){
                          String ADDPOSOUTLETMESSAGE  = await FirebaseRepo().AddPOSOutlet(_posUserNameTextEditingController.text.trim(),_posPasswordTextEditingController.text.trim(),_posContactNumberTextEditingController.text.trim());
                          print(ADDPOSOUTLETMESSAGE);
                          Color messageColor = Colors.red;
                          if(ADDPOSOUTLETMESSAGE=="Congratulations! POS Outlet Added Successfully!"){
                            messageColor = Colors.green;
                          }
                          _posUserNameTextEditingController.text = "";
                          _posPasswordTextEditingController.text = "";
                          _posContactNumberTextEditingController.text  = "";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              "$ADDPOSOUTLETMESSAGE",
                              style: TextStyle(color:messageColor, letterSpacing: 0.5),
                            ),
                          ));
                        }
                        else{

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              "Please Fill in all the details Properly",
                              style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                            ),
                          ));
                          return;

                        }

                      },
                      child: Text('ADD POS Outlet',maxLines: 1,),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 130, vertical: 25),
                        textStyle: TextStyle(color: Colors.grey[100],fontSize: 20,fontFamily: 'MPLUSRounded1c'),
                      ),),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: Text('', textAlign: TextAlign.center, style: TextStyle(
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
    );
  }
}


