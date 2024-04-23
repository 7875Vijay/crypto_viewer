
import 'package:crypto_viewer/custome_component_style/box_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class CtmDrawer extends StatelessWidget {
  const CtmDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   child: Text(
          //     'Drawer Header',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 24,
          //     ),
          //   ),
          // ),

          ListTile(
            leading: Icon(Icons.explore, color: Colors.blue[900]),
            title: Text("Lookup"),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: Icon(Icons.wallet, color: Colors.blue[900]),
            title: Text("Trade Wallet"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.wallet, color: Colors.blue[900]),
            title: Text("Share Wallet"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue[900]),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading:
            Icon(CupertinoIcons.profile_circled, color: Colors.blue[900]),
            title: Text("Portfolio"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(CupertinoIcons.news, color: Colors.blue[900]),
            title: Text("Market News"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue[900]),
            title: Text("Logout"),
            onTap: () async{

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor:Colors.orange[700],
                  title: const Text("Alert", style: TextStyle(color: Colors.white),),
                  content: const Text("Are you sure want to sign out?", style: TextStyle(color: Colors.white)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async{
                        //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()));
                        await AuthenticationHelper().signOut(context);
                        //await AuthenticationHelper().isAuthenticated(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("okay"),
                        decoration: BoxDecoration(
                          color: Colors.orange[700]!,
                          borderRadius: BorderRadius.circular(25.0),
                          border: BoxDecoratinStyes.CustomeBorder,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange[200]!,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                            BoxShadow(
                              color: Colors.orange[500]!,
                              offset: Offset(3.0, 4.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text("Cancel"),
                        decoration: BoxDecoration(
                          color: Colors.orange[700]!,
                          borderRadius: BorderRadius.circular(25.0),
                          border: BoxDecoratinStyes.CustomeBorder,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange[200]!,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                            BoxShadow(
                              color: Colors.orange[500]!,
                              offset: Offset(3.0, 4.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );


            },
          ),
        ],
      ),
    );
  }
}

