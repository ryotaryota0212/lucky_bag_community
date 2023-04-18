import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'musician_detail.dart';

class Musician {
  final int id;
  final String name;
  final String imageUrl;
  final String genre;
  final String description;
  final String twitterUrl;
  final String instagramUrl;
  final String youtubeUrl;

  Musician({
    required this.id, 
    required this.name, 
    required this.imageUrl, 
    required this.genre,
    required this.description,
    required this.twitterUrl,
    required this.instagramUrl,
    required this.youtubeUrl,
  });
}

class Comment {
  String author;
  String content;

  Comment({required this.author, required this.content});
}


class MusicianListPage extends StatefulWidget {
  @override
  _MusicianListPageState createState() => _MusicianListPageState();
}

class _MusicianListPageState extends State<MusicianListPage> {
  // ...
  List<Musician> musicians = [];
  String _selectedGenre = 'All';
  final List<String> _availableGenres = [
    'All',
    'pops',
    'jazz',
    'hiphop',
  ];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Update the UI when the search text changes.
    });

    // ここでミュージシャンデータ
    musicians = [
      Musician(
        id: 1, 
        name: 'Mr.フルート', 
        imageUrl: 'assets/images/musician_flute.png', 
        genre: 'pops',
        description: '美しい旋律で皆さんの心を魅了するフルート奏者、Mr.フルートです。クラシックから現代音楽まで幅広いレパートリーを持ち、独特の感性で音楽を表現します。音楽と共に、皆さんの日常に彩りを添えるお手伝いができれば嬉しいです。',
        twitterUrl: 'https://twitter.com/hachi_08',
        instagramUrl: 'https://www.instagram.com/hachi_08',
        youtubeUrl: 'https://www.youtube.com/channel/UCUCeZaZeJbEYAAzvMgrKOPQ'
      ),
      Musician(
        id: 2, 
        name: 'ミスバイオリン', 
        imageUrl: 'assets/images/musician_violin.png',
        genre: 'jazz', 
        description: '情熱と技巧を兼ね備えたバイオリニスト、ミスバイオリンです。幼少期から音楽に親しみ、世界中の舞台で演奏してきました。バイオリンの力強い音色を通して、心に響くメロディーをお届けいたします。',
        twitterUrl: 'https://twitter.com/hachi_08',
        instagramUrl: 'https://www.instagram.com/hachi_08',
        youtubeUrl: 'https://www.youtube.com/channel/UCUCeZaZeJbEYAAzvMgrKOPQ'
      ),
      Musician(
        id: 3, 
        name: 'シンバルくん', 
        imageUrl: 'assets/images/musician_gimbals.png', 
        genre: 'pops',
        description: 'リズムの魔術師、シンバルくんです。パーカッション楽器の中でも、特にシンバルの演奏に情熱を注いでいます。単なるアクセントではなく、シンバルの魅力を最大限に引き出して、音楽に新たな息吹を吹き込みます。',
        twitterUrl: 'https://twitter.com/hachi_08',
        instagramUrl: 'https://www.instagram.com/hachi_08',
        youtubeUrl: 'https://www.youtube.com/channel/UCUCeZaZeJbEYAAzvMgrKOPQ'
      ),
      Musician(
        id: 4, 
        name: 'リコーダちゃん', 
        imageUrl: 'assets/images/musician_recorder.png',
        genre: 'jazz', 
        description: '軽快で愛らしい音色が魅力のリコーダー奏者、リコーダちゃんです。古典からポップスまで、様々なジャンルに対応できる柔軟性が自慢です。リコーダーの素晴らしさを広めることを使命として、音楽の世界を楽しく彩っていきます。',
        twitterUrl: 'https://twitter.com/hachi_08',
        instagramUrl: 'https://www.instagram.com/hachi_08',
        youtubeUrl: 'https://www.youtube.com/channel/UCUCeZaZeJbEYAAzvMgrKOPQ'
      ),
      Musician(
        id: 5, 
        name: 'ラッパー', 
        imageUrl: 'assets/images/rapper.png', 
        genre: 'hiphop',
        description: '独自のフロウとリリックで魅せるラッパー、ラッパーです。ストリートから生まれた音楽を、自分自身の言葉で表現し、社会や人々の想いを音楽に乗せて伝えます。リアルな言葉で、聴く人の心に訴えかけるラップをお届けします。',
        twitterUrl: 'https://twitter.com/hachi_08',
        instagramUrl: 'https://www.instagram.com/hachi_08',
        youtubeUrl: 'https://www.youtube.com/channel/UCUCeZaZeJbEYAAzvMgrKOPQ'
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Musician> _getFilteredMusicians() {
    final searchText = _searchController.text.toLowerCase();
    List<Musician> filteredMusicians = musicians;

    if (_selectedGenre != 'All') {
      filteredMusicians = filteredMusicians
        .where((musician) => musician.genre.toLowerCase() == _selectedGenre.toLowerCase())
        .toList();
    }

    if (searchText.isNotEmpty) {
      filteredMusicians = filteredMusicians
          .where((musician) => musician.name.toLowerCase().contains(searchText))
          .toList();
    }

    return filteredMusicians;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ミュージシャン')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
              padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            labelText: '名前で検索',
                            hintText: '名前を入力してください',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ),
                        SizedBox(width: 16),
                        DropdownButton<String>(
                          value: _selectedGenre,
                          items: _availableGenres.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGenre = newValue!;
                            });
                          },
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          iconEnabledColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _getFilteredMusicians().length,
              itemBuilder: (BuildContext context, int index) {
                return MusicianCard(musician: _getFilteredMusicians()[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 5),
            ),
          ),
        ],
      ),
    );
  }
}

class MusicianCard extends StatelessWidget {
  final Musician musician;

  MusicianCard({required this.musician});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicianDetailPage(musician: musician),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.asset(
                  musician.imageUrl,
                  fit: BoxFit.cover,
                  width: 120, // 画像の横幅を変更
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musician.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      musician.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(musician.twitterUrl);
                            await launchUrl(url);
                          },
                          child: Icon(FontAwesomeIcons.twitter,color: Colors.blue),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(musician.instagramUrl);
                            await launchUrl(url);
                          },
                          child: Icon(FontAwesomeIcons.instagram, color: Colors.purple),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(musician.youtubeUrl);
                            await launchUrl(url);
                          },
                          child: Icon(FontAwesomeIcons.youtube, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

