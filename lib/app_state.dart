part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AddToBDState extends AppState {}

class GetBDState extends AppState {}

class DeleteInBDState extends AppState {}

class UpdateBDState extends AppState {}
