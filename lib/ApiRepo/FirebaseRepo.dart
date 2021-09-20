import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseRepo {
  final String SHOP_NAME = 'Aflatoon General Store';

  ///Shop Keeper Methods & POS User API CALLS
  AddPOSOutlet(){}

  RemovePOSOutlet(){}

  AddStock(String ProductName,String amountOFSKU){

  }

  RemoveStock(String ProductName,String amountOFSKU) async {

  }

  AddNewProduct(String ProductName,String ProductSKU,String ProductPrice,String ProductBarCode){

  }

  RemoveProduct(String ProductName,String ProductSKU,String ProductPrice,String ProductBarCode){

  }


  Future<Map> fetchInventory() async {
    Map productNameList = {};
    print("Fetching Inventory");
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/Tookie Pan Bidi Shop").get();
      //Doc id 2 is for Products
      var a = querySnapshot.docs[2];
      productNameList = Map<String, dynamic>.from(a.data() as Map<String,dynamic>);
      for(int i = 0;i<productNameList.length;i++){
        print("Product Name :"+productNameList[i.toString()]["ProductName"]);
      }
      print(a.data());
      print(a.data().runtimeType);
    }catch(e){
      print(e.toString());
    }
    return productNameList;
  }

  fetchProductDetails(String productName) async {
    print("Fetching Product Details");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/Aflatoon General Store/Products/$productName").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      //Product p = Product.fromJson(a.data() as Map<String,dynamic>);
      print(a.data());
      print(a.data().runtimeType);
    }
  }

  fetchShopDetails() async {
    print("Fetching Shop Details");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/Aflatoon General Store").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      //Product p = Product.fromJson(a.data() as Map<String,dynamic>);
      print(a.data());
      print(a.data().runtimeType);
    }
  }

  Future<String> validatePOSUser(String userName , String password) async {
    Map posUserDetails = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/Aflatoon General Store").doc("POSOutlets").collection("AandeRam").get();
    if (querySnapshot.docs.length == 0) {
      //doesnt exist
      print("No POS Outlet Found.");
      return "No POS Outlet Found.";
    }
    else{
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        //Check if Password is right;
        var a = querySnapshot.docs[i];
        //Product p = Product.fromJson(a.data() as Map<String,dynamic>);
        print(a.data());
        print(a.data().runtimeType);
        posUserDetails = Map<String, dynamic>.from(a.data() as Map<String,dynamic>);
        if(posUserDetails["POSPassword"] == password  ){
          print("Login Successful");
          return "Login Successful";
        }
        else{
          print("Wrong Password");
          return "Wrong Password";
        }
      }
    }
    print("SOMETHING WENT WRONG");
    return "Something Went Wrong";
  }

  validateShopUser(){

  }


  ///Admin Methods API CALLS
  AddShop(){}
  RemoveShop(){}
  SuspendShop(){}

  Future<List<DocumentSnapshot>> FetchListOfAllShops() async {
    final QuerySnapshot result = await await FirebaseFirestore.instance.collection('/ShopList').get();
    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) => print(data.id));
    return documents;
  }


  ////await Firestore.instance.collection('Stores').document(widget.currentUserUID).collection("Stores").getDocuments();

}
