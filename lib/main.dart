import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'dart:async';
import './pages/splash_page.dart';
import './widgets/widgets.dart';
import './pages/result_page.dart';
import './models/calculator.dart';
import './widgets/gender_card.dart';
import './widgets/side_drawer.dart';

void main() {
  return runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => (isDark) ? darkTheme : lightTheme,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: SplashPage(),
        );
      },
    );
  }
}

bool isDark = false;
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepOrange,
  accentColor: Colors.deepPurple,
  primaryColorLight: Colors.blueGrey[400],
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  accentColor: Colors.blueGrey[700],
  primaryColor: Colors.teal[700],
  primaryColorLight: Colors.blueGrey[400],
);

// //=======================================================================================
// //=============================================================================================  HomePage
// //=======================================================================================

class HomePage extends StatefulWidget {
  final String username;
  final String email;
  final String imagePath;
  HomePage({this.username, this.email, this.imagePath});
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int height;
  int weight;
  int age;
  String gender;
  String username;
  String userEmail;
  String imgPath;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    loadDataFun();
    Timer(Duration(milliseconds: 10), () {
      setUsername();
    });
    super.initState();
  }

  void setUsername() {
    setState(() {
      username = (widget.username == null) ? username : widget.username;
      userEmail = (widget.email == null) ? userEmail : widget.email;
      imgPath = (widget.imagePath == null) ? imgPath : widget.imagePath;
    });
    saveDataFun();
  }

  Future loadDataFun() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      height = preferences.getInt('height');
      weight = preferences.getInt('weight');
      age = preferences.getInt('age');
      gender = preferences.getString('gender');
      username = preferences.getString('username');
      userEmail = preferences.getString('userEmail');
      imgPath = preferences.getString('imagePath');
    });
  }

  Future saveDataFun() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt('height', height);
    preferences.setInt('weight', weight);
    preferences.setInt('age', age);
    preferences.setString('gender', gender);
    preferences.setString('username', username);
    preferences.setString('userEmail', userEmail);
    preferences.setString('imagePath', imgPath);
    height = preferences.getInt('height');
    weight = preferences.getInt('weight');
    age = preferences.getInt('age');
    gender = preferences.getString('gender');
    username = preferences.getString('username');
    userEmail = preferences.getString('userEmail');
    imgPath = preferences.getString('imagePath');
  }

  calculateFun() {
    if (gender == null) {
      _showSnackBar();
    } else {
      Calculator calculator = Calculator(
        height: (height == null) ? 175 : height,
        weight: (weight == null) ? 75 : weight,
        age: (age == null) ? 25 : age,
        gender: gender,
      );
      calculator.getBMIFun();
      calculator.getResultFun();

      Map<String, dynamic> dataMap = {
        'bmi': calculator.bmi.toStringAsFixed(2),
        'title': calculator.resultTitle,
        'description': calculator.resultDescription,
        'color': calculator.color,
        'height': calculator.height,
        'weight': calculator.weight,
        'age': calculator.age,
        'gender': calculator.gender,
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ResultPage(dataMap);
          },
        ),
      );
    }
  }

  void changeThemeFun(bool value) {
    setState(() {
      isDark = value;
      print(isDark);
    });
    (isDark)
        ? DynamicTheme.of(context).setThemeData(darkTheme)
        : DynamicTheme.of(context).setThemeData(lightTheme);
  }

  Future<bool> onWillPop() {
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
                Text('  Exit App!')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: SideDrawer(
        username: username,
        email: userEmail,
        imagePath: imgPath,
        isDark: isDark,
        themeFun: changeThemeFun,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('BMI Calculator'),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? buildColumn(context)
            : _buildLandscape(context),
      ),
    );
  }

  //===================================================================================  Orientation portrait
  Widget buildColumn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                ReuseabilCard(
                  child: _buildMaleCard(),
                ),
                ReuseabilCard(
                  child: _buildFemaleCard(),
                ),
              ],
            ),
          ),
          ReuseabilCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextLabel(text: 'Height'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildArrowBackButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        TextNum(
                            text: (height == null)
                                ? 175.toString()
                                : height.toString()),
                        Text(
                          'cm',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ],
                    ),
                    buildArrowForwardButton(),
                  ],
                ),
                _buildSlider(context),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                ReuseabilCard(
                  child: _buildWeightCard(),
                ),
                ReuseabilCard(
                  child: _buildAgeCard(),
                ),
              ],
            ),
          ),
          BottomButton(
            buttonTitle: 'Calculate',
            buttonFun: () => calculateFun(),
          ),
        ],
      ),
    );
  }

  //===================================================================================  Orientation Landscape
  Widget _buildLandscape(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Row(
            children: <Widget>[
              ReuseabilCard(child: _buildWeightCard()),
              ReuseabilCard(child: _buildMaleCard()),
              ReuseabilCard(child: _buildFemaleCard()),
              ReuseabilCard(child: _buildAgeCard()),
            ],
          ),
        ),
        Expanded(
            child: Row(
          children: <Widget>[
            ReuseabilCard(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextLabel(text: 'Height:     '),
                      Text(
                        height.toString(),
                        style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextLabel(text: ' cm'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(width: 5),
                      buildArrowBackButton(),
                      Expanded(child: _buildSlider(context)),
                      buildArrowForwardButton(),
                      SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(6.0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Calculate',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => calculateFun(),
                ),
              ),
            )
          ],
        ))
      ],
    ));
  }

  //===================================================================================  Widgets

  GenderCard _buildFemaleCard() {
    return GenderCard(
      icon: FontAwesomeIcons.female,
      color: (gender == 'female ♀')
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorLight,
      label: 'Female',
      onClick: () {
        setState(() {
          gender = 'female ♀';
          saveDataFun();
        });
      },
    );
  }

  GenderCard _buildMaleCard() {
    return GenderCard(
      icon: FontAwesomeIcons.male,
      color: (gender == 'male ♂')
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorLight,
      label: 'Male',
      onClick: () {
        setState(() {
          gender = 'male ♂';
          saveDataFun();
        });
      },
    );
  }

  Column _buildAgeCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextLabel(text: 'Age'),
        TextNum(
          text: (age == null) ? 25.toString() : age.toString(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RoundButton(
              buttonIcon: FontAwesomeIcons.minus,
              buttonFun: () {
                setState(() {
                  if (age == null) {
                    age = 24;
                  } else {
                    saveDataFun();
                    age--;
                  }
                });
              },
            ),
            RoundButton(
              buttonIcon: FontAwesomeIcons.plus,
              buttonFun: () {
                setState(() {
                  if (age == null) {
                    age = 26;
                  } else {
                    saveDataFun();
                    age++;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Column _buildWeightCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextLabel(text: 'Weight'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            TextNum(
              text: (weight == null) ? 75.toString() : weight.toString(),
            ),
            Text(
              ' kg',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RoundButton(
              buttonIcon: FontAwesomeIcons.minus,
              buttonFun: () {
                setState(() {
                  if (weight == null) {
                    weight = 74;
                  } else {
                    saveDataFun();
                    weight--;
                  }
                });
              },
            ),
            RoundButton(
              buttonIcon: FontAwesomeIcons.plus,
              buttonFun: () {
                setState(() {
                  if (weight == null) {
                    weight = 76;
                  } else {
                    saveDataFun();
                    weight++;
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Slider _buildSlider(BuildContext context) {
    return Slider(
        min: 120,
        max: 220,
        label: height.toString(),
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorLight,
        value: (height == null) ? 175 : height.toDouble(),
        onChanged: (double value) {
          saveDataFun();
          setState(() {
            height = value.toInt();
          });
        });
  }

  RoundButton buildArrowForwardButton() {
    return RoundButton(
        buttonIcon: Icons.arrow_forward_ios,
        buttonFun: () {
          if (height == null) {
            setState(() {
              height = 176;
            });
          } else {
            setState(() {
              height++;
            });
          }
        });
  }

  RoundButton buildArrowBackButton() {
    return RoundButton(
        buttonIcon: Icons.arrow_back_ios,
        buttonFun: () {
          if (height == null) {
            setState(() {
              height = 174;
            });
          } else {
            setState(() {
              height--;
            });
          }
        });
  }

  _showSnackBar() {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        action: SnackBarAction(
            label: 'OK', textColor: Colors.green, onPressed: () {}),
        content: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: Colors.orange,
            ),
            Text(' Select Gender First'),
          ],
        ),
      ),
    );
  }
}
