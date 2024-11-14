import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_calculator/home_page.dart';

class ChangeCurrency extends StatefulWidget {
  @override
  State<ChangeCurrency> createState() => _ChangeCurrencyState();
}

class _ChangeCurrencyState extends State<ChangeCurrency> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<String> results = [];
  List<String> currencySymbols = [
    "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS","USD", "AUD", "AWG", "AZN",
    "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL",
    "BSD", "BTN", "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY",
    "COP", "CRC", "CUP", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN",
    "ETB", "EUR", "FJD", "FKP", "FOK", "GEL", "GHS", "GIP", "GMD", "GNF",
    "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD",
    "IRR", "ISK", "JMD", "JPY", "JOD", "KES", "KGS", "KHR", "KPW", "KRW",
    "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LYD", "MAD", "MDL",
    "MGA", "MKD", "MMK", "MOP", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN",
    "NAD", "NGN", "NIO", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP",
    "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD",
    "SCR", "SDG", "SEK", "SGD", "SLL", "SOS", "SRD", "STN", "SZL", "THB",
    "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "UGX", "UAH", "UYU",
    "UZS", "VES", "VND", "VUV", "WST", "XAF", "XCD", "XOF", "XPF", "YER",
    "ZAR", "ZMW"
  ];
  @override
  void initState() {
    super.initState();
    _loadCurrencySymbol();
  }

  Future<void> _saveCurrencySymbol(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currencySymbol', symbol);
  }

  Future<void> _loadCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? savedSymbol = prefs.getString('currencySymbol');
      if (savedSymbol != null && currencySymbols.contains(savedSymbol)) {
        results = currencySymbols.where((symbol) => symbol == savedSymbol).toList();
      } else {
        results = []; // Clear results if no saved symbol or symbol not in list
      }
    });
  }

  Widget defaultBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Change Currency', style: TextStyle(color: Colors.white)),
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
          icon: Icon(Icons.search),
          color: Colors.white,
        ),
      ],
    );
  }

  Widget searchBar() {
    return SizedBox(
      width: 350,
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: searchController,
        autofocus: true,
        onChanged: searchCurrency,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search currency...',
          hintStyle: TextStyle(color: Colors.white54),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                isSearching = false;
                searchController.clear();
                results = []; // Clear results when search is cleared
              });
            },
          ),
        ),
      ),
    );
  }

  void searchCurrency(String searchQuery) {
    setState(() {
      searchQuery = searchQuery.toUpperCase();
      if (searchQuery.isNotEmpty) {
        results = currencySymbols
            .where((symbol) => symbol.startsWith(searchQuery))
            .toList();
      } else {
        results = [];
      }
    });
  }

  Future<void> _confirmCurrencySelection(String currency) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0d3b79),
          title: Text('Confirm Currency Selection', style: TextStyle(color: Colors.white)),
          content: Text('Are you sure you want to select $currency as your currency?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(context).pop();
                await _saveCurrencySymbol(currency);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: '')),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0d3b79),
          title: isSearching ? searchBar() : defaultBar(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView.separated(
        itemCount: isSearching ? results.length : currencySymbols.length,
        itemBuilder: (context, index) {
          String currency = isSearching ? results[index] : currencySymbols[index];
          return ListTile(
            title: Text(currency),
            onTap: () => _confirmCurrencySelection(currency),
          );
        },
        separatorBuilder: (context, index) => Divider(), // Add a separator between items
      ),
    );
  }
}
