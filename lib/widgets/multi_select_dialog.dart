import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final List<String> preSelectedItems;
  const MultiSelect({Key? key, required this.items, required this.preSelectedItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late List<String> _selectedItems;
  @override
  void initState() {
    super.initState();
    _selectedItems = widget.preSelectedItems;
  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        'Select Account Types',
        style: Theme.of(context).textTheme.headline6!.copyWith(color: MyColors.darkAccent),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListBody(
              children: widget.items
                  .map((item) => CheckboxListTile(
                        value: _selectedItems.contains(item),
                        title: Text(
                          item,
                          style: TextStyle(color: MyColors.darkAccent),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (isChecked) => _itemChange(item, isChecked!),
                        activeColor: MyColors.blueAccent,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
