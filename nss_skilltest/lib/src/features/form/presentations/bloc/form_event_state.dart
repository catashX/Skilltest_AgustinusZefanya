import 'package:equatable/equatable.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object?> get props => [];
}

class FormUpdated extends FormEvent {
  final String? licensePlate;
  final String? mileage;
  final String? reason;
  final String? notes;
  final String? exteriorCondition;
  final String? engineCondition;
  final bool? isMoveable;
  final String? photoFrontPath;
  final String? photoBackPath;
  final String? photoLeftPath;
  final String? photoRightPath;
  final String? photoSpeedometerPath;
  final String? photoDebtorPath;
  final String? signaturePath;
  final String? address;

  const FormUpdated({
    this.licensePlate,
    this.mileage,
    this.reason,
    this.notes,
    this.exteriorCondition,
    this.engineCondition,
    this.isMoveable,
    this.photoFrontPath,
    this.photoBackPath,
    this.photoLeftPath,
    this.photoRightPath,
    this.photoSpeedometerPath,
    this.photoDebtorPath,
    this.signaturePath,
    this.address,
  });

  @override
  List<Object?> get props => [
        licensePlate,
        mileage,
        reason,
        notes,
        exteriorCondition,
        engineCondition,
        isMoveable,
        photoFrontPath,
        photoBackPath,
        photoLeftPath,
        photoRightPath,
        photoSpeedometerPath,
        photoDebtorPath,
        signaturePath,
        address,
      ];
}

class InspectionFormState extends Equatable {
  final String licensePlate;
  final String mileage;
  final String reason;
  final String notes;
  final String exteriorCondition;
  final String engineCondition;
  final bool? isMoveable;
  final String? photoFrontPath;
  final String? photoBackPath;
  final String? photoLeftPath;
  final String? photoRightPath;
  final String? photoSpeedometerPath;
  final String? photoDebtorPath;
  final String? signaturePath;
  final String address;

  const InspectionFormState({
    this.licensePlate = '',
    this.mileage = '',
    this.reason = '',
    this.notes = '',
    this.exteriorCondition = 'Baik',
    this.engineCondition = 'Hidup Normal',
    this.isMoveable,
    this.photoFrontPath,
    this.photoBackPath,
    this.photoLeftPath,
    this.photoRightPath,
    this.photoSpeedometerPath,
    this.photoDebtorPath,
    this.signaturePath,
    this.address = '',
  });

  InspectionFormState copyWith({
    String? licensePlate,
    String? mileage,
    String? reason,
    String? notes,
    String? exteriorCondition,
    String? engineCondition,
    bool? isMoveable,
    String? photoFrontPath,
    String? photoBackPath,
    String? photoLeftPath,
    String? photoRightPath,
    String? photoSpeedometerPath,
    String? photoDebtorPath,
    String? signaturePath,
    String? address,
  }) {
    return InspectionFormState(
      licensePlate: licensePlate ?? this.licensePlate,
      mileage: mileage ?? this.mileage,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      exteriorCondition: exteriorCondition ?? this.exteriorCondition,
      engineCondition: engineCondition ?? this.engineCondition,
      isMoveable: isMoveable ?? this.isMoveable,
      photoFrontPath: photoFrontPath ?? this.photoFrontPath,
      photoBackPath: photoBackPath ?? this.photoBackPath,
      photoLeftPath: photoLeftPath ?? this.photoLeftPath,
      photoRightPath: photoRightPath ?? this.photoRightPath,
      photoSpeedometerPath: photoSpeedometerPath ?? this.photoSpeedometerPath,
      photoDebtorPath: photoDebtorPath ?? this.photoDebtorPath,
      signaturePath: signaturePath ?? this.signaturePath,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'mileage': mileage,
      'reason': reason,
      'notes': notes,
      'exteriorCondition': exteriorCondition,
      'engineCondition': engineCondition,
      'isMoveable': isMoveable,
      'photoFrontPath': photoFrontPath,
      'photoBackPath': photoBackPath,
      'photoLeftPath': photoLeftPath,
      'photoRightPath': photoRightPath,
      'photoSpeedometerPath': photoSpeedometerPath,
      'photoDebtorPath': photoDebtorPath,
      'signaturePath': signaturePath,
      'address': address,
    };
  }

  factory InspectionFormState.fromJson(Map<String, dynamic> json) {
    return InspectionFormState(
      licensePlate: json['licensePlate'] ?? '',
      mileage: json['mileage'] ?? '',
      reason: json['reason'] ?? '',
      notes: json['notes'] ?? '',
      exteriorCondition: json['exteriorCondition'] ?? 'Baik',
      engineCondition: json['engineCondition'] ?? 'Hidup Normal',
      isMoveable: json['isMoveable'],
      photoFrontPath: json['photoFrontPath'],
      photoBackPath: json['photoBackPath'],
      photoLeftPath: json['photoLeftPath'],
      photoRightPath: json['photoRightPath'],
      photoSpeedometerPath: json['photoSpeedometerPath'],
      photoDebtorPath: json['photoDebtorPath'],
      signaturePath: json['signaturePath'],
      address: json['address'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        licensePlate,
        mileage,
        reason,
        notes,
        exteriorCondition,
        engineCondition,
        isMoveable,
        photoFrontPath,
        photoBackPath,
        photoLeftPath,
        photoRightPath,
        photoSpeedometerPath,
        photoDebtorPath,
        signaturePath,
        address,
      ];
}
