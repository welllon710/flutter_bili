class ApiResponse<T> {
  final int code;
  final String? msg;
  final List<T> data;

  ApiResponse({required this.code, this.msg, required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonModel,
  ) {
    var dataList = json['data'] as List;
    List<T> data = dataList.map((i) => fromJsonModel(i)).toList();

    return ApiResponse(code: json['code'], msg: json['msg'], data: data);
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonModel) {
    return {
      'code': code,
      'msg': msg,
      'data': data.map((item) => toJsonModel(item)).toList(),
    };
  }
}
