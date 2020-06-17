import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String text;
  TextLabel({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }
}

class TextNum extends StatelessWidget {
  final String text;
  TextNum({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 35,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class ReuseabilCard extends StatelessWidget {
  final Widget child;
  final int flex;
  ReuseabilCard({@required this.child, this.flex = 1});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border:
                Border.all(color: Theme.of(context).accentColor, width: 1.5)),
        margin: EdgeInsets.all(7.0),
        child: child,
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final IconData buttonIcon;
  final Function buttonFun;
  RoundButton({@required this.buttonIcon, @required this.buttonFun});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints: BoxConstraints.tightFor(
          height: 50,
          width: 50,
        ),
        //fillColor: Colors.blueGrey,
        child: Icon(
          buttonIcon,
          color: Theme.of(context).primaryColor,
          size: 26,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
            side: BorderSide(color: Theme.of(context).accentColor, width: 1.5)),
        onPressed: buttonFun);
  }
}

class BottomButton extends StatelessWidget {
  final String buttonTitle;
  final Function buttonFun;
  BottomButton({@required this.buttonTitle, @required this.buttonFun});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: buttonFun,
      fillColor: Theme.of(context).primaryColor,
      constraints: BoxConstraints.tightFor(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        buttonTitle,
        style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0),
      ),
    );
  }
}
