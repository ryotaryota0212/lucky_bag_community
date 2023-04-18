import 'package:flutter/material.dart';
import 'fukubukuro.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FukubukuroPurchasePage extends StatefulWidget {
  final Fukubukuro fukubukuro;

  FukubukuroPurchasePage({required this.fukubukuro});

  @override
  _FukubukuroPurchasePageState createState() => _FukubukuroPurchasePageState();
}

class _FukubukuroPurchasePageState extends State<FukubukuroPurchasePage> {
  int _quantity = 1;
  Map<String, String> req = {};
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }
  Future<dynamic> _purchasefukubukuro(String name, double price) async {
    try {
      // setState(() {
      //   stripeFlag = true;
      // });
      final data = await createTestPaymentSheet(price);

      print(data);

        // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Enable custom flow
            customFlow: true,
            // Main params
            merchantDisplayName: 'Stripeテスト',
            paymentIntentClientSecret: data['response']['client_secret'],
            // Customer keys
            customerEphemeralKeySecret: data['ephemeralKey'],
            customerId: data['customer']['id'],
            // Extra options
            // testEnv: true,
            // applePay: true,
            // googlePay: true,
            style: ThemeMode.dark,
            // merchantCountryCode: 'DE',
          ),
        );
      await Stripe.instance.presentPaymentSheet();
    } catch(e) {
      print("Exception: $e");
    }
  }

  Future<dynamic> createTestPaymentSheet(price) async {
    const url = "http://localhost:8100/create-payment-intent";
    final headers = {
      "Content-Type": "application/json",
    };
    // req['price'] = int.parse(price);
    final body = json.encode(req);
    try {
      // setState(() {
      //   _isLoading = true;
      // });
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        print("Data sent successfully:${responseJson['response']}");
        return responseJson;
      } else {
        // アラートか何かを設定
        print("Error sending data: ${response.statusCode}");
      }
    } catch (e) {
      // アラートか何かを設定
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final fukubukuro = widget.fukubukuro;
    return Scaffold(
      appBar: AppBar(
        title: Text(fukubukuro.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Image.asset(
                fukubukuro.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 200,
              ),
              // SizedBox(height: 16),
              // Text(
              //   fukubukuro.title,
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.coins,
                    color: Colors.orange,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${fukubukuro.price.toStringAsFixed(0)} コイン',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _decrementQuantity,
                    icon: Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: TextStyle(fontSize: 18)),
                  IconButton(
                    onPressed: _incrementQuantity,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Text(
              //   '合計金額: ¥${(fukubukuro.price * _quantity).toStringAsFixed(0)}',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.coins,
                    color: Colors.orange,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '合計: ${(fukubukuro.price * _quantity).toStringAsFixed(0)} コイン',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _purchasefukubukuro(fukubukuro.title, fukubukuro.price * _quantity);
                  },
                  child: Text('購入する'),
                ),
              ),
              // CardField()
            ],
          ),
        ),
      ),
    );
  }
}
