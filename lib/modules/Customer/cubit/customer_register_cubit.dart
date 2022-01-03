import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_register_states.dart';
import 'package:mostaqbal_masr/modules/Customer/dropdown/drop_list_model.dart';

class CustomerRegisterCubit extends Cubit<CustomerRegisterStates>{

  CustomerRegisterCubit() : super(CustomerRegisterInitialState());

  static CustomerRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  IconData suffix = Icons.visibility_rounded;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
    isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(CustomerRegisterChangePasswordVisibilityState());
  }

  DropListModel cityDropListModel = DropListModel([
    OptionItem(id: "1", title: "القاهرة"),
    OptionItem(id: "2", title: "الاسكندرية"),
    OptionItem(id: "3", title: "الاسماعيلية"),
    OptionItem(id: "4", title: "أسوان"),
    OptionItem(id: "5", title: "أسيوط"),
    OptionItem(id: "6", title: "الأقصر"),
    OptionItem(id: "7", title: "البحر الاحمر"),
    OptionItem(id: "8", title: "البحيرة"),
    OptionItem(id: "9", title: "بنى سويف"),
    OptionItem(id: "10", title: "بورسعيد"),
    OptionItem(id: "11", title: "جنوب سيناء"),
    OptionItem(id: "12", title: "شمال سيناء"),
    OptionItem(id: "13", title: "الدقهلية"),
    OptionItem(id: "14", title: "دمياط"),
    OptionItem(id: "15", title: "سوهاج"),
    OptionItem(id: "16", title: "السويس"),
    OptionItem(id: "17", title: "الشرقية"),
    OptionItem(id: "18", title: "الغربية"),
    OptionItem(id: "19", title: "الفيوم"),
    OptionItem(id: "20", title: "القليوبية"),
    OptionItem(id: "21", title: "قنا"),
    OptionItem(id: "22", title: "كفر الشيخ"),
    OptionItem(id: "23", title: "مطروح"),
    OptionItem(id: "24", title: "المنوفية"),
    OptionItem(id: "25", title: "المنيا"),
    OptionItem(id: "26", title: "الوادى الجديد")
  ]);
  OptionItem cityOptionItemSelected =
  OptionItem(id: '', title: "قم بأختيار المحافظة");

  DropListModel idDropListModel = DropListModel([
    OptionItem(id: "1", title: "بطاقة شخصية"),
    OptionItem(id: "2", title: "جواز سفر"),
    OptionItem(id: "3", title: "سجل تجارى")
  ]);
  OptionItem idOptionItemSelected =
  OptionItem(id: '', title: "قم بأختيار نوع الوثيقة");

  void changeLocationIndex(OptionItem optionItem) {
    cityOptionItemSelected = optionItem;
    emit(CustomerRegisterChangeCityState());
  }
  void changePaperIndex(OptionItem optionItem) {
    idOptionItemSelected = optionItem;
    emit(CustomerRegisterChangePaperState());
  }
}