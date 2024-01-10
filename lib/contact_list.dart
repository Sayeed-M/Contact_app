import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:save_it/Database/DBHelper.dart';
import 'package:save_it/Model/Contact.dart';

Future<List<Contact>> getContactsFromDB() async {
  var dbHelper = new DBHelper();
  Future<List<Contact>> contacts = dbHelper.getContacts();
  return contacts;
}

class MyContactList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyContactListState();
}

class MyContactListState extends State<MyContactList> {
  final controller_name = new TextEditingController();
  final controller_phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
            future: getContactsFromDB(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return new Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data![index].phone,
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.all(16.0),
                                      content: new Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              TextFormField(
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        '${snapshot.data![index].name}'),
                                                controller: controller_name,
                                              ),
                                              TextFormField(
                                                autofocus: false,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        '${snapshot.data![index].phone}'),
                                                controller: controller_phone,
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                      actions: <Widget>[
                                        new TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('CANCEL')),
                                        new TextButton(
                                            onPressed: () {
                                              var dbhelper = DBHelper();
                                              Contact contact = new Contact();
                                              contact.id =
                                                  snapshot.data![index].id;
                                              contact.name =
                                                  controller_name.text != ''
                                                      ? controller_name.text
                                                      : snapshot
                                                          .data![index].name;
                                              contact.phone =
                                                  controller_phone.text != ''
                                                      ? controller_phone.text
                                                      : snapshot
                                                          .data![index].phone;
                                              dbhelper.updateContact(contact);
                                              Navigator.pop(context);
                                              setState(() {
                                                getContactsFromDB();
                                              });
                                              Fluttertoast.showToast(
                                                  msg: ' Contact was Updated',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  webBgColor: '#FFFFFF');
                                            },
                                            child: Text('UPDATE')),
                                      ],
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.update,
                                  color: Colors.red,
                                )),
                            GestureDetector(
                                onTap: () {
                                  var dbhelper = DBHelper();
                                  dbhelper.DeleteContact(snapshot.data![index]);
                                  Fluttertoast.showToast(
                                      msg: 'Contact was deleted',
                                      toastLength: Toast.LENGTH_SHORT,
                                      webBgColor: '#FFFFFF');
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        );
                      });
                }
              }
              return new Container(
                alignment: AlignmentDirectional.center,
                child: new CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
