import '../dummys/dummy_data.dart';
import 'package:dreamers/models/dream.dart';
import 'package:flutter/cupertino.dart';

class DreamsProvider with ChangeNotifier {
  List<Dream> _dreams = DUMMY_DREAMS;

  List<Dream> get dreams {
    return [..._dreams];
  }

  Dream findById(String id) {
    return dreams.firstWhere((dream) => dream.id == id);
  }

  void addDream(Dream dream) {
    _dreams.add(dream);
    notifyListeners();
  }
}
