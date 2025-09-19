// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
// import 'package:mbindiamy/controllers/filter_controller.dart';
// import 'package:mbindiamy/controllers/sales_by_branch_category_controller.dart';
// import 'package:mbindiamy/style/appstyle.dart';
// import 'package:mbindiamy/widget/appbar1_widget.dart';
// import 'package:mbindiamy/widget/navigator_widget.dart';
// import 'package:mbindiamy/model/sales_by_branch_category_actual_model.dart';
//
// class SalesReportPage extends StatefulWidget {
//   const SalesReportPage({super.key});
//
//   @override
//   State<SalesReportPage> createState() => _SalesReportPageState();
// }
//
// class _SalesReportPageState extends State<SalesReportPage> {
//   final FilterController filterController = Get.find<FilterController>();
//   final SalesByBranchCategoryController salesByBranchCategoryController =
//       Get.find<SalesByBranchCategoryController>();
//
//   var selectedBranches = <String>[].obs;
//   var selectedStartDate = Rx<DateTime?>(null);
//   var selectedEndDate = Rx<DateTime?>(null);
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Future<void> _initializeData() async {
//     try {
//       await filterController.loadFilters();
//
//       if (filterController.filterResponse.value?.data.branches.isNotEmpty ??
//           false) {
//         selectedBranches.assignAll(
//           filterController.filterResponse.value!.data.branches
//               .whereType<String>()
//               .toList(),
//         );
//         selectedStartDate.value = DateTime.now();
//         selectedEndDate.value = DateTime.now();
//         await _refreshData();
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//     }
//   }
//
//   List<String> get availableBranches {
//     return filterController.filterResponse.value?.data.branches
//             .whereType<String>()
//             .toList() ??
//         [];
//   }
//
//   String formatIndianNumber(double number) {
//     final formatter = NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 2,
//     );
//     return formatter.format(number);
//   }
//
//   String formatDate(DateTime? date) {
//     return date != null
//         ? DateFormat('dd MMM yyyy').format(date)
//         : "Select Date";
//   }
//
//   String formatDateForApi(DateTime date) {
//     return DateFormat('yyyy-MM-dd').format(date);
//   }
//
//   Future<void> pickStartDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedStartDate.value ?? now,
//       firstDate: DateTime(now.year - 2),
//       lastDate: now,
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: ColorScheme.light(
//             primary: AppStyle.appBarColor,
//             onPrimary: AppStyle.appBarTextColor,
//             surface: Colors.white,
//             onSurface: AppStyle.textColor,
//           ),
//         ),
//         child: child!,
//       ),
//     );
//
//     if (picked != null) {
//       selectedStartDate.value = picked;
//       if (selectedEndDate.value != null &&
//           selectedEndDate.value!.isBefore(picked)) {
//         selectedEndDate.value = picked;
//       }
//       await _refreshData();
//     }
//   }
//
//   Future<void> pickEndDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedEndDate.value ?? now,
//       firstDate: selectedStartDate.value ?? DateTime(now.year - 2),
//       lastDate: now,
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: ColorScheme.light(
//             primary: AppStyle.appBarColor,
//             onPrimary: AppStyle.appBarTextColor,
//             surface: Colors.white,
//             onSurface: AppStyle.textColor,
//           ),
//         ),
//         child: child!,
//       ),
//     );
//
//     if (picked != null) {
//       selectedEndDate.value = picked;
//       if (selectedStartDate.value == null ||
//           selectedStartDate.value!.isAfter(picked)) {
//         selectedStartDate.value = picked;
//       }
//       await _refreshData();
//     }
//   }
//
//   Future<void> _refreshData() async {
//     if (selectedBranches.isEmpty ||
//         selectedStartDate.value == null ||
//         selectedEndDate.value == null) {
//       return;
//     }
//
//     try {
//       await salesByBranchCategoryController.loadSalesData(
//         selectedBranches,
//         startDate: selectedStartDate.value,
//         endDate: selectedEndDate.value,
//       );
//
//       if (salesByBranchCategoryController
//               .salesData
//               .value
//               ?.data
//               .categorySales
//               .isNotEmpty ??
//           false) {
//         await Future.wait(
//           salesByBranchCategoryController.salesData.value!.data.categorySales
//               .map((category) async {
//                 try {
//                   await salesByBranchCategoryController.loadPromiseData(
//                     category.category,
//                     startDate: selectedStartDate.value,
//                     endDate: selectedEndDate.value,
//                   );
//                 } catch (e) {
//                   debugPrint(
//                     'Error loading promise data for ${category.category}: $e',
//                   );
//                 }
//               }),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error refreshing data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load data: ${e.toString()}')),
//       );
//     }
//   }
//
//   Future<void> chooseBranches() async {
//     final tempSelected = List<String>.from(selectedBranches);
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: Text('Select Branches', style: AppStyle.headTextStyle()),
//               content: availableBranches.isEmpty
//                   ? const Text('No branches available')
//                   : SizedBox(
//                       width: double.maxFinite,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   setDialogState(() {
//                                     tempSelected.clear();
//                                     tempSelected.addAll(availableBranches);
//                                   });
//                                 },
//                                 child: const Text('Select All'),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   setDialogState(() {
//                                     tempSelected.clear();
//                                   });
//                                 },
//                                 child: const Text('Clear'),
//                               ),
//                             ],
//                           ),
//                           ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxHeight:
//                                   MediaQuery.of(context).size.height * 0.4,
//                             ),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: availableBranches.length,
//                               itemBuilder: (context, index) {
//                                 final branch = availableBranches[index];
//                                 return CheckboxListTile(
//                                   title: Text(
//                                     branch,
//                                     style: AppStyle.normalTextStyle(),
//                                   ),
//                                   value: tempSelected.contains(branch),
//                                   onChanged: (bool? value) {
//                                     setDialogState(() {
//                                       if (value == true) {
//                                         tempSelected.add(branch);
//                                       } else {
//                                         tempSelected.remove(branch);
//                                       }
//                                     });
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, false),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, true),
//                   child: const Text('Apply'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//
//     if (result == true) {
//       selectedBranches.assignAll(tempSelected);
//       await _refreshData();
//     }
//   }
//
//   String getBranchLabel() {
//     if (selectedBranches.isEmpty) return 'Select Branches';
//     if (selectedBranches.length == availableBranches.length &&
//         availableBranches.isNotEmpty) {
//       return 'All Branches';
//     }
//     return '${selectedBranches.length} selected';
//   }
//
//   Future<void> _handleCategorySelection(String category) async {
//     try {
//       await salesByBranchCategoryController.loadPromiseData(
//         category,
//         startDate: selectedStartDate.value,
//         endDate: selectedEndDate.value,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load promise data: ${e.toString()}')),
//       );
//     }
//   }
//
//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 48),
//           const SizedBox(height: 16),
//           Text(
//             error,
//             style: AppStyle.normalTextStyle().copyWith(color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(onPressed: _refreshData, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.insert_chart_outlined, size: 48, color: Colors.grey),
//           const SizedBox(height: 16),
//           Text(
//             'No Data Available',
//             style: AppStyle.headTextStyle().copyWith(color: Colors.grey),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try selecting different branches or date range',
//             style: AppStyle.normalTextStyle().copyWith(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppStyle.init(context);
//
//     return Obx(
//       () => Scaffold(
//         backgroundColor: AppStyle.backgroundColor,
//         drawer: NavigationDrawerWidget(),
//         appBar: CustomAppBar1(
//           title: 'Category Wise Sales Report',
//           onNotificationPressed: () {
//             if (kDebugMode) {
//               print('Notification pressed');
//             }
//           },
//         ),
//         body: RefreshIndicator(
//           key: _refreshIndicatorKey,
//           onRefresh: _refreshData,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 12),
//                 _buildFilters(),
//                 const SizedBox(height: 12),
//                 if (filterController.isLoading.value)
//                   const Center(child: CircularProgressIndicator())
//                 else if (filterController.error.value != null)
//                   _buildErrorWidget(filterController.error.value!)
//                 else if (salesByBranchCategoryController.error.value != null)
//                   _buildErrorWidget(
//                     salesByBranchCategoryController.error.value!,
//                   )
//                 else if (salesByBranchCategoryController.salesData.value ==
//                         null ||
//                     salesByBranchCategoryController
//                         .salesData
//                         .value!
//                         .data
//                         .categorySales
//                         .isEmpty)
//                   _buildEmptyState()
//                 else ...[
//                   _buildSummaryCard(
//                     salesByBranchCategoryController
//                         .salesData
//                         .value!
//                         .data
//                         .totalSales,
//                     salesByBranchCategoryController.totalPromisedSales,
//                     salesByBranchCategoryController
//                             .salesData
//                             .value!
//                             .data
//                             .totalSales -
//                         salesByBranchCategoryController.totalPromisedSales,
//                     salesByBranchCategoryController
//                             .salesData
//                             .value!
//                             .data
//                             .categorySales
//                             .isNotEmpty
//                         ? salesByBranchCategoryController
//                               .salesData
//                               .value!
//                               .data
//                               .categorySales
//                               .reduce(
//                                 (a, b) => a.totalAmount > b.totalAmount ? a : b,
//                               )
//                         : null,
//                   ),
//                   const SizedBox(height: 20),
//                   Text("Sales Analysis", style: AppStyle.headTextStyle()),
//                   const SizedBox(height: 12),
//                   _buildPieChartCard(
//                     "Actual Sales",
//                     salesByBranchCategoryController
//                         .salesData
//                         .value!
//                         .data
//                         .categorySales,
//                     false,
//                   ),
//                   const SizedBox(height: 24),
//                   _buildPieChartCard(
//                     "Promised Sales",
//                     salesByBranchCategoryController
//                         .salesData
//                         .value!
//                         .data
//                         .categorySales,
//                     true,
//                   ),
//                   const SizedBox(height: 24),
//                   _buildPerformanceList(
//                     salesByBranchCategoryController
//                         .salesData
//                         .value!
//                         .data
//                         .categorySales,
//                   ),
//                 ],
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilters() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _filterButton(
//                   icon: Icons.location_on,
//                   label: getBranchLabel(),
//                   onTap: chooseBranches,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _filterButton(
//                   icon: Icons.calendar_month,
//                   label: 'Start: $selectedStartDate',
//                   onTap: pickStartDate,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _filterButton(
//                   icon: Icons.calendar_month,
//                   label: 'End: $selectedEndDate',
//                   onTap: pickEndDate,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _filterButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFFE2E8F0)),
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 18, color: AppStyle.appBarColor),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 label,
//                 style: AppStyle.normalTextStyle().copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSummaryCard(
//     double actualSales,
//     double promisedSales,
//     double difference,
//     CategorySales? trendingCategory,
//   ) {
//     final trendingName = trendingCategory?.category ?? 'Unknown';
//     final trendingAmount = trendingCategory?.totalAmount ?? 0.0;
//     final salesProvider = Get.find<SalesByBranchCategoryController>();
//     final totalsales = salesProvider.salesData.value?.data.totalSales;
//
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppStyle.appBarColor, AppStyle.appBarColor.withOpacity(0.7)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             blurRadius: 12,
//             color: Colors.black12,
//             offset: Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Total Sales (${formatDate(selectedStartDate.value)}) - ${formatDate(selectedEndDate.value)}",
//             style: AppStyle.normalTextStyle().copyWith(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           Text(
//             formatIndianNumber(totalsales!),
//             style: AppStyle.headTextStyle().copyWith(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//
//           const SizedBox(height: 12),
//
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.trending_up, color: Colors.white, size: 24),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Top Category",
//                         style: AppStyle.normalTextStyle().copyWith(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         trendingName,
//                         style: AppStyle.headTextStyle().copyWith(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       formatIndianNumber(trendingAmount),
//                       style: AppStyle.headTextStyle().copyWith(
//                         color: Colors.white,
//                         fontSize: 14,
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // const Icon(Icons.arrow_upward, color: Colors.white, size: 16),
//                         // Text(
//                         //   "2.7%",
//                         //   style: AppStyle.headTextStyle().copyWith(color: Colors.white, fontSize: 14),
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPieChartCard(
//     String title,
//     List<CategorySales> data,
//     bool isPromiseChart,
//   ) {
//     final total = isPromiseChart
//         ? data.fold<double>(
//             0.0,
//             (sum, e) =>
//                 sum +
//                 salesByBranchCategoryController.getPromiseAmountForCategory(
//                   e.category,
//                 ),
//           )
//         : data.fold<double>(0.0, (sum, e) => sum + e.totalAmount);
//     final palette = const [
//       Colors.blue,
//       Colors.purple,
//       Colors.orange,
//       Colors.teal,
//       Colors.red,
//       Colors.cyan,
//     ];
//
//     final slices = data.take(6).toList().asMap().entries.map((entry) {
//       final index = entry.key;
//       final category = entry.value;
//       final value = isPromiseChart
//           ? salesByBranchCategoryController.getPromiseAmountForCategory(
//               category.category,
//             )
//           : category.totalAmount;
//       final percent = total == 0 ? 0.0 : (value / total) * 100;
//       return _CategorySlice(
//         name: category.category,
//         value: percent,
//         color: palette[index % palette.length],
//       );
//     }).toList();
//
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 title,
//                 style: AppStyle.headTextStyle().copyWith(fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   centerSpaceRadius: 50,
//                   sections: slices
//                       .map(
//                         (s) => PieChartSectionData(
//                           value: s.value,
//                           title: "${s.value.toStringAsFixed(1)}%",
//                           radius: 50,
//                           titleStyle: AppStyle.normalTextStyle().copyWith(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                           color: s.color.withOpacity(0.9),
//                         ),
//                       )
//                       .toList(),
//                   sectionsSpace: 2,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 5),
//             Wrap(
//               spacing: 6,
//               runSpacing: 4,
//               children: slices
//                   .map(
//                     (s) => _legendItem(
//                       s.name,
//                       s.color,
//                       "${s.value.toStringAsFixed(1)}%",
//                     ),
//                   )
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPerformanceList(List<CategorySales> categories) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Category Performance Summary", style: AppStyle.headTextStyle()),
//         const SizedBox(height: 8),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: categories.length.clamp(0, 10),
//           itemBuilder: (context, index) {
//             final category = categories[index];
//             return GestureDetector(
//               onTap: () => _handleCategorySelection(category.category),
//               child: _buildPerformanceTile(category),
//             );
//           },
//         ),
//         // if (categories.length > 10)
//         //   Padding(
//         //     padding: const EdgeInsets.symmetric(vertical: 8),
//         //     child: TextButton(
//         //       onPressed: () {
//         //         if (kDebugMode) {
//         //           print('Show more categories clicked');
//         //         }
//         //       },
//         //       child: const Text('Show More'),
//         //     ),
//         //   ),
//       ],
//     );
//   }
//
//   Widget _buildPerformanceTile(CategorySales category) {
//     final amount = category.totalAmount;
//     final promisedAmount = salesByBranchCategoryController
//         .getPromiseAmountForCategory(category.category);
//     final difference = amount - promisedAmount;
//
//     return Card(
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               category.category,
//               style: AppStyle.headTextStyle().copyWith(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: _smallStat(
//                     "Promised",
//                     formatIndianNumber(promisedAmount),
//                   ),
//                 ),
//                 Expanded(
//                   child: _smallStat("Actual", formatIndianNumber(amount)),
//                 ),
//                 Expanded(
//                   child: _smallStat(
//                     "Difference",
//                     formatIndianNumber(difference),
//                     isPositive: difference >= 0,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _smallStat(String label, String value, {bool? isPositive}) {
//     Color? valueColor;
//     if (isPositive != null) {
//       valueColor = isPositive ? Colors.green : Colors.red;
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: AppStyle.normalTextStyle().copyWith(
//             fontSize: 12,
//             color: Colors.black54,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: AppStyle.normalTextStyle().copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: valueColor ?? Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _legendItem(String name, Color color, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 10,
//             height: 10,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             "$name $value",
//             style: AppStyle.normalTextStyle().copyWith(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CategorySlice {
//   final String name;
//   final double value;
//   final Color color;
//
//   _CategorySlice({
//     required this.name,
//     required this.value,
//     required this.color,
//   });
// }
