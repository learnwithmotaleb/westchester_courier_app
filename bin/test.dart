import 'dart:convert';
import 'dart:io';

void main() async {
  final origin = Uri.encodeComponent('151 Newark Ave, Jersey City, NJ 07302');
  final dest = Uri.encodeComponent('1426 Atlantic Ave, Brooklyn, NY 11216');
  final key = 'AIzaSyAFkrO5JzbDTL0IGb-ObLLKDgjY5BuGZG8';
  final url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$dest&key=$key';

  final request = await HttpClient().getUrl(Uri.parse(url));
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  print(body);
}
