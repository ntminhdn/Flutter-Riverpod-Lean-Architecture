import '../index.dart';

const listChecker = TypeChecker.fromUrl('dart:core#List');
const setChecker = TypeChecker.fromUrl('dart:core#Set');
const iterableChecker = TypeChecker.fromUrl('dart:core#Iterable');

const stringChecker = TypeChecker.fromUrl('dart:core#String');

const collectionChecker = TypeChecker.any(
  [
    listChecker,
    setChecker,
    iterableChecker,
  ],
);
