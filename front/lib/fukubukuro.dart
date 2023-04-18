import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'fukubukuro_purchase.dart';

class Fukubukuro {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  Fukubukuro({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

class FukubukuroPage extends StatelessWidget {
  final List<Fukubukuro> fukubukuroList = [
    Fukubukuro(
      id: 1,
      title: '福袋 A',
      description: '缶バッチなどがたくさん入ってるよ！！',
      imageUrl: 'assets/images/eto_nezumi_fukubukuro.png',
      price: 5000.0,
    ),
    Fukubukuro(
      id: 2,
      title: '福袋 B',
      description: 'CDたくさん!いつもは見ない掘り出し物があるかも！？',
      imageUrl: 'assets/images/eto_tora_fukubukuro.png',
      price: 10000.0,
    ),
    Fukubukuro(
      id: 3,
      title: '福袋 C',
      description: 'アーティストのサインが入ってるかも！',
      imageUrl: 'assets/images/eto_usagi_fukubukuro.png',
      price: 15000.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('福袋'),
      ),
      body: Column(
        children: [
          // SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: 120,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.announcement,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(width: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '最新情報',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      '福袋の新シリーズが登場',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '福袋Cはサイン入りグッズが当たるチャンス！',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 2,
            thickness: 2,
          ),
          SizedBox(height: 15),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: fukubukuroList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return FukubukuroCard(fukubukuro: fukubukuroList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FukubukuroCard extends StatelessWidget {
  final Fukubukuro fukubukuro;

  FukubukuroCard({required this.fukubukuro});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FukubukuroPurchasePage(fukubukuro: fukubukuro),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.asset(
                  fukubukuro.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 120,
                ),
              ),
              SizedBox(height: 8),
              Text(
                fukubukuro.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                fukubukuro.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
