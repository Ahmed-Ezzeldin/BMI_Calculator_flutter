import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class GenderCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final Function onClick;
  final double iconSize;
  GenderCard({
    @required this.icon,
    @required this.color,
    @required this.onClick,
    @required this.label,
    this.iconSize = 60,
  });
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onClick,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: iconSize,
          ),
          SizedBox(height: 10),
          TextLabel(
            text: label,
          )
        ],
      ),
    );
  }
}
