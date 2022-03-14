import 'package:test/test.dart';
import '../lib/models/post.dart';

void main() {
  test('instance created from FoodWastePost class should have appropriate property values', () {
    final date = "Saturday, March 13, 2022";
    final url = "flutter.com";
    final quantity = "5";
    final latitude = 122.2;
    final longitude = -29.5344;

    final foodWastePost = FoodWastePost(
      date: date,
      imageURL: url,
      quantity: quantity,
      latitude: latitude,
      longitude: longitude,
    );

  expect(foodWastePost.date, date);
  expect(foodWastePost.imageURL, url);
  expect(foodWastePost.quantity, quantity);
  expect(foodWastePost.latitude, latitude);
  expect(foodWastePost.longitude, longitude);
  });
}