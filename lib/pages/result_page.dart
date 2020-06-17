import './tabs/list_tab.dart';
import './tabs/result_tab.dart';
import './tabs/chart_tab.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> dataMap;
  ResultPage(this.dataMap);
  @override
  State<StatefulWidget> createState() {
    return _ResultPageState();
  }
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Map<String, dynamic> dataMap;
  @override
  void initState() {
    dataMap = widget.dataMap;
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title: Text('Resault'),
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3.0,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.content_paste,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.history,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.chat,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(controller: tabController, children: [
          ResultTab(dataMap, tabController),
          ListTab(),
          ChartTab(),
        ]),
      ),
    );
  }
}
