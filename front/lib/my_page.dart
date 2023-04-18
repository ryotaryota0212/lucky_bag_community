import 'package:flutter/material.dart' hide Card;
import 'package:flutter/src/material/card.dart' as flutterCard;
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfilePage extends StatefulWidget {
  // @override
  // Widget build(BuildContext context) {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}
class _MyProfilePageState extends State<MyProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, String> req = {};
  
  Future<dynamic> _purchaseCoin() async {
    try {
      // setState(() {
      //   stripeFlag = true;
      // });
      final data = await createTestPaymentSheet();

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

  Future<dynamic> createTestPaymentSheet() async {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
      ),
      body: user == null
      ? Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('ログイン画面へ'),
          ),
        )
      : Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/icon_business_man02.png'),
                radius: 80,
              ),
              SizedBox(height: 30),
              BuildUserInfoCard(
                  title :'表示名', value: user!.displayName ?? 'Not set'),
              BuildUserInfoCard(title: 'メールアドレス', value: user!.email ?? 'Not set'),
              BuildUserInfoCard(title: '推しのミュージシャン', value: 'シンバルくん'),
              BuildUserInfoCard(title: '現在持ってるコイン', value: '1000'),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () => {
                    _purchaseCoin()
                  },
                  child: Text('コインを購入する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildUserInfoCard extends StatelessWidget {
  final String title;
  final String value;

  BuildUserInfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return flutterCard.Card(
      // margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}