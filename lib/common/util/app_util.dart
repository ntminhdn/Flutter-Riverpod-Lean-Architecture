import 'dart:math';

import 'package:intl/intl.dart';

import '../../index.dart';

class AppUtil {
  AppUtil._();

  static String randomName() {
    final _random = Random();

    const _names = [
      'Dog',
      'Cat',
      'Elephant',
      'Lion',
      'Tiger',
      'Giraffe',
      'Zebra',
      'Bear',
      'Monkey',
      'Horse',
      'Cow',
      'Sheep',
      'Goat',
      'Pig',
      'Rabbit',
      'Deer',
      'Fox',
      'Wolf',
      'Kangaroo',
      'Panda',
      'Dolphin',
      'Whale',
      'Shark',
      'Octopus',
      'Penguin',
      'Seal',
      'Otter',
      'Walrus',
      'Bat',
      'Squirrel',
      'Chipmunk',
      'Raccoon',
      'Beaver',
      'Koala',
      'Platypus',
      'Ostrich',
      'Emu',
      'Parrot',
      'Toucan',
      'Pelican',
      'Hummingbird',
      'Eagle',
      'Hawk',
      'Falcon',
      'Owl',
      'Sparrow',
      'Crow',
      'Swan',
      'Flamingo',
      'Heron',
      'Peacock',
      'Pigeon',
      'Seagull',
      'Albatross',
      'Cockatoo',
      'Macaw',
      'Cockroach',
      'Grasshopper',
      'Ant',
      'Bee',
      'Wasp',
      'Butterfly',
      'Moth',
      'Caterpillar',
      'Dragonfly',
      'Ladybird',
      'Beetle',
      'Scorpion',
      'Spider',
      'Tarantula',
      'Centipede',
      'Millipede',
      'Earthworm',
      'Slug',
      'Snail',
      'Jellyfish',
      'Starfish',
      'Crab',
      'Lobster',
      'Shrimp',
    ];

    return '${_names[_random.nextInt(_names.length)]}${_random.nextInt(100)}';
  }

  static String formatPrice(double price) {
    return NumberFormat.currency(symbol: '￥', decimalDigits: 0).format(price);
  }

  static String formatNumber(int number) {
    return NumberFormat(Constant.numberFormat1).format(number);
  }

  static bool isValidPassword(String password) {
    const _mimimumPasswordLength = 6;
    const _whitespace = ' ';

    return password.length >= _mimimumPasswordLength && !password.contains(_whitespace);
  }

  static bool isValidEmail(String email) {
    if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$').hasMatch(email.trim())) {
      return false;
    }

    return true;
  }
}
