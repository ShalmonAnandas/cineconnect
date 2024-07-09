import 'package:equatable/equatable.dart';

class StreamModel extends Equatable {
  const StreamModel({
    required this.video,
    required this.videoTmp,
    required this.thirdParty,
    required this.type,
    required this.id,
    required this.dataSaver,
    required this.a,
    required this.b,
    required this.dType,
  });

  final String? video;
  final String? videoTmp;
  final String? thirdParty;
  final int? type;
  final dynamic id;
  final dynamic dataSaver;
  final dynamic a;
  final dynamic b;
  final dynamic dType;

  StreamModel copyWith({
    String? video,
    String? videoTmp,
    String? thirdParty,
    int? type,
    dynamic id,
    dynamic dataSaver,
    dynamic a,
    dynamic b,
    dynamic dType,
  }) {
    return StreamModel(
      video: video ?? this.video,
      videoTmp: videoTmp ?? this.videoTmp,
      thirdParty: thirdParty ?? this.thirdParty,
      type: type ?? this.type,
      id: id ?? this.id,
      dataSaver: dataSaver ?? this.dataSaver,
      a: a ?? this.a,
      b: b ?? this.b,
      dType: dType ?? this.dType,
    );
  }

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      video: json["Video"],
      videoTmp: json["Video_tmp"],
      thirdParty: json["ThirdParty"],
      type: json["Type"],
      id: json["id"],
      dataSaver: json["dataSaver"],
      a: json["a"],
      b: json["b"],
      dType: json["dType"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Video": video,
        "Video_tmp": videoTmp,
        "ThirdParty": thirdParty,
        "Type": type,
        "id": id,
        "dataSaver": dataSaver,
        "a": a,
        "b": b,
        "dType": dType,
      };

  @override
  String toString() {
    return "$video, $videoTmp, $thirdParty, $type, $id, $dataSaver, $a, $b, $dType, ";
  }

  @override
  List<Object?> get props => [
        video,
        videoTmp,
        thirdParty,
        type,
        id,
        dataSaver,
        a,
        b,
        dType,
      ];
}
