import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moolah/support/theme.dart';

// General two button dialog with custom shape
showTwoButtonDialog(BuildContext context, String text, String option1, AsyncCallback function1, String option2, VoidCallback function2) {
  Dialog alert = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Container(
      width: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            text,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: Theme.of(context).textTheme.headline6!.copyWith(color: MyColors.background),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(Colors.red)),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                function1();
              },
              child: Text(option1),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(Colors.grey)),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();

                function2();
              },
              child: Text(option2),
            ),
          ),
        ],
      ),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
