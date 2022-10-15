import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:windows_note/app_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getAllData(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, s) {
          return Scaffold(
            appBar: AppCubit.get(context).data.isEmpty
                ? null
                : AppBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      backgroundColor: const Color(0xFF253341),
                                      title: const Text(
                                        'هل تريد حذف الكل ؟!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      actions: [
                                        MaterialButton(
                                            onPressed: () {
                                              AppCubit.get(context)
                                                  .deleteAllData(context)
                                                  .then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            color: Colors.red,
                                            child: const Text(
                                              'نعم',
                                              style: TextStyle(fontSize: 30),
                                            )),
                                        MaterialButton(
                                          onPressed: () {
                                            AppCubit.get(context)
                                                .getAllData()
                                                .then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          color: Colors.green,
                                          child: const Text(
                                            'لا',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        iconSize: 35,
                      )
                    ],
                  ),
            body: AppCubit.get(context).data.isEmpty
                ? const Center(
                    child: Text(
                    'لا توجد بيانات !!.. برجاء الضغط على + لاضافة بيانات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold),
                  ))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (_, index) => BuildFatouraItem(
                                  contextCubit: context,
                                  title: AppCubit.get(context).data[index]
                                      ['title'],
                                  url: AppCubit.get(context).data[index]['url'],
                                ),
                            separatorBuilder: (_, index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  color: const Color(0xFF253341),
                                  width: double.infinity,
                                  height: 1,
                                ),
                            itemCount: AppCubit.get(context).data.length),
                      ),
                    ],
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF253341),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (_) => Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      color: const Color(0xFF15202B),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: AppCubit.get(context).formKey,
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  DefaultTextField(
                                    controller:
                                        AppCubit.get(context).titleController,
                                    label: 'title',
                                    validator: (String? data) {
                                      if (data!.isEmpty) {
                                        return 'لا يجب ان يكون فارغا';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  DefaultTextField(
                                    controller:
                                        AppCubit.get(context).urlController,
                                    label: 'url',
                                    validator: (String? data) {
                                      if (data!.isEmpty) {
                                        return 'لا يجب ان يكون فارغا';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      if (AppCubit.get(context)
                                          .formKey
                                          .currentState!
                                          .validate()) {
                                        AppCubit.get(context).addData(
                                            title: AppCubit.get(context)
                                                .titleController
                                                .text,
                                            url: AppCubit.get(context)
                                                .urlController
                                                .text,
                                            context: context);
                                        AppCubit.get(context)
                                            .titleController
                                            .clear();
                                        AppCubit.get(context)
                                            .urlController
                                            .clear();
                                        Navigator.pop(context);
                                      }
                                    },
                                    color: const Color(0xFF253341),
                                    child: const Text(
                                      'اضف',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30.0),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DefaultTextField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const DefaultTextField({
    Key? key,
    required this.label,
    required this.validator,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}

class BuildFatouraItem extends StatefulWidget {
  const BuildFatouraItem(
      {Key? key,
      required this.title,
      required this.url,
      required this.contextCubit})
      : super(key: key);

  final String title;
  final String url;

  final BuildContext contextCubit;

  @override
  State<BuildFatouraItem> createState() => _BuildFatouraItemState();
}

class _BuildFatouraItemState extends State<BuildFatouraItem> {
  @override
  Widget build(BuildContext context) {
    num width = MediaQuery.of(context).size.width;
    print(width);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          final Uri url = Uri.parse(
            widget.url,
          );
          launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)
              .catchError((onError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Could not launch ${widget.url}'),
            ));
          });

          //    Clipboard.setData(ClipboardData(text: widget.url));
        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              children: [
                Expanded(
                  flex: width > 1231.2 ? 0 : 1,
                  child: Text(
                    width > 1231.2 ? '${widget.title} : ' : '${widget.title} ',
                    textAlign:
                        width < 1231.2 ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                        color: width < 1231.2 ? Colors.white : Colors.red,
                        fontSize: 35.0),
                  ),
                ),
                if (width > 1231.2)
                  Expanded(
                    child: Text(
                      widget.url,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 35.0),
                    ),
                  ),
              ],
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              backgroundColor: const Color(0xFF253341),
                              title: const Text(
                                'هل تريد الحذف ؟',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      AppCubit.get(context).deleteData(
                                          context: context, url: widget.url);
                                    },
                                    color: Colors.red,
                                    child: const Text(
                                      'نعم',
                                      style: TextStyle(fontSize: 30),
                                    )),
                                MaterialButton(
                                  onPressed: () {
                                    AppCubit.get(context)
                                        .getAllData()
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  color: Colors.green,
                                  child: const Text(
                                    'لا',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                )
                              ],
                            ),
                          )).then((value) {
                    setState(() {});
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 40.0,
                ))
          ],
        ),
      ),
    );
  }
}
