import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';
import 'package:rdipos/ApiRepo/payments.dart';
import 'package:rdipos/Utility/widget_helper.dart';

class CheckoutScreen extends StatefulWidget {
  final String shopName;
  final int price;

  const CheckoutScreen({Key? key,required this.shopName,required this.price}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  TextEditingController customerPhoneNumberTextEditingController = TextEditingController();
  TextEditingController customerEmailIdTextEditingController = TextEditingController();

  bool showEmailIdError = false;
  bool showPhoneNumberError = false;

  String emailIdErrorMessage = "Please Enter a Valid Email Address";
  String phoneNumberErrorMessage = "Please Enter a Valid Phone Number";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().RdiAppBar(context),
      body: Center(child:Container(
        width: MediaQuery.of(context).size.width/2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on_rounded,size: 60,),
            Text('Enter Customer Details', textAlign: TextAlign.center, style: TextStyle(
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
                    WidgetHelper().CustomPhoneNumberTextField("Enter Customer Phone Number",Icons.perm_contact_cal_sharp,customerPhoneNumberTextEditingController,showPhoneNumberError,phoneNumberErrorMessage),
                    WidgetHelper().CustomTextField("Enter Customer Email Id",Icons.email_outlined,customerEmailIdTextEditingController,showEmailIdError,emailIdErrorMessage),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        if(EmailValidator.validate(customerEmailIdTextEditingController.text.trim())){
                          if(customerPhoneNumberTextEditingController.text.trim().length>=10){
                            ///Navigate to Rayzor Pay & On Payment Success Navigate to Billing Section
                            String apiKey = await FirebaseRepo().fetchShopAPIKey(widget.shopName);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Webpayment(mobile:customerPhoneNumberTextEditingController.text.trim(),email: customerEmailIdTextEditingController.text.trim(),price: widget.price*100, name: 'AshrafK.Salim', shopName:widget.shopName, shopApiKey: apiKey ,)),);
                          }
                          else{
                            showPhoneNumberError = true;
                            setState(() {});
                          }
                        }
                        else{
                          showEmailIdError = true;
                          setState(() {});
                        }
                      },
                      child: Text('Proceed For Payment',maxLines: 1,),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 25),
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
      )),
    );
  }
}
