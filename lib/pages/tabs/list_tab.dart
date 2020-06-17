import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/bmi_data.dart';
import '../../models/database_helper.dart';
import 'package:toast/toast.dart';

class ListTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListTabState();
  }
}

class _ListTabState extends State<ListTab> {
  int count = 0;
  DatabaseHelper helper = DatabaseHelper();
  List<BmiData> bmiDataList;

  void updateListView() {
    final Future<Database> db = helper.initializeDatabase();
    db.then((database) {
      Future<List<BmiData>> bmiDatas = helper.getObjectListDB();
      bmiDatas.then((theList) {
        setState(() {
          bmiDataList = theList;
          count = theList.length;
        });
      });
    });
  }

  showToast(String message) {
    Toast.show(message, context, duration: 2);
  }

  showDeleteDailog(BmiData bmiData) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Delete !'),
            content: Text('Are you want to delete this recourd?'),
            actions: <Widget>[
              FlatButton(
                  child: Text('Yes',
                      style: TextStyle(color: Theme.of(context).accentColor)),
                  onPressed: () async {
                    await helper.deleteDB(bmiData.id);
                    updateListView();
                    Navigator.pop(context);
                    showToast('Record has been Deleted');
                  }),
              SizedBox(width: 30),
              FlatButton(
                child: Text('No',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  showDetailsDailog(BmiData bmiData) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${bmiData.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'BMI:       ( ${bmiData.bmi} )\n' +
                        'Height:    ${bmiData.height} cm\n' +
                        'Weight:    ${bmiData.weight} kg\n' +
                        'Gender:    ${bmiData.gender}\n' +
                        'Age:          ${bmiData.age} ⏳',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(),
                  SizedBox(),
                  Text('Time:  ${bmiData.date}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color getColorFun(double bmi) {
    if (bmi <= 15) {
      return Colors.yellow[500];
    } else if (bmi <= 16) {
      return Colors.lime[700];
    } else if (bmi <= 18.5) {
      return Colors.greenAccent;
    } else if (bmi <= 25) {
      return Colors.green[800];
    } else if (bmi <= 30) {
      return Colors.orange[700];
    } else if (bmi <= 35) {
      return Colors.redAccent;
    } else if (bmi <= 25) {
      return Colors.red;
    } else {
      return Colors.red[900];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bmiDataList == null) {
      bmiDataList = List<BmiData>();
      updateListView();
    } else if (bmiDataList.length == 0) {
      return Center(child: Text('No Record Found'));
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
            return Center(
              child: Container(
                width:
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.85,
                child: Card(
                  elevation: 4,
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getColorFun(
                            double.parse(bmiDataList[position].bmi)),
                        radius: 26,
                        child: Text(
                          bmiDataList[position].bmi,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      title: Text(
                        '${bmiDataList[position].title}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        bmiDataList[position].date,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).primaryColor,
                        onPressed: () =>
                            showDeleteDailog(bmiDataList[position]),
                      ),
                      onTap: () => showDetailsDailog(bmiDataList[position])),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
