import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

import 'new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});
  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> groceryItems = [];
  var _isLoanding = true;
  String? errore;

  @override
  void initState() {
    super.initState();
    print('prova stampa initstate');
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-67067-default-rtdb.firebaseio.com', 'shopping_list.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          errore = 'Error, try agains';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoanding = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;

        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        groceryItems = loadedItems;
        _isLoanding = false;
      });
    } catch (error) {
      setState(() {
        errore = 'Something went wrong';
      });
    }
  }

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(
      () {
        groceryItems.add(newItem);
      },
    );
  }

  void remove(GroceryItem item) async {
    setState(
      () {
        groceryItems.remove(item);
      },
    );

    final url = Uri.https('flutter-prep-67067-default-rtdb.firebaseio.com',
        'shopping_list/${item.id}.json');

    final index = groceryItems.indexOf(item);

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(
        () {
          groceryItems.insert(index, item);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('NO ITEM'),
    );

    if (_isLoanding) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errore != null) {
      content = Center(
        child: Text(errore!),
      );
    }

    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            remove(groceryItems[index]);
          },
          key: ValueKey(groceryItems[index].id),
          child: ListTile(
            //Ecco alcuni degli attributi comuni di ListTile:
            // leading: Un widget per visualizzare un'icona o un'immagine all'inizio della riga.
            // title: Il testo principale dell'elemento.
            // subtitle: Il testo secondario dell'elemento.
            // trailing: Un widget per visualizzare un'icona o un'immagine alla fine della riga.
            // onTap: Un'azione da eseguire quando l'utente tocca l'elemento.
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: () {
              _addItem(context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
