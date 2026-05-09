import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'form_event_state.dart';

class FormBloc extends HydratedBloc<FormEvent, InspectionFormState> {
  FormBloc() : super(const InspectionFormState()) {
    on<FormUpdated>((event, emit) {
      emit(state.copyWith(
        licensePlate: event.licensePlate,
        mileage: event.mileage,
        reason: event.reason,
        notes: event.notes,
        exteriorCondition: event.exteriorCondition,
        engineCondition: event.engineCondition,
        isMoveable: event.isMoveable,
        photoFrontPath: event.photoFrontPath,
        photoBackPath: event.photoBackPath,
        photoLeftPath: event.photoLeftPath,
        photoRightPath: event.photoRightPath,
        photoSpeedometerPath: event.photoSpeedometerPath,
        photoDebtorPath: event.photoDebtorPath,
        signaturePath: event.signaturePath,
        address: event.address,
      ));
    });
  }

  @override
  InspectionFormState? fromJson(Map<String, dynamic> json) {
    return InspectionFormState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(InspectionFormState state) {
    return state.toJson();
  }
}
