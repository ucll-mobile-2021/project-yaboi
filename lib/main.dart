import 'package:flutter/material.dart';

// Run app en gebruik de MaterialApp als root widget/wrapper voor rest van widgets binnen.
void main() =>
    runApp(MaterialApp(
      // home = een property, Scaffold = een widget.
      // Scaffold is een widget met appbar, body, en andere handige properties.
        home: Home(),
    ));

// Custom stateless widget. Door StatelessWidget te extenden kunnen we een eigen widget class maken.
// Stateless = de state van widget kan over tijd niet veranderen. Kan data bevatten, maar kan na initialisatie van widget niet veranderen.
// Statefull = omgekeerde van stateless.
// Custom widgets leveren re-usability.
// Als we code in custom stateless widgets verdelen, is het makkelijker voor flutter om changes te maken, indien code verandert.
// --> m.a.w. we moeten niet steeds een hot restart doen.
class Home extends StatelessWidget {
  @override
  // We overriden de build function van de StatelessWidget class waar we van overerven.
  Widget build(BuildContext context) {
    // Vergeet niet return te schrijven!
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cook Book'),
        centerTitle: true,
        backgroundColor: Colors.red[400],
      ),
      body: Center(
        child: Text(
          'Welcome to your cook book!',
          // Control + q opent manuel voor properties, widgets
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.grey[600],
            fontFamily: 'LobsterRegular',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('click'),
        // TODO
        onPressed: () {},
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
