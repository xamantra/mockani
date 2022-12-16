List<List<T>> sliceList<T>({
  required List<T> source,
  required int itemsPerSet,
}) {
  var rows = <List<T>>[];
  var remainder = source.length % itemsPerSet;
  var rowCount = (source.length - remainder) ~/ itemsPerSet;
  for (var i = 0; i < rowCount; i++) {
    var start = i * itemsPerSet;
    var end = start + itemsPerSet;
    rows.add(source.sublist(start, end));
  }
  rows.add(source.sublist(rowCount * itemsPerSet, source.length));
  rows.removeWhere((x) => x.isEmpty);
  return rows;
}
