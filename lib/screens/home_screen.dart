import 'package:flutter/material.dart';
import '../services/currency_service.dart';

// The main home screen
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Service instance for currency operations.
  final CurrencyService _currencyService = CurrencyService();

  // Controller for the amount input text field.
  final TextEditingController _controller = TextEditingController();

  // Stores the conversion result text.
  String _result = '';

  // Stores the fetched exchange rate (USD to GHS).
  double? _exchangeRate;

  // Indicates if data is currently being loaded from the API.
  bool _isLoading = true;

  // Stores any error messages encountered during operations.
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadExchangeRate();
  }

  // Fetches the exchange rate using the currency service.
  Future<void> _loadExchangeRate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final rate = await _currencyService.fetchExchangeRate();
      if (!mounted) return;
      setState(() {
        _exchangeRate = rate;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  /// Handles currency conversion based on user input.
  void _handleConversion(bool ghsToUsd) {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Check if rate is loaded
    if (_exchangeRate == null) {
      setState(() => _result = 'Exchange rate not loaded');
      return;
    }

    // Validate input
    final amount = _currencyService.validateInput(_controller.text);
    if (amount == null) {
      setState(() => _result = 'Enter a valid amount');
      return;
    }

    // Perform conversion
    final convertedAmount = ghsToUsd
        ? _currencyService.convertGhsToUsd(amount, _exchangeRate!)
        : _currencyService.convertUsdToGhs(amount, _exchangeRate!);

    // Format and display result
    final resultText = _currencyService.formatConversionResult(
      amount,
      convertedAmount,
      ghsToUsd,
    );

    setState(() => _result = resultText);
  }

  // Clears the input field and result display.
  void _clearInput() {
    _controller.clear();
    setState(() => _result = '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E6FD),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRateCard(),
              const SizedBox(height: 20),
              _buildResultDisplay(),
              const SizedBox(height: 20),
              _buildInputField(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the app bar with gradient background.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('GHS ⇄ USD Converter'),
      titleTextStyle: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          color: Colors.white,
          onPressed: _showHelpDialog,
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF162660),
              Color(0xFF2D4A9E),
              Color(0xFF162660),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the exchange rate display card with refresh button.
  Widget _buildRateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Colors.black12),
        ],
      ),
      child: Row(
        children: [
          // Left side: Exchange rate info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exchange Rate',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isLoading)
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Loading...', style: TextStyle(fontSize: 14)),
                    ],
                  )
                else if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  Text(
                    '1 USD = ${_exchangeRate?.toStringAsFixed(2)} GHS',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF162660),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right side: Refresh button with blue container at far end
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF162660),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Colors.black12),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                color: _isLoading ? Colors.white54 : Colors.white,
              ),
              iconSize: 28,
              tooltip: _isLoading ? 'Loading...' : 'Refresh Rate',
              onPressed: _isLoading ? null : _loadExchangeRate,
            ),
          ),
        ],
      ),
    );
  }

  // Builds the result display container.
  Widget _buildResultDisplay() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 120),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E4D1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF162660)),
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
    );
  }

  // Builds the input field for entering amounts.
  Widget _buildInputField() {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Color(0xFF162660), fontSize: 18),
      decoration: InputDecoration(
        labelText: 'Enter amount',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: _clearInput,
        ),
      ),
    );
  }

  // Builds the conversion action buttons.
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildConvertButton(true, '🇺🇸', 'To Dollar'),
        _buildConvertButton(false, '🇬🇭', 'To Cedi'),
      ],
    );
  }

  // Builds a single conversion button.
  Widget _buildConvertButton(bool ghsToUsd, String flag, String label) {
    return ElevatedButton.icon(
      onPressed: () => _handleConversion(ghsToUsd),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF162660),
        foregroundColor: Colors.white,
        minimumSize: const Size(150, 50),
      ),
      icon: Text(flag, style: const TextStyle(fontSize: 20)),
      label: Text(label),
    );
  }

  // Shows a help dialog with usage instructions.
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: const Text(
          '1. Enter the amount you want to convert\n'
              '2. Tap "To Cedi" to convert USD → GHS\n'
              '3. Tap "To Dollar" to convert GHS → USD\n\n'
              'Tap the refresh icon to update the exchange rate.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}