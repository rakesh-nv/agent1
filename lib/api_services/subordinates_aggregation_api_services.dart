// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../model/subordinates_aggregation_model.dart';
//
// class SubordinatesAggregationApiService {
//   final String baseUrl =
//       "https://reports-mb-dev-backend.cstechns.com/api/mobile/subordinates-sales-vs-promise";
//
//   Future<SubordinatesAggregationResponse?> fetchSubordinatesAggregation({
//   }) async {
//     try {
//
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "preset": "thismonth", // e.g. "thismonth", "lastmonth", "custom"
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return SubordinatesAggregationResponse.fromJson(data);
//       } else {
//         print("Error: ${response.statusCode}, ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("Exception in fetchSubordinatesAggregation: $e");
//       return null;
//     }
//   }
// }
