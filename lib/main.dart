import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

const maxNumber = 385;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PokeApi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imageUrls = [];

  Future<void> fetchImagesUrls() async {
    for (int index = 1; index <= maxNumber; index++) {
      final url = 'http://pokeapi.co/api/v2/pokemon/$index';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // ステータスコード200はリクエストが成功した場合返されるコード
        // HTTPリクエストに成功した時の処理
        var jsonResponse = json.decode(response.body);
        final imageUrl = jsonResponse['sprites']['front_default'];
        setState(() {
          imageUrls.add(imageUrl);
        });
      } else {
        // throw Exception('Failed to fetch image URL');
        print(response.statusCode);
      }
    }
  }

  @override
  void initState() {
    imageUrls = [];
    fetchImagesUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, int index) {
          return CachedNetworkImage(
            imageUrl: imageUrls[index],
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        },
      ),
    );
  }
}
