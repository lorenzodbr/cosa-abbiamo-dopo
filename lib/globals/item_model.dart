import 'package:flutter/material.dart';

class ItemModel {
  bool expanded;
  final String header;
  final List<String> body;
  final List<ElevatedButton>? button;

  ItemModel({
    this.expanded = false,
    required this.header,
    required this.body,
    this.button,
  });
}
