import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseRepo {

  final String SHOP_NAME = 'Aflatoon General Store';

  ///Shop Keeper Methods & POS User API CALLS
  Future<String> AddPOSOutlet(String POSUserName,String POSPassword,String POSContactNumber) async{
    print("Adding New POS Outlet");
    bool posOutletAlreadyExists = await POSAlreadyExsists(POSUserName);
    print("POS Outlet Already Exists"+posOutletAlreadyExists.toString());
    if(posOutletAlreadyExists){
      return "Oh! No POS Outlet Already Exists";
    }
    else{
      //final QuerySnapshot result = await await FirebaseFirestore.instance.collection('/ShopList').get();
      await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("POSOutlets").doc("$POSUserName").set(
          {
            "POSUserName" : POSUserName,
            "POSUserContact" : POSContactNumber,
            "POSUserPassword":POSPassword,
          }).whenComplete((){ return "Congratulations! POS Outlet Added Successfully!";}).onError((error, stackTrace){ return "Oops ! Something Went Wrong!";});
    }
    return "Congratulations! POS Outlet Added Successfully!";
  }

  Future<bool> POSAlreadyExsists(String POSUserName) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").where("POSUserName", isEqualTo: "$POSUserName").get();
    if(querySnapshot.docs.isEmpty){
      return false;
    }
    return true;
  }

  RemovePOSOutlet(){}

  Future<String> AddStock (String ProductName,String amountOFSKU) async{
    String newAmountSKU = await FetchStockUnit(ProductName);
    int nStockValue = ((int.parse(newAmountSKU))+(int.parse(amountOFSKU)));
    print("New Stock Values : "+nStockValue.toString());
    amountOFSKU = nStockValue.toString();
    print("Adding $amountOFSKU Stock to $ProductName");
    await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").doc("$ProductName").update(
        {
          "ProductStock" : amountOFSKU,
        }).whenComplete((){ return "Congratulations! Stock Added Successfully!";}).onError((error, stackTrace){ return "Oops ! Something Went Wrong!";});
      //final QuerySnapshot result = await await FirebaseFirestore.instance.collection('/ShopList').get();
      return "Congratulations! Stock Added Successfully!";
  }


  Future<bool> RemoveStock (String ProductName,String amountOFSKU) async{
    String newAmountSKU = await FetchStockUnit(ProductName);
    int nStockValue = ((int.parse(newAmountSKU))-(int.parse(amountOFSKU)));
    print("New Stock Values : "+nStockValue.toString());
    amountOFSKU = nStockValue.toString();
    print("Removing $amountOFSKU Stock from $ProductName");
    await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").doc("$ProductName").update(
        {
          "ProductStock" : amountOFSKU,
        }).whenComplete((){
          print("Congratulations! Stock Removed Added Successfully!");
          return true;}).onError((error, stackTrace){ print("Oops ! Something Went Wrong!"); return false;});
      //final QuerySnapshot result = await await FirebaseFirestore.instance.collection('/ShopList').get();
      print("Congratulations! Stock Removed Added Successfully!");
      return true;
  }

  Future<String> FetchStockUnit(String ProductName) async{
    String StockUnit = "0";
    print("Fetching Stock Unit");
    Map<String, dynamic> productDetails;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").doc("$ProductName").get();
    print("The Product Details WE FETCHED"+documentSnapshot.data().toString());
    productDetails = Map<String, dynamic>.from(documentSnapshot.data() as Map<String,dynamic>);
    StockUnit = productDetails["ProductStock"];
    print("$ProductName contains "+productDetails["ProductStock"]+" of Stocks In Inventory");
    if(int.parse(StockUnit)<0){
      return "0";
    }else {
      return StockUnit;
    }
  }


  RemoveProduct(String ProductName,String ProductSKU,String ProductPrice,String ProductBarCode){}

  Future<Map> fetchInventory() async {
    Map productNameList = {};
    print("Fetching Inventory");
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").get();
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

  Future<Map<String,dynamic>> fetchShopDetails(String shopName) async {
    Map<String, dynamic> shopDetails;
    print("Fetching Shop Details");
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("/ShopList").doc('$shopName').get();
    print("The Shop Details WE FETCHED"+documentSnapshot.data().toString());
    shopDetails = Map<String, dynamic>.from(documentSnapshot.data() as Map<String,dynamic>);
    print(shopDetails["ShopAddress"]);
    return shopDetails;
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


  Future<bool> UnBlockShop(String shopName) async {
    FirebaseFirestore.instance.collection('/ShopList').doc('$shopName').update({"ShopStatus": "Running"}).then((_) {
      print("$shopName is Running Successfully Again");
      return true;
    });
    print("Cannot Unblock $shopName Due to Some Error");
    return false;
  }

  Future<bool> BlockShop(String shopName) async {
    FirebaseFirestore.instance.collection('/ShopList').doc('$shopName').update({"ShopStatus": "Blocked"}).then((_) {
      print("$shopName is Blocked Successfully");
      return true;
    });
    print("Cannot Block $shopName Due to Some Error");
    return false;
  }

  Future<List<DocumentSnapshot>?> FetchListOfBlockedShops() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('/ShopList').where("ShopStatus", isEqualTo: "Blocked").get();
    final List<DocumentSnapshot> documents = result.docs;
    if(documents.isEmpty){
      return null;
    }
    documents.forEach((data) => print(data.id));
    return documents;
  }

  Future<List<DocumentSnapshot>?> FetchListOfAllUnblockedShops() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('/ShopList').where("ShopStatus", isEqualTo: "Running").get();
    final List<DocumentSnapshot> documents = result.docs;
    if(documents.isEmpty){
      return null;
    }
    documents.forEach((data) => print(data.id));
    return documents;
  }

  Future<int> FetchNumberOfBlockedShops() async{
    print("Total Number of Blocked Shop");
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('/ShopList').where("ShopStatus", isEqualTo: "Blocked").get();
    if(result.docs.isNotEmpty){
      int length = result.docs.length;
      print("Total No Of Blocked :"+length.toString());
      return length;
    }
    else{
      return 0;
    }
  }

  Future<int> FetchNumberOfRunningShops() async{
    print("Total Number of Blocked Shop");
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('/ShopList').where("ShopStatus", isEqualTo: "Running").get();
    if(result.docs.isNotEmpty){
      int length = result.docs.length;
      print("Total No Of Running Shops :"+length.toString());
      return length;
    }
    else{
      return 0;
    }
  }

  Future<List<DocumentSnapshot>?> FetchListOfAllShops() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('/ShopList').get();
    final List<DocumentSnapshot> documents = result.docs;
    if(documents.isEmpty){
      return null;
    }
    documents.forEach((data) => print(data.id));
    return documents;
  }

  Future<String> AddNewShop(String shopName,String shopLoginName,String shopPassword,String shopContactNumber,String shopAddress) async {
    print("Adding New Shop ");
    bool shopAlreadyExists = await ShopAlreadyExsists(shopName);
    print("Shop Already Exists"+shopAlreadyExists.toString());
    if(shopAlreadyExists){
      return "Oh! No Shop Already Exists";
    }
    if(!shopAlreadyExists){
      //final QuerySnapshot result = await await FirebaseFirestore.instance.collection('/ShopList').get();
      FirebaseFirestore.instance.collection('/ShopList').doc('$shopName').set(
          {
            "ShopUserName" : shopName,
            "ShopLoginName" : shopLoginName,
            "ShopPassword" : shopPassword,
            "ShopContactNumber" : shopContactNumber,
            "ShopAddress" : shopAddress,
            "ShopStatus"  : "Running"
          }).then((value){
        print("Hola");
        return "Congratulations! Shop Added Successfully!";
      });
      return "Oops ! Something Went Wrong!";
    }
    return "Please Check Your Internet Connection!";
  }

  Future<bool> ShopAlreadyExsists(String shopName) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/ShopList").where("ShopName", isEqualTo: "$shopName").get();
    if(querySnapshot.docs.isNotEmpty){
      return true;
    }
    return false;
  }

  Future<bool> ProductAlreadyExsists(String productName) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").where("ProductName", isEqualTo: "$productName").get();
    if(querySnapshot.docs.isNotEmpty){
      return true;
    }
    return false;
  }

  Future<String> AddNewProduct(String productName,String productPrice,String productStock,String sellerContact,String productBarCode) async {
    print("Adding New Product");
    bool productAlreadyExists = await ProductAlreadyExsists(productName);
    print("Product Already Exists"+productAlreadyExists.toString());
    if(productAlreadyExists){
      return "Oh! No Product Already Exists";
    }
    else{
      //final QuerySnapshot result = await await FirebaseFirestore.instance.collection('/ShopList').get();
      await FirebaseFirestore.instance.collection("/ShopList").doc("Apunki Dukaan").collection("ProductList").doc("$productName").set(
          {
            "ProductName" : productName,
            "ProductStock" : productStock,
            "Product Price":productPrice,
            "SellerContact" : sellerContact,
            "ProductBarCode" : productBarCode,
          }).whenComplete((){ return "Congratulations! Product Added Successfully!";}).onError((error, stackTrace){ return "Oops ! Something Went Wrong!";});
    }
    return "Congratulations! Product Added Successfully!";
  }
  ////await Firestore.instance.collection('Stores').document(widget.currentUserUID).collection("Stores").getDocuments();
}