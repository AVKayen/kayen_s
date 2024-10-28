import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SwiftData {
  final String title;
  final String artist;

  const SwiftData({
    required this.title,
    required this.artist,
  });

  factory SwiftData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'artist': String artist,
      } =>
        SwiftData(
          title: title,
          artist: artist,
        ),
      _ => throw const FormatException('Failed to load swift.'),
    };
  }
}

class Swift extends StatefulWidget {
  final int index;

  const Swift({
    super.key,
    required this.index,
  });

  @override
  State<Swift> createState() => _SwiftState();
}

Future<SwiftData> fetchSwift(int index) async {
  final response =
      await http.get(Uri.http('130.61.172.11:8080', "albums/$index"));
  if (response.statusCode == 200) {
    return SwiftData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load');
  }
}

class _SwiftState extends State<Swift> {
  late Future<SwiftData> futureSwift;

  @override
  void initState() {
    super.initState();
    futureSwift = fetchSwift(widget.index);
  }

  @override
  void didUpdateWidget(covariant Swift oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      setState(() {
        futureSwift = fetchSwift(widget.index);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        children: [
          const Text("Is Swiftin?:"),
          FutureBuilder<SwiftData>(
            future: futureSwift,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("${snapshot.data!.title} by ${snapshot.data!.artist}");
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
