import 'package:cloud_firestore/cloud_firestore.dart';

/// Checks if a field exists in a document and is not null
bool hasField(String field, DocumentSnapshot document) {
  String dataInString = document.data().toString();

  bool hasField = dataInString.contains(field) && document[field] != null;

  return hasField;
}

bool hasMapField(String field, Map<String, dynamic> map) {
  bool hasField = map.containsKey(field) && map[field] != null;
  return hasField;
}

double parseDoubleValuesFromInput(dynamic input) {
  double value = 0.0;
  try {
    value = double.parse(input.toString());
  } catch (e) {
    value = 0.0;
  }
  return value;
}
