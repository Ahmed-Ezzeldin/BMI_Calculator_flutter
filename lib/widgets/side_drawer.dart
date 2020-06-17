import 'dart:io';
import '../pages/profile_page.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SideDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String imagePath;
  final bool isDark;
  final Function themeFun;
  SideDrawer(
      {this.username, this.email, this.imagePath, this.isDark, this.themeFun});

  exitFun(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 30,
                ),
                Text('  Exit?')
              ],
            ),
            content: Text(
              'Are you sure you want to exit?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                onPressed: () => exit(0),
              ),
              SizedBox(width: 30),
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  aboutFun(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationIcon: Image.asset(
              'assets/logo.png',
              height: 50,
              width: 50,
            ),
            applicationLegalese: '© 2020 BmiCalculator',
            applicationName: 'BMI Calculator',
            applicationVersion: 'v1.0',
            children: <Widget>[
              SizedBox(height: 50),
              Text('BMI Calculator is an android application that calculate your Body mass index (BMI) ' +
                  'value and give you a helpful advice to help reach the perfect body weight\n' +
                  'This app is development by flutter framework, Flutter is Google UI toolkit for' +
                  ' building beautiful natively compiled Android and IOS applications for mobile \n'),
              InkWell(
                child: Text('bmi.calculator.dev@gmail.com',
                    style: TextStyle(color: Colors.blue)),
                onTap: _launchURL,
              ),

              //textAlign: TextAlign.start,
            ],
          );
        });
  }

  void _launchURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'my.mail@example.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  ImageProvider getImage(String path) {
    if (path.length > 20) {
      return (imagePath == null)
          ? AssetImage('assets/profile.jpg')
          : FileImage(File(imagePath));
    } else {
      return (imagePath == null)
          ? AssetImage('assets/profile.jpg')
          : AssetImage(imagePath);
    }
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 170,
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                child: ListView(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: CircleAvatar(
                        radius: 53.0,
                        backgroundImage: getImage(imagePath),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      (username == null) ? 'No name entred' : username,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      (email == null) ? 'No email entred' : email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
                title: Text('Profile'),
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage(
                          name: username,
                          email: email,
                          image: imagePath,
                        ),
                      ));
                }),
            ListTile(
              title: Text('Rate app'),
              leading: Icon(
                Icons.star,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                LaunchReview.launch(androidAppId: 'com.iyaffle.kural');
              },
            ),
            ListTile(
              title: Text('Share'),
              leading: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Share.share('flutter is cool!');
              },
            ),
            ListTile(
              title: Text('About'),
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => aboutFun(context),
            ),
            SwitchListTile(
              title: Text('Dark Theme'),
              secondary: Icon(
                Icons.brightness_2,
                color: Theme.of(context).primaryColor,
              ),
              value: (isDark == null) ? false : isDark,
              activeColor: Theme.of(context).primaryColor,
              onChanged: themeFun,
            ),
            ListTile(
              title: Text('Exit',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              trailing: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => exitFun(context),
            ),
          ],
        ),
      ),
    );
  }
}
