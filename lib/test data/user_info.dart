// ignore_for_file: unnecessary_const

import 'package:justsharelah_v1/test%20data/model_factory.dart';
import 'package:justsharelah_v1/models/user_data.dart';

class UserInfo extends ModelFactory<UserData> {
  @override
  UserData generateFake() {
    return UserData(
      uid: createFakeUuid(),
      userName: faker.internet.userName(),
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      email: faker.internet.email(),
      phoneNumber: "",
      about: "",
      imageUrl: faker.internet.httpUrl(),
      listings: []
    );
  }

  @override
  List<UserData> generateFakeList({required int length}) {
    return List.generate(length, (index) => generateFake());
  }
}
