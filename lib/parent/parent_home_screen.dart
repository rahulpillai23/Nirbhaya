import 'package:flutter/material.dart';
import 'package:nirbhaya/child/child_login_screen.dart';
import 'package:nirbhaya/utils/constants.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(),
            ),
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildLoginScreen(),
                    ),
                  );
                },
                child: Text("SIGN OUT"),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("SELECT CHILD"),
        actions: [
          IconButton(
            onPressed: () {
              // Call the logout function
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 3, // Replace with actual count
        itemBuilder: (BuildContext context, int index) {
          // Placeholder data, replace with actual child data
          final childName = "Child $index";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Color.fromARGB(255, 250, 163, 192),
              child: ListTile(
                onTap: () {
                  // Placeholder action on child selection
                  // You can navigate to any screen or perform any action here
                },
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(childName),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
