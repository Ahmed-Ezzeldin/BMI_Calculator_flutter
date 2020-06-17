import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../widgets/widgets.dart';
import '../../models/bmi_data.dart';
import '../../models/database_helper.dart';

class ResultTab extends StatefulWidget {
  final Map<String, dynamic> dataMap;
  final TabController tabController;
  ResultTab(this.dataMap, this.tabController);
  @override
  State<StatefulWidget> createState() {
    return _ResultTabState();
  }
}

class _ResultTabState extends State<ResultTab> {
  Map<String, dynamic> dataMap;
  TabController tabController;
  DateTime dateTime;
  DatabaseHelper helper = DatabaseHelper();
  BmiData bmiData = BmiData('', '', '', '', '', '', '', '');

  @override
  void initState() {
    dataMap = widget.dataMap;
    tabController = widget.tabController;
    super.initState();
  }

  void _save() async {
    bmiData.bmi = dataMap['bmi'].toString();
    bmiData.title = dataMap['title'].toString();
    bmiData.description = dataMap['description'].toString();
    bmiData.height = dataMap['height'].toString();
    bmiData.weight = dataMap['weight'].toString();
    bmiData.age = dataMap['age'].toString();
    bmiData.gender = dataMap['gender'].toString();

    if (bmiData.id == null) {
      await helper.insertDB(bmiData);
    } else {
      await helper.updateDB(bmiData);
    }
  }

  addRecord() {
    dateTime = DateTime.now();
    setState(() {
      bmiData.date = DateFormat.yMMMd().add_jms().format(dateTime);
      _save();
    });
    tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            ReuseabilCard(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? buildPortrait(context)
                      : buildLandscape(context),
                ),
              ),
            ),
            BottomButton(
                buttonTitle: 'Re-calculate',
                buttonFun: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget buildPortrait(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildDataText(),
        buildResultText(),
        buildBmiText(),
        buildDescriptionText(),
        buildAddButton(context),
      ],
    );
  }

  Widget buildLandscape(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildDataText(),
            buildBmiText(),
          ],
        ),
        SizedBox(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildResultText(),
            Container(
              height: 100,
              width: 300,
              child: buildDescriptionText(),
            ),
          ],
        ),
        SizedBox(),
        SizedBox(),
        buildAddButton(context),
      ],
    );
  }

  Text buildDataText() {
    return Text(
      'Heigth:  ${dataMap['height']} cm\nWeight:  ${dataMap['weight']} kg\n' +
          'Age:        ${dataMap['age']} ⌛\nGender:  ${dataMap['gender']}',
      style: TextStyle(
          color: Colors.deepOrange, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Text buildResultText() {
    return Text(
      dataMap['title'],
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w900, color: dataMap['color']),
    );
  }

  Text buildBmiText() {
    return Text(
      dataMap['bmi'].toString(),
      style: TextStyle(
        fontSize: 50,
        color: Colors.deepPurple,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  TextLabel buildDescriptionText() => TextLabel(text: dataMap['description']);

  Container buildAddButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: RawMaterialButton(
        elevation: 7.0,
        constraints: BoxConstraints.tightFor(
          height: 55,
          width: 55,
        ),
        fillColor: Theme.of(context).accentColor,
        child: Icon(
          FontAwesomeIcons.plus,
          color: Theme.of(context).primaryColor,
          size: 26,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          Toast.show('Hold press to add Record', context);
        },
        onLongPress: addRecord,
      ),
    );
  }
}
