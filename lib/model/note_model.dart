import 'dart:convert';

import 'package:flutter/material.dart';

class Note {
  final int id;
  final String title;
  final String description;
  final Color color;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'color': color.value,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        color: Color(json['color']),
      );

  String toJsonString() => jsonEncode(toJson());

  factory Note.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return Note.fromJson(json);
  }
}
