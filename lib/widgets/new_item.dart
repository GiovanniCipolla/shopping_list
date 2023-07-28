import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';

import '../models/category.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItemScreen> {

  final _formKey = GlobalKey<FormState>();
  var enteredName = '';
  var quantity = 1;
  var selectedCategory = categories[Categories.vegetables];

 void _saveItem() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    Navigator.of(context).pop(
      GroceryItem(
        name: enteredName,
        quantity: quantity,
        category: selectedCategory!,
        id: DateTime.now().toString(),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) => (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length >= 50)
                    ? 
                    'Must be between 1 and 50 characters'
                    : null,
                onSaved: (value) => enteredName = value!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: quantity.toString(),
                      validator: (value) => (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.parse(value) <= 0 )
                          ? 'Must be a valid, number positive integer. '
                          : null,
                      onSaved: (value) => quantity = int.parse(value!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedCategory,
                      items: [
                        for (final item in categories.entries)
                          DropdownMenuItem(
                            value: item.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: item.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(item.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(
                        () {
                          selectedCategory = value;
                        },
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
