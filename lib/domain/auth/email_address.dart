class EmailAddress {
  final String value;

  const EmailAddress(this.value) : assert(value != null);

  @override
  String toString() {
    return 'EmailAddress($value)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is EmailAddress && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
