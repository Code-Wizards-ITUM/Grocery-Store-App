// import 'package:flutter/material.dart';
// import 'package:grocery_store_app/screens/login_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/cart_provider.dart';
// import 'providers/order_provider.dart';
// import 'providers/user_provider.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CartProvider()),
//         ChangeNotifierProvider(create: (context) => OrderProvider()),
//         ChangeNotifierProvider(create: (context) => UserProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Grocery Store App',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: LoginScreen(), // Set MainScreen as the home screen
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:grocery_store_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Store App',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LoginScreen(),
    );
  }
}
