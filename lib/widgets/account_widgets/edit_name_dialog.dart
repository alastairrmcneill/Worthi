import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';

// Dialog box to edit name of account
showEditNameDialog(BuildContext context, Account account) {
  TextEditingController _nameController = TextEditingController(text: account.name);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AlertDialog alert = AlertDialog(
    scrollable: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    content: StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Name',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: MyColors.background),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextInputField(textEditingController: _nameController, hintText: 'Name'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();
                          Account newAccount = account.copy(name: _nameController.text.trim());

                          await AccountDatabase.updateAccount(
                            context,
                            newAccount: newAccount,
                          ).whenComplete(() => Navigator.pop(context));
                        },
                        child: Text('Update'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
