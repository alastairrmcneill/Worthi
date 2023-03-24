import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';

// Show dialog to add historical entry to an account
showAddEntryDialog(BuildContext context, Account account) {
  TextEditingController _depositedController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();
  TextEditingController _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  late DateTime _date;
  DateTime? _pickedStartDate;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showDeposited = false;

  Future _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    account.updateBalance(
      date: Timestamp.fromDate(_date),
      deposited: account.type == AccountTypes.investment ? double.parse(_depositedController.text.trim()) : null,
      value: double.parse(_balanceController.text.trim()),
    );
    account.sortHistory();

    await AccountDatabase.updateAccount(
      context,
      newAccount: account,
    ).whenComplete(() => Navigator.pop(context));
  }

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
              // Title
              Text(
                'Add Entry',
                style: Theme.of(context).textTheme.headline6!.copyWith(color: MyColors.darkAccent),
              ),
              const SizedBox(height: 20),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    account.type == AccountTypes.investment ? NumberInputField(textEditingController: _depositedController, hintText: 'Total Deposited') : SizedBox(),
                    account.type == AccountTypes.investment ? const SizedBox(height: 10) : const SizedBox(),
                    NumberInputField(textEditingController: _balanceController, hintText: 'Total Balance'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _dateController,
                      style: const TextStyle(color: MyColors.background),
                      readOnly: true,
                      onTap: () async {
                        _pickedStartDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (_pickedStartDate != null) {
                          String formattedDate = DateFormat('dd/MM/yyyy').format(_pickedStartDate!);

                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                      },
                      onSaved: (value) {
                        _date = DateFormat('dd/MM/yyyy').parse(_dateController.text);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Submit form button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _submitForm();
                  },
                  child: Text('Add'),
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
