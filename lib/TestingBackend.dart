import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rdipos/ApiRepo/FirebaseRepo.dart';

class BackendTest extends StatefulWidget {
  const BackendTest({Key? key}) : super(key: key);

  @override
  _BackendTestState createState() => _BackendTestState();
}

class _BackendTestState extends State<BackendTest> {

  TextEditingController shopNameController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController stockUnitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: shopNameController,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      child: Text(
                          "ADD SHOP".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      child: Text(
                          "REMOVE SHOP".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      child: Text(
                          "REMOVE PRODUCT".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      child: Text(
                          "ADD PRODUCT".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      child: Text(
                          "ADD STOCK".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 1,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      child: Text(
                          "REMOVE STOCK".toUpperCase(),
                          style: TextStyle(fontSize: 14)
                      ),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                      onPressed: () => null
                  ),
                )
              ],
            ),
            SizedBox(height: 100,),
            ElevatedButton(
                child: Text(
                    "FETCH INVENTORY".toUpperCase(),
                    style: TextStyle(fontSize: 14)
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: Colors.red)
                        )
                    )
                ),
                onPressed: () => FirebaseRepo().fetchInventory()
            ),
            SizedBox(height: 10,),
            Text("aks;ka"),
            //
            body(FirebaseFirestore.instance.collection("/Aflatoon General Store").doc("Products").snapshots()),
          ],
        ),

        )
    );
  }

  Widget body(var stream) {
    return StreamBuilder(
        stream: stream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Text("Please Wait");
            default:
              if (snapshot.hasData) {
                print(snapshot.data!.docs.length);
                if (snapshot.data!.docs.length == 0) {
                  return Text("No record Found");
                }
                else {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(snapshot.data.toString());
                        //String name = snapshot.data!.docs[index].toString();
                        return Text('');
                      });
                }
              }
              else return Text("Getting Error");
          }
        }
    );
  }
}