import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:moolah/models/models.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/widgets/widgets.dart';

showAddAccountDialog(BuildContext context) {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _depositedController = TextEditingController();
  TextEditingController _balanceController = TextEditingController();
  TextEditingController _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  late DateTime _date;
  DateTime? _pickedStartDate;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _type = null;
  bool showDeposited = false;
  AlertDialog dialog = AlertDialog(
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
                'Create a new account to track',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextInputField(textEditingController: _nameController, hintText: 'Name'),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      hint: Text("Type"),
                      value: _type,
                      items: [
                        DropdownMenuItem<String>(value: AccountTypes.bank, child: Text(AccountTypes.bank)),
                        DropdownMenuItem<String>(value: AccountTypes.credit, child: Text(AccountTypes.credit)),
                        DropdownMenuItem<String>(value: AccountTypes.investment, child: Text(AccountTypes.investment)),
                        DropdownMenuItem<String>(value: AccountTypes.loan, child: Text(AccountTypes.loan)),
                        DropdownMenuItem<String>(value: AccountTypes.pension, child: Text(AccountTypes.pension)),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _type = value as String?;
                          showDeposited = value == AccountTypes.investment;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Required';
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    showDeposited ? NumberInputField(textEditingController: _depositedController, hintText: 'Deposited') : SizedBox(),
                    showDeposited ? const SizedBox(height: 10) : const SizedBox(),
                    NumberInputField(textEditingController: _balanceController, hintText: 'Balance'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        hintText: 'Date',
                      ),
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
                  await AccountDatabase.create(
                    context,
                    account: Account(
                      name: _nameController.text.trim(),
                      type: _type!,
                      history: [
                        {
                          AccountFields.date: _date,
                          AccountFields.deposited: _type == AccountTypes.investment ? double.parse(_depositedController.text.trim()) : null,
                          AccountFields.value: double.parse(_balanceController.text.trim()),
                        },
                      ],
                    ),
                  ).whenComplete(() => Navigator.pop(context));
                },
                child: Text('Create'),
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
      return dialog;
    },
  );
}
