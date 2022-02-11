import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemModel {
  bool expanded;
  final String header;
  final String body;
  ElevatedButton? button;

  ItemModel({
    this.expanded = false,
    required this.header,
    required this.body,
    this.button,
  });
}
