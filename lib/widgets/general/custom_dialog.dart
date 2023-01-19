import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/widgets/widgets.dart';

showAddEntryDialog(BuildContext context, Account account) {
  TextEditingController _depositedController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();
  TextEditingController _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  late DateTime _date;
  DateTime? _pickedStartDate;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showDeposited = false;
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
                'Add Entry',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  account.updateBalance(
                    date: _date,
                    deposited: account.type == AccountTypes.investment ? double.parse(_depositedController.text.trim()) : null,
                    value: double.parse(_balanceController.text.trim()),
                  );

                  await AccountDatabase.updateAccount(
                    context,
                    newAccount: account,
                  ).whenComplete(() => Navigator.pop(context));
                },
                child: Text('Add'),
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

showEditEntryDialog(BuildContext context, Account account, int index) {
  TextEditingController _depositedController = TextEditingController(text: (account.history[index][AccountFields.deposited] as double?).toString());
  TextEditingController _balanceController = TextEditingController(text: (account.history[index][AccountFields.value] as double).toString());
  TextEditingController _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format((account.history[index][AccountFields.date] as Timestamp).toDate()));
  late DateTime _date;
  DateTime? _pickedStartDate;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showDeposited = false;
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
                'Edit Entry',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  account.history[index] = {
                    AccountFields.date: _date,
                    AccountFields.deposited: account.type == AccountTypes.investment ? double.parse(_depositedController.text.trim()) : null,
                    AccountFields.value: double.parse(_balanceController.text.trim()),
                  };

                  await AccountDatabase.updateAccount(
                    context,
                    newAccount: account,
                  ).whenComplete(() => Navigator.pop(context));
                },
                child: Text('Confirm'),
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
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextInputField(textEditingController: _nameController, hintText: 'Name'),
                    const SizedBox(height: 20),
                    ElevatedButton(
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
