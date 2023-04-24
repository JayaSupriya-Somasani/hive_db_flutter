import 'package:flutter/material.dart';
import 'package:hive_db_flutter/first_screen.dart';
import 'package:hive_db_flutter/second_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // here we are initializing the hive database
  await Hive.initFlutter();

  //here we are opening the box , if it doesn't exist then it will be created
  await Hive.openBox('shopping_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        FirstScreen.routeName: (context) => FirstScreen(),
        SecondScreen.routeName: (context) => SecondScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Map<String, dynamic>> _items = [];

  //here we will moving to the previously opened box
  final _shoppingBox = Hive.box('shopping_box');

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    final data = _shoppingBox.keys.map((key) {

      //here we will retrieve the item by using key. This will be iterated each time by using keys
      final item = _shoppingBox.get(key);
      return {'key': key, 'name': item['name'], 'quantity': item['quantity']};
    }).toList();      // here we are converting the data into list
    setState(() {
      _items = data.reversed.toList();
      print("data is ${_items.length}");
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {

    //Adding new item into the box of hive
    await _shoppingBox.add(newItem);
    refreshData();
  }

  Future<void> _updateItem(int itemKey,Map<String, dynamic> item) async {

    //Updating the item in the box by using key
    await _shoppingBox.put(itemKey, item);
    refreshData();
  }
  Future<void> _deleteItem(int itemKey) async {

    //Deleting the box item by using key
    await _shoppingBox.delete(itemKey);
    refreshData();

    //After deleting the item then we will display the snack bar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An item has been deleted..")));
  }

  void _showForm(BuildContext ctx, int? itemKey) async {

    //if the key is not null then we will get existing data from the list that we are stored it previously.
    if(itemKey!=null){
      final existingItem=_items.firstWhere((element) => element['key']==itemKey);
      _nameController.text=existingItem['name'];
      _quantityController.text=existingItem['quantity'];
    }
    showModalBottomSheet(
        context: ctx,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "Item Name"),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(hintText: "Quantity"),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: () async {
                        if(itemKey==null){
                          _createItem({
                            "name": _nameController.text,
                            'quantity': _quantityController.text
                          });
                        }
                        if(itemKey!=null){
                          _updateItem(itemKey, {
                            'name':_nameController.text.trim(),
                            'quantity':_quantityController.text.trim(),
                          });
                        }
                        print(
                            "Data available in hive db ${_shoppingBox.length} ");
                        _nameController.text = '';
                        _quantityController.text = '';
                        Navigator.of(context).pop();
                      },
                      child:  Text(itemKey==null? "Create New" : 'Update')),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, index) {
          final currentItem = _items[index];
          return Card(
            color: Colors.orange.shade100,
            margin: const EdgeInsets.all(8),
            elevation: 4,
            child: ListTile(
              title: Text(currentItem['name']),
              subtitle: Text(currentItem['quantity'].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => _showForm(context, currentItem['key']),
                      icon: const Icon(Icons.edit)),
                  IconButton(onPressed: () =>_deleteItem(currentItem['key']), icon: const Icon(Icons.delete))
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
