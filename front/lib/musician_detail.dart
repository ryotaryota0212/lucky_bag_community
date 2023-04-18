import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'musician.dart';
import 'merchandise.dart';

class Comment {
  String author;
  String content;
  int likes;

  Comment({required this.author, required this.content , this.likes = 0});
}

class Merchandise {
  final int id;
  final String title;
  final String imageUrl;
  final double price;

  Merchandise({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });
}

class MusicianDetailPage extends StatefulWidget {
  final Musician musician;

  MusicianDetailPage({required this.musician});

   @override
  _MusicianDetailPageState createState() => _MusicianDetailPageState();
}

class _MusicianDetailPageState extends State<MusicianDetailPage> {
  List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  List<Merchandise> _merchandises = [
    Merchandise(id: 1, title: 'Tシャツ', imageUrl: 'assets/images/fashion_tshirt5_blue.png', price: 2500.0),
    Merchandise(id: 2, title: 'キャップ', imageUrl: 'assets/images/fashion_tsuugakubou_cap.png', price: 1800.0),
    Merchandise(id: 3, title: 'マグカップ', imageUrl: 'assets/images/syokki_mug_cup.png', price: 1200.0),
    Merchandise(id: 4, title: 'バッグ', imageUrl: 'assets/images/fashion_bag_sacoche.png', price: 3000.0),
    Merchandise(id: 5, title: 'パーカー', imageUrl: 'assets/images/fashion_parka.png', price: 3000.0),
    Merchandise(id: 6, title: 'CD', imageUrl: 'assets/images/entertainment_music.png', price: 3000.0),
    // 他のグッズデータ
  ];


  void _addComment(String content) {
    setState(() {
      _comments.add(Comment(author: user!.displayName ?? '匿名', content: content));
    });
    // ミュージシャンIDに対して保存する
  }
  void _showCommentsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
               'このミュージシャンのいいところ！',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/icon_business_man02.png'),
                    ),
                    title: Text(_comments[index].author),
                    subtitle: Text(_comments[index].content),
                    trailing: IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: _comments[index].likes > 0 ? Colors.blue : null,
                      onPressed: () {
                        setState(() {
                          _comments[index].likes++;
                        });
                        Navigator.pop(context);
                        _showCommentsModal(context);
                      },
                    ),
                  );
                  },
                ),
              ),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'このアーティストのいいところ教えて！',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _addComment(_commentController.text);
                      _commentController.clear();
                      Navigator.pop(context);
                      _showCommentsModal(context);
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final musician = widget.musician;
    // final musicianRehearsals = rehearsals.where((rehearsal) => rehearsal.musicianId == musician.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(musician.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 9, // 任意のアスペクト比を設定
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.asset(
                    musician.imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                musician.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(musician.twitterUrl);
                      await launchUrl(url);
                    },
                    child: Icon(FontAwesomeIcons.twitter,color: Colors.blue),
                  ),
                  SizedBox(width: 25),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(musician.instagramUrl);
                      await launchUrl(url);
                    },
                    child: Icon(FontAwesomeIcons.instagram, color: Colors.purple),
                  ),
                  SizedBox(width: 25),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(musician.youtubeUrl);
                      await launchUrl(url);
                    },
                    child: Icon(FontAwesomeIcons.youtube, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 350,
                child: GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _merchandises.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return MerchandiseCard(merchandise: _merchandises[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCommentsModal(context);
        },
        child: Icon(Icons.comment),
      ),
    );
  }
}

class MerchandiseCard extends StatelessWidget {
  final Merchandise merchandise;

  MerchandiseCard({required this.merchandise});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MerchandisePage(merchandise: merchandise),
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
                  merchandise.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 100,
                ),
              ),
              // SizedBox(height: 4),
              // Text(
              //   merchandise.title,
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     FaIcon(
              //       FontAwesomeIcons.coins,
              //       color: Colors.orange,
              //       size: 10,
              //     ),
              //     SizedBox(width: 4),
              //     Text(
              //       '${merchandise.price.toStringAsFixed(0)} ',
              //       style: TextStyle(
              //         fontSize: 7,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.orange,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

