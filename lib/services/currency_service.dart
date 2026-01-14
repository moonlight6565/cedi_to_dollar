import 'dart:convert';
import 'package:http/http.dart' as http;

// A service class responsible for currency-related operations(API communication and conversion calculation).
class CurrencyService {
  // Storing API URL
  static const String _apiUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

  // Fetches the latest USD to GHS exchange rate from the API.
  Future<double> fetchExchangeRate() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Checks if rates exists and it contains GHS
        if (data['rates'] != null && data['rates']['GHS'] != null) {
          return (data['rates']['GHS'] as num).toDouble();
        } else {
          throw Exception('GHS rate not found');
        }
      } else {
        throw Exception('Failed to load exchange rate (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error: Check your internet connection');
    }
  }

  // Converts an amount from GHS to USD.
  double convertGhsToUsd(double amount, double rate) {
    return amount / rate;
  }

  // Converts an amount from USD to GHS.
  double convertUsdToGhs(double amount, double rate) {
    return amount * rate;
  }

  // Changes the conversion result into a readable string.
  String formatConversionResult(double amount, double convertedAmount, bool isGhsToUsd) {
    if (isGhsToUsd) {
      return 'GHS ₵${amount.toStringAsFixed(2)} = \nUSD \$${convertedAmount.toStringAsFixed(2)}';
    } else {
      return 'USD \$${amount.toStringAsFixed(2)} = \nGHS ₵${convertedAmount.toStringAsFixed(2)}';
    }
  }

  // Validates user input for currency conversion.
  double? validateInput(String input) {
    final amount = double.tryParse(input);
    if (amount == null || amount < 0) {
      return null;
    }
    return amount;
  }
}