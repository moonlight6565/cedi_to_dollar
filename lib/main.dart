import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _convertToCedi() {
    final double? amount = double.tryParse(_controller.text);
    if (amount == null) {
      setState(() {
        _result = 'Please enter a valid number';
      });
      return;
    }
    final double ghs = amount * 10.80;
    setState(() {
      _result = 'USD $amount = \n GHS ${ghs.toStringAsFixed(2)} ';
    });
  }

  void _convertToDollar() {
    final double? amount = double.tryParse(_controller.text);
    if (amount == null) {
      setState(() {
        _result = 'Please enter a valid number';
      });
      return;
    }
    final double usd = amount / 10.80;
    setState(() {
      _result = 'GHS $amount = \nUSD ${usd.toStringAsFixed(2)} ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E6FD),
      appBar: AppBar(
        title: const Text('Cedi TO Dollar'),
        titleTextStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Use'),
                  content: const Text(
                    '1. Enter amount\n\n2. Click on "To Cedi 🇬🇭" to convert from USD to GHS or "To Dollar 🇺🇸" to convert from GHS to USD.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        backgroundColor: const Color(0xFF162660),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF162660),
                Color(0xFF2D4A9E),
                Color(0xFF162660),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  const BoxShadow( 
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Exchange Rate: 1 USD = 10.80 GHS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF162660),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E4D1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF162660),
                    width: 1,
                  ),
                ),
                child: Text(
                  _result.isEmpty ? '0.00' : _result,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(
                color: Color(0xFF162660),
                fontSize: 18,
              ),
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter amount',
                labelStyle: const TextStyle(
                  color: Color(0xFF162660),
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.attach_money,
                  color: Color(0xFF162660),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF162660),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF162660),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF162660),
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  color: const Color(0xFF162660),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _result = '';
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _convertToDollar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF162660),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Text(
                    '🇺🇸',
                    style: TextStyle(fontSize: 20),
                  ),
                  label: const Text(
                    'To Dollar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _convertToCedi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF162660),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Text(
                    '🇬🇭',
                    style: TextStyle(fontSize: 20),
                  ),
                  label: const Text(
                    'To Cedi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
