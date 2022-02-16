import 'package:flutter/material.dart';

class ItemModel {
  bool expanded;
  final String header;
  final List<String> headers;
  final List<String> body;
  final List<ElevatedButton>? button;
  final bool isPlaformDependent;

  ItemModel({
    this.expanded = false,
    this.header = '',
    this.headers = const [],
    required this.body,
    this.button,
    this.isPlaformDependent = false,
  });
}
