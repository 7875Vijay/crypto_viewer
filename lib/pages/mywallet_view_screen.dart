import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_viewer/custome_component_style/box_decoration.dart';


import '../custome_component_style/elevated_button_style.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  late double _screenWidth;
  late double _screenHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Accessing size after the first frame is drawn
      _screenWidth = MediaQuery.of(context).size.width;
      _screenHeight = MediaQuery.of(context).size.height;
      setState(() {}); // Rebuild the widget after getting the size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 300.0,
                width: _screenWidth,
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "assets/images/profile.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text("My wallet", style: TextStyle(fontSize: 25.0, color: Colors.white),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.history,color: Colors.white, size: 35,))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Available balance", style: TextStyle(fontSize: 25.0, color: Colors.white), ),
                              Padding(
                                padding: EdgeInsets.only(left: 80.0),
                                child: Row(
                                  children: [
                                    Text("\$ ", style: TextStyle(fontSize: 25.0, color: Colors.white),),
                                    Text("656823", style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),

                    Center(
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                border: BoxDecoratinStyes.CustomeBorder,
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: ElevatedButton(onPressed: (){},
                                style: CustomeElevatedButtonStyle.customeStyle(Colors.blue[900], Colors.white, Colors.white),
                                child: Text("Transfer", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),

                              ),
                            ),
                            const SizedBox(width: 10.0,),
                            Container(
                              width: 150.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  border: BoxDecoratinStyes.CustomeBorder,
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: ElevatedButton(onPressed: (){},
                                style: CustomeElevatedButtonStyle.customeStyle(Colors.blue[900], Colors.white, Colors.white),
                                child: Text("Withdraw", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                  width: _screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My coins",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey[900]),
                            ),
        
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: BoxDecoratinStyes.CustomeBorder,
                                boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                color: Colors.grey[300],
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(CupertinoIcons.add),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 300.0,
        
                        ),
                      ]
        
                    ),
                  ),
                ),
            ],
          ),
      );
  }
}
