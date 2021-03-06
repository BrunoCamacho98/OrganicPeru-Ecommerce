import 'package:flutter/material.dart';
import 'package:organic/constants/theme.dart';

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key? key,
    required this.title,
    this.press,
  }) : super(key: key);

  final String title;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: title),
          const Spacer(),
          TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: kPrimaryColor,
              ),
              child: const Text(
                "More",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {}),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     margin: const EdgeInsets.only(right: kDefaultPadding / 4),
          //     height: 7,
          //     color: kPrimaryColor.withOpacity(0.2),
          //   ),
          // )
        ],
      ),
    );
  }
}
