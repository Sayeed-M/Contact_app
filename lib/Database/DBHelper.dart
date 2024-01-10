import 'package:flutter/material.dart';
import 'package:save_it/Model/Contact.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  final String TABLE_NAME = 'Contacts';

  static Database? db_instance;

  Future<Database?> get db async {
    if (db_instance == null) {
      db_instance = await initDB();
    }
    return db_instance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "EDMtDEV.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);
    return db;
  }

  void onCreateFunc(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT);');
  }

  Future<List<Contact>> getContacts() async {
    var db_connection = await db;
    List<Map> list = await db_connection!.rawQuery('select * from $TABLE_NAME');
    List<Contact> contacts = <Contact>[];
    for (int i = 0; i < list.length; i++) {
      Contact contact = new Contact();
      contact.id = list[i]['id'];
      contact.name = list[i]['name'];
      contact.phone = list[i]['phone'];

      contacts.add(contact);
    }
    return contacts;
  }

  void AddNewContact(Contact contact) async {
    var db_connection = await db;
    String query =
        'insert into $TABLE_NAME(name,phone) values(\'${contact.name}\',\'${contact.phone}\')';
    await db_connection!.transaction((Transaction) async {
      return await Transaction.rawInsert(query);
    });
  }

  void updateContact(Contact contact) async {
    var db_connection = await db;
    String query =
        'update $TABLE_NAME set name=\'${contact.name}\',phone=\'${contact.phone}\' where id=${contact.id}';
    await db_connection!.transaction((Transaction) async {
      return await Transaction.rawQuery(query);
    });
  }

  void DeleteContact(Contact contact) async {
    var db_connection = await db;
    String query = 'delete from $TABLE_NAME where id=${contact.id}';
    await db_connection!.transaction((Transaction) async {
      return await Transaction.rawQuery(query);
    });
  }
}
