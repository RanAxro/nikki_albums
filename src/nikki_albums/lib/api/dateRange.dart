class DateRange{
  final DateTime start;
  final DateTime end;
  const DateRange(this.start, this.end);
  bool contains(DateTime t) => !t.isBefore(start) && !t.isAfter(end);
}