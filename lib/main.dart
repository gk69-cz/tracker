import 'dart:io';

import 'package:expensetracker/database/expense_database.dart';
import 'package:expensetracker/pages/about.dart';
import 'package:expensetracker/pages/home.dart';
import 'package:expensetracker/pages/report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize db
  await ExpenseDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendWise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        // Add a drawer button to the app bar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      // Define the drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
               child: Column(
              
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Row(
              children: [
                
                SizedBox(width: 10),
                Text(
                  'SpendWise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => selectedItem(context, 0),
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: const Text('Expence'),
              onTap: () => selectedItem(context, 1),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text('Report'),
              onTap: () => selectedItem(context, 2),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text('About'),
              onTap: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () => {exit(0)},
            ),
            // Add more list tiles for additional drawer items
          ],
        ),
      ),
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Spend Wise',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'A minimal expense tracker .',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
          ],
        )
        
    ),
    );
  }

  selectedItem(BuildContext context, int i) {
    switch (i) {
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Report(),
        ));

        break;
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Homepage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Homepagem(),
        ));
        break;
        case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AboutPage(),
        ));
        break;
      default:
    }
  }
}
