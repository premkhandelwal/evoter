part of 'checkbox_cubit.dart';



class  CheckBoxState {
  final bool checkBoxVal;

  CheckBoxState({required this.checkBoxVal});



  CheckBoxState copyWith({
    bool? checkBoxVal,
  }) {
    return CheckBoxState(
      checkBoxVal: checkBoxVal ?? this.checkBoxVal,
    );
  }
}

class CheckboxValTrue extends CheckBoxState{
  CheckboxValTrue() : super(checkBoxVal: true);
}

class CheckboxValFalse extends CheckBoxState{
  CheckboxValFalse() : super(checkBoxVal: false);
}

