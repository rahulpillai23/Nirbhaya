import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirbhaya/bottom_screen.dart/contacts.dart';
import 'package:nirbhaya/components/PrimaryButton.dart';
import 'package:nirbhaya/db/db_services.dart';
import 'package:nirbhaya/model/contactsm.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({Key? key}) : super(key: key);

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  late DatabaseHelper databaseHelper;
  List<TContact>? contactList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    showContactList();
  }

  void showContactList() async {
    List<TContact> contacts = await databaseHelper.getContactList();
    setState(() {
      contactList = contacts;
      count = contacts.length;
    });
  }

  void deleteContact(TContact contact) async {
    int result = await databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact removed successfully");
      showContactList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFD8080),
        title: Text(
          'Trusted Contacts',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                title: "Add Trusted Contact",
                onPressed: () async {
                  bool? result = await Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(builder: (context) => ContactsPage()),
                  );
                  if (result != null && result) {
                    showContactList();
                  }
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    TContact contact = contactList![index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          contact.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(contact.number),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                FlutterPhoneDirectCaller.callNumber(
                                    contact.number);
                              },
                              icon: Icon(Icons.call, color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteContact(contact);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
