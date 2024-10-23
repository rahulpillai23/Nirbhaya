import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nirbhaya/db/db_services.dart';
import 'package:nirbhaya/model/contactsm.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  void filterContact() {
    String searchTerm = searchController.text.toLowerCase();
    List<Contact> filteredContacts = contacts.where((contact) {
      String contactName = contact.displayName?.toLowerCase() ?? "";
      bool nameMatch = contactName.contains(searchTerm);

      bool phoneMatch = contact.phones?.any((phone) {
            String phoneNumber = flattenPhoneNumber(phone.value ?? "");
            String flattenedSearchTerm = flattenPhoneNumber(searchTerm);
            return phoneNumber.contains(flattenedSearchTerm);
          }) ??
          false;

      return nameMatch || phoneMatch;
    }).toList();

    setState(() {
      contactsFiltered = filteredContacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permission Required"),
            content: Text("Access to the contacts is denied by the user."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permission Required"),
            content: Text("Contacts permission is permanently denied."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void getAllContacts() async {
    List<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
      filterContact(); // Initial filter on contacts load
    });
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFD8080),
        title: Text(
          'Contacts',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search Contact",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          filterContact(); // Clear and update the filtered list
                        },
                      ),
                    ),
                    onChanged: (value) {
                      filterContact(); // Trigger filtering on text change
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: contactsFiltered.length,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = contactsFiltered[index];
                      return ListTile(
                        title: Text(contact.displayName ?? ""),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            contact.initials(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          if (contact.phones != null &&
                              contact.phones!.isNotEmpty) {
                            final String phoneNum =
                                contact.phones!.elementAt(0).value!;
                            final String name = contact.displayName!;
                            _addContact(TContact(phoneNum, name));
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Phone number of this contact does not exist");
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
