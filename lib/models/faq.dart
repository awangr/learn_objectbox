class FAQ {
  int? id;
  String? pertanyaan;
  String? jawaban;
  int? status;
  FAQ({this.id, this.pertanyaan, this.jawaban, this.status});
  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['ID'],
      pertanyaan: json['Pertanyaan'],
      jawaban: json['Jawaban'],
      status: json['Status'],
    );
  }
}
