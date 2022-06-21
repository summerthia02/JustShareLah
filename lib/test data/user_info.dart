// ignore_for_file: unnecessary_const

import 'package:justsharelah_v1/test%20data/model_factory.dart';
import 'package:justsharelah_v1/test%20data/user_model.dart';

class UserInfo extends ModelFactory<User> {
  @override
  User generateFake() {
    return User(
      uid: createFakeUuid(),
      userName: faker.internet.userName(),
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      email: faker.internet.email(),
      imageUrl: faker.internet.httpUrl(),
    );
  }

  @override
  List<User> generateFakeList({required int length}) {
    return List.generate(length, (index) => generateFake());
  }
}
