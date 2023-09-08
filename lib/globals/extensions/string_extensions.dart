extension StringExtensions on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  //camel Case (preserving spaces)
  String toCamelCase() => [
        split(' ')[0].toLowerCase(),
        split(' ')
            .sublist(1)
            .map((word) =>
                word[0].toUpperCase() + word.substring(1).toLowerCase())
            .join(' ')
      ].join(' ');
}
