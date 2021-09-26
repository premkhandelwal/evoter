import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'radio_state.dart';
class RadiocubitCubit extends Cubit<RadioState> {
  RadiocubitCubit() : super(RadioState(radioVal: false));
  void changeRadioVal(bool newValue) {

      if (newValue) {
        emit(RadioValTrue());
      } else {
        emit(RadioValFalse());
      }
  }
}
