class ReportReasonModel {
  final int id;
  final String reason;

  const ReportReasonModel({required this.id, required this.reason});

  factory ReportReasonModel.fromJson(Map<String, dynamic> json) {
    return ReportReasonModel(id: json['id'], reason: json['reason']);
  }
}
