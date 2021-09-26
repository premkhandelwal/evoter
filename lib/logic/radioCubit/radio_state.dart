part of 'radio_cubit.dart';



class  RadioState {
  final bool radioVal;

  RadioState({required this.radioVal});



  RadioState copyWith({
    bool? radioVal,
  }) {
    return RadioState(
      radioVal: radioVal ?? this.radioVal,
    );
  }
}

class RadioValTrue extends RadioState{
  RadioValTrue() : super(radioVal: true);
}

class RadioValFalse extends RadioState{
  RadioValFalse() : super(radioVal: false);
}

