import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prega/utils/size_config.dart';
import 'package:prega/widgets/heading.dart';
import 'package:http/http.dart' as http;

// url -> https://mocki.io/v1/2048e80d-cb5a-4ab8-82d9-018eeb15aa1f

class Album {
  final String text;
  const Album({
    required this.text,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      text: json['text'],
    );
  }
}

class Tips extends StatefulWidget {
  Tips({Key? key}) : super(key: key);

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  Future fetchAlbum() async {
    var url = "https://mocki.io/v1/2048e80d-cb5a-4ab8-82d9-018eeb15aa1f";
    final response = await http.get(Uri.parse(url));

    List<Album> tips = [];
    var jsonData = jsonDecode(response.body);
    for (var t in jsonData) {
      Album album = Album(text: t['text']);
      tips.add(album);
    }
    print(tips.length);
    return tips;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 55.toHeight,
            ),
            Heading(title: "Tips"),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: fetchAlbum(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length!,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(224, 175, 224, 226),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Text(snapshot.data[index]?.text),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
