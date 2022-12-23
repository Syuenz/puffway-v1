import 'package:flutter/foundation.dart';
import './path.dart';

class Pathway with ChangeNotifier {
  final String id;
  final DateTime timestamp;
  final String title;
  final String description;
  final List<PathItem> paths;

  Pathway({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.description,
    required this.paths,
  });
}
