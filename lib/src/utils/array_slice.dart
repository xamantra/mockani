List<List<T>> sliceListToRows<T>({
  required List<T> source,
  required int columnCount,
}) {
  var rows = <List<T>>[];
  var remainder = source.length % columnCount;
  var rowCount = (source.length - remainder) ~/ columnCount;
  for (var i = 0; i < rowCount; i++) {
    var start = i * columnCount;
    var end = start + columnCount;
    rows.add(source.sublist(start, end));
  }
  rows.add(source.sublist(rowCount * columnCount, source.length));
  rows.removeWhere((x) => x.isEmpty);
  return rows;
}
