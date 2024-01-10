import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:save_it/Database/DBHelper.dart';
import 'package:save_it/Model/Contact.dart';

import 'contact_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact contact = new Contact();
  late String name, phone;

  final Scaffoldkey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Scaffoldkey,
      appBar: new AppBar(
        title: Text('Create Contact'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.view_list),
            tooltip: 'View List',
            onPressed: () {
              startContactList();
            },
          )
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Name'),
                validator: (val) => val!.length == 0 ? "Enter your Name" : null,
                onSaved: (val) => this.name = val!,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Phone'),
                validator: (val) =>
                    val!.length == 0 ? "Enter your Phone" : null,
                onSaved: (val) => this.phone = val!,
              ),
              new Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: new ElevatedButton(
                    onPressed: submitContact, child: Text("ADD NEW CONTACT")),
              ),
              Text(
                '⚡By Mohd Sayeed⚡',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startContactList() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new MyContactList()));
  }

  void submitContact() {
    if (this.formKey.currentState!.validate()) {
      formKey.currentState?.save();
    } else {
      return null;
    }
    var contact = Contact();
    contact.name = name;
    contact.phone = phone;
    var dbhelper = DBHelper();
    dbhelper.AddNewContact(contact);
    Fluttertoast.showToast(
        msg: 'saved Contact',
        toastLength: Toast.LENGTH_SHORT,
        webBgColor: '#FFFFFF');
  }
}
