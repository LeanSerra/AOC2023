//import 'dart:async';

import 'dart:io';
// import 'dart:convert';
//import 'dart:collection';
//import 'package:collection/collection.dart';

class HeatNode {
  var est_distance;
  var heat_value;
}

void main(List<String> args) {
  if (args.length < 1) {
    print(
        "Usage: ${File(Platform.resolvedExecutable).uri.pathSegments.last} <input-file>");
    return;
  } else {
    var nodes = <List<int>>[];
    


    
  }
}

void readFile(String file_name, List<List<int>> nodes) {
  for (var line in new File(file_name).readAsLinesSync()) {
    nodes.add(<int>[]);
    for (var char in line.split('')) {
      nodes.last.add(int.parse(char));
    }
  }
}


