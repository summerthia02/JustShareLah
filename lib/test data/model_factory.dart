import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

abstract class ModelFactory<T> {
  Faker get faker => Faker();
  var uuid = Uuid();

  /// Creates a fake uuid.
  String createFakeUuid() {
    return uuid.v4();
  }

  /// Generate a single fake model.
  T generateFake();

  /// Generate fake list based on provided length.
  List<T> generateFakeList({required int length});
}
