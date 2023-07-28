import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

import 'new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});
  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> groceryItems = [];
  Widget content = const Center(
    child: Text('NO ITEM'),
  );

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );
    if (newItem == null) {
      return null;
    }
    setState(
      () {
        groceryItems.add(newItem);
      },
    );
  }

  void remove(GroceryItem item) {
    setState(
      () {
        groceryItems.remove(item);
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    if(groceryItems.isNotEmpty){
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
