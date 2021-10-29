import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final BuildContext context;
  final String titleText;
  final bool isAppTitle;

  Header(
      {Key? key,
      required this.context,
      required this.titleText,
      this.isAppTitle: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleText,
        style: TextStyle(
            fontFamily: isAppTitle ? "Signatra" : "",
            color: Colors.white,
            fontSize: isAppTitle ? 50.0 : 22.0),
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

AppBar header(
    {required BuildContext context,
    required String titleText,
    bool isAppTitle = false,
    bool keepBackButton = true}) {
  return AppBar(
    automaticallyImplyLeading: keepBackButton,
    title: Text(
      titleText,
      style: TextStyle(
          fontFamily: isAppTitle ? "Signatra" : "",
          color: Colors.white,
          fontSize: isAppTitle ? 50.0 : 22.0),
    ),
    centerTitle: isAppTitle ? false : true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
