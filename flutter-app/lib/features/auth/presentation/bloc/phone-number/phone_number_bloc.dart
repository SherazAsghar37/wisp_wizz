import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'phone_number_event.dart';
part 'phone_number_state.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState> {
  PhoneNumberBloc()
      : super(PhoneNumberInitial(
            textEditingController: TextEditingController())) {
    on<InsertEvent>(onInsertEvent);
    on<BackspaceEvent>(onBackSpace);
    on<ClearEvent>(onClear);
  }
  FutureOr<void> onInsertEvent(
      InsertEvent event, Emitter<PhoneNumberState> emit) async {
    final TextEditingController controller = state.textEditingController;
    controller.value = TextEditingValue(
      text: "${controller.text}${event.value}",
    );
    emit(PhoneNumberUpdated(
      textEditingController: controller,
    ));
  }

  FutureOr<void> onBackSpace(
      BackspaceEvent event, Emitter<PhoneNumberState> emit) {
    final TextEditingController controller = state.textEditingController;
    if (controller.text.isNotEmpty) {
      controller.value = TextEditingValue(
        text: controller.text.substring(0, controller.text.length - 1),
      );
    }
    emit(PhoneNumberUpdated(
      textEditingController: controller,
    ));
  }

  void onClear(ClearEvent event, Emitter<PhoneNumberState> emit) {
    state.textEditingController.clear();
    emit(PhoneNumberUpdated(
      textEditingController: state.textEditingController,
    ));
  }
}
