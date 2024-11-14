import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_calculator/change_currency.dart';
import 'package:tip_calculator/textfield_container.dart';
import 'package:tip_calculator/textfield_second_container.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController billController = TextEditingController();
  TextEditingController splitController = TextEditingController(text: '0');
  TextEditingController tipController = TextEditingController(text: '0');
  String currencySymbol = 'USD'; // Default currency symbol
  @override
  void initState() {
    super.initState();
    _loadCurrencySymbol();
  }

  void _loadCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currencySymbol = prefs.getString('currencySymbol') ?? 'USD';
      print('Loaded Currency Symbol: $currencySymbol'); // Debug statement
    });
  }

  void _calculate(BuildContext context) {
    var billStr = billController.text;
    var splitStr = splitController.text;
    var tipStr = tipController.text;

    double? billTotal = _parseDouble(billStr);
    double? split = _parseDouble(splitStr);
    double? tipPercentage = _parseDouble(tipStr);
    if (billTotal == null || billTotal <= 0) {
      _showError(context, 'Please enter a valid bill amount.');
      return;
    }

    if (split == null || split <= 0) {
      split = 1.0;
    }

    if (tipPercentage == null || tipPercentage < 0) {
      tipPercentage = 0.0;
    }

    double tipAmount = billTotal * (tipPercentage / 100);
    double totalBillWithTip = billTotal + tipAmount;
    double resultPerPerson = totalBillWithTip / split;

    _showResult(context, resultPerPerson, totalBillWithTip, tipAmount);
  }

  double? _parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF0d3b79),
          content: Text(message, style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showResult(BuildContext context, double resultPerPerson, double totalBillWithTip, double tipAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0d3b79),
          title: const Text(
            'Result',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Bill (including tip): ${currencySymbol} ${totalBillWithTip.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Tip Amount: ${currencySymbol} ${tipAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Amount Per Person: ${currencySymbol} ${resultPerPerson.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 25,),
              Text(
                'Tip & Split',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
              ),
             IconButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeCurrency()));
             }, icon: Icon(Icons.currency_exchange,color: Colors.white,))
            ],
          ),
          backgroundColor: const Color(0xFF0d3b79),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFieldContainer(
                text: 'Bill Total (${currencySymbol})',
                controller: billController,
                height: 100,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextFieldSecondContainer(
                        text: 'Split Among',
                        controller: splitController,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFieldSecondContainer(
                        text: 'Tip(%)',
                        controller: tipController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _calculate(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF0d3b79),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
