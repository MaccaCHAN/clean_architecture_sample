# Clean Architecture_Sample

This project is based on Reso Coder's inspiring TDD Clean Architecture Course. 

https://resocoder.com/flutter-clean-architecture-tdd/

As the course was created in 2019, things have changed quite a bit in dart, flutter and some packages. I think many people who try to learn from the course may found it a bit hard to follow along, like myself. So I decided to create a project with updated versions of dart, flutter and the packages used in the project.

## Major updates from the original project

Dart: version 2.16.1 is used. The major difference is that SOUND NULL SAFETY is adopted.

Flutter_test: The unit tests are amended so that it works with null safety.

Mocktail: Mocktail 0.2.0 is used instead of Mockito, as Mocktail doesn't need build_runner to work with null safety support.

Flutter_bloc: Flutter_bloc 8.0.1 is used. The way it handles event is different than previous version.



