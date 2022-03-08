import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

//We've now put fake JSON responses into files.
// To use the JSON contained inside of them,
// we have to have a way to get the content of these files as a String.
// For that, we're going to create a top-level function called fixture
// inside a file fixture_reader.dart (it goes into the fixture folder).
