import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:windows_note/shared_prefrences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);
  List data = [];
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var urlController = TextEditingController();
  static Future<SharedPreferences> createDB() async {
    return await CashHelper.init().then((value) {
      return value;
    });
  }

  Future<void> getAllData() async {
    if (CashHelper.get("appData") != null) {
      data = jsonDecode(CashHelper.get("appData")!);
    }

    emit(GetBDState());
  }

  addData(
      {required String title, required String url, required context}) async {
    Map note = {'title': title, 'url': url};
    data.add(note);

    await CashHelper.set("appData", jsonEncode(data)).then((value) {
      emit(AddToBDState());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('added successfully'),
      ));
      getAllData();
    });
  }

  deleteData({required String url, required context}) {
    if(data.isNotEmpty){
    for (var element in data) {
      if (element['url'] == url) {
        data.remove(element);
        CashHelper.set("appData", jsonEncode(data));
        emit(DeleteInBDState());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('deleted successfully'),
        ));
        continue;
      }
    }
  }
  }


  Future<bool> deleteAllData(context) async {
    data = [];
    return await CashHelper.deleteAllData().then((value) {
      emit(DeleteInBDState());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('deleted successfully'),
      ));

      return value;
    });
  }
}
