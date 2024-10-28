import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SwiftData {
  final String swift;

  const SwiftData({
    required this.swift,
  });

  factory SwiftData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'swift': String swift,
      } =>
        SwiftData(
          swift: swift,
        ),
      _ => throw const FormatException('Failed to load swift.'),
    };
  }
}

class Swift extends StatefulWidget {
  const Swift({super.key});

  @override
  State<Swift> createState() => _SwiftState();
}

Future<SwiftData> fetchSwift() async {
  final response = await http.get(Uri.http('130.61.172.11:8080', ""));
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
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Column(children: [
          const Text("Is Swiftin?:"),
          FutureBuilder<SwiftData>(
            future: futureSwift,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.swift);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ]));
  }

  @override
  void initState() {
    super.initState();
    futureSwift = fetchSwift();
  }
}
