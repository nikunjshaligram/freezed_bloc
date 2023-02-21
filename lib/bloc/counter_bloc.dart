import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'counter_event.dart';
part 'counter_state.dart';
part 'counter_bloc.freezed.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const _Initial()) {
    on<CounterEvent>(
      (event, emit) async {
        if (state is _Initial) {
          emit(const CounterState.running(0));
        } else if (state is _Running) {
          int number = (state as _Running).number;
          emit(const CounterState.loading());
          emit(
            await event.when<Future<CounterState>>(
              increment: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                return CounterState.running(number + 1);
              },
              decrement: () async {
                await Future.delayed(const Duration(milliseconds: 500));
                return CounterState.running(number - 1);
              },
            ),
          );
        }
      },
    );
  }
}
