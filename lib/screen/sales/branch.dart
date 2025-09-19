import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/controllers/sales_branch_controller.dart';
import 'package:mbindiamy/controllers/filter_controller.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar1_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';

class BranchWiseSalesScreen123 extends StatefulWidget {
  const BranchWiseSalesScreen123({super.key});

  @override
  State<BranchWiseSalesScreen123> createState() =>
      _BranchWiseSalesScreen123State();
}

class _BranchWiseSalesScreen123State extends State<BranchWiseSalesScreen123> {
  final SalesbranchController salesbranchController =
      Get.find<SalesbranchController>();
  final FilterController filterController = Get.find<FilterController>();

  RxList<String> selectedBranches = <String>[].obs;
  Rx<DateTime?> selectedStartDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> selectedEndDate = Rx<DateTime?>(DateTime.now());

  final logger = Logger();

  final List<Color> palette = const [
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF10B981),
    Color(0xFF8B5CF6),
    Color(0xFF0F7CFF),
    Color(0xFFEC4899),
    Color(0xFF22C55E),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppStyle.init(context);
      // No need to check token here, LoginController should handle it
      await filterController.loadFilters();

      // Initialize local selected branches with all available branches if not already selected
      final availableBranches =
          filterController.filterResponse.value?.data.branches ?? [];
      if (selectedBranches.isEmpty && availableBranches.isNotEmpty) {
        selectedBranches.value = availableBranches;
      }
      await _fetchSalesData();
    });
  }

  Future<void> _fetchSalesData() async {
    final from =
        selectedStartDate.value ??
        DateTime.now().subtract(const Duration(days: 30));
    final to = selectedEndDate.value ?? DateTime.now();
    final branch = selectedBranches.isEmpty
        ? 'all'
        : selectedBranches.join(',');

    logger.d(
      'Fetching sales for branch: $branch, from: ${DateFormat('yyyy-MM-dd').format(from)}, to: ${DateFormat('yyyy-MM-dd').format(to)}',
    );

    await salesbranchController.fetchData(
      startDate: from,
      endDate: to,
      branch: branch,
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    final f = DateFormat('LLLL yyyy');
    return f.format(date);
  }

  String getBranchLabel() {
    final availableBranches =
        filterController.filterResponse.value?.data.branches ?? [];
    logger.d('Available Branches: $availableBranches');
    if (selectedBranches.isEmpty) return 'Select Branches';
    if (selectedBranches.length == availableBranches.length &&
        availableBranches.isNotEmpty) {
      return 'All Branches';
    }
    return '${selectedBranches.length} selected';
  }

  Future<void> pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          selectedStartDate.value ?? now.subtract(const Duration(days: 30)),
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.appBarColor,
              onPrimary: AppStyle.appBarTextColor,
              surface: Colors.white,
              onSurface: AppStyle.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppStyle.appBarColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyle.w(12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.w(16),
                  vertical: AppStyle.h(8),
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyle.w(16)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedStartDate.value = picked;
      if (selectedEndDate.value == null ||
          picked.isAfter(selectedEndDate.value!)) {
        selectedEndDate.value = picked;
      }
      await _fetchSalesData();
    }
  }

  Future<void> pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.value ?? now,
      firstDate: selectedStartDate.value ?? DateTime(now.year - 2),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyle.appBarColor,
              onPrimary: AppStyle.appBarTextColor,
              surface: Colors.white,
              onSurface: AppStyle.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppStyle.appBarColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppStyle.w(12)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppStyle.w(16),
                  vertical: AppStyle.h(8),
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyle.w(16)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedEndDate.value = picked;
      if (selectedStartDate.value == null ||
          picked.isBefore(selectedStartDate.value!)) {
        selectedStartDate.value = picked;
      }
      await _fetchSalesData();
    }
  }

  Future<void> chooseBranches() async {
    final availableBranches =
        filterController.filterResponse.value?.data.branches ?? [];
    final tempSelected = List<String>.from(selectedBranches);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select Branches', style: AppStyle.headTextStyle()),
              content: availableBranches.isEmpty
                  ? const Text('No branches available')
                  : SizedBox(
                      width: double.maxFinite,
                      height: AppStyle.h(300),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setDialogState(() {
                                    tempSelected.clear();
                                    tempSelected.addAll(availableBranches);
                                  });
                                },
                                child: Text(
                                  'Select All',
                                  style: AppStyle.normalTextStyle(),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setDialogState(() {
                                    tempSelected.clear();
                                  });
                                },
                                child: Text(
                                  'Clear',
                                  style: AppStyle.normalTextStyle(),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: availableBranches.length,
                              itemBuilder: (context, index) {
                                final branch = availableBranches[index];
                                return CheckboxListTile(
                                  title: Text(
                                    branch,
                                    style: AppStyle.normalTextStyle(),
                                  ),
                                  value: tempSelected.contains(branch),
                                  onChanged: (bool? value) {
                                    setDialogState(() {
                                      if (value == true) {
                                        tempSelected.add(branch);
                                      } else {
                                        tempSelected.remove(branch);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: AppStyle.normalTextStyle()),
                ),
                TextButton(
                  onPressed: () async {
                    selectedBranches.value = tempSelected;
                    logger.d('Selected Branches: ${selectedBranches}');
                    await _fetchSalesData();
                    Navigator.pop(context);
                  },
                  child: Text('Apply', style: AppStyle.normalTextStyle()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the entire build method with Obx to react to changes in controllers
    return Obx(() {
      AppStyle.init(context); // Initialize AppStyle with context
      List<BranchPerformance> branches = [];
      double totalSales = 0.0;
      BranchPerformance? trendingBranch;
      String? errorMessage;

      // Handle salesResponse
      if (salesbranchController.salesResponse.value != null &&
          salesbranchController.salesResponse.value!.success) {
        final branchSales =
            salesbranchController.salesResponse.value!.data.branchSales;
        logger.d('Sales API Branch Sales: $branchSales');
        branches = branchSales.asMap().entries.map((entry) {
          final sale = entry.value;
          return BranchPerformance(
            name: sale.branchAlias,
            actual: sale.totalAmount,
            promised: 0.0,
            color: palette[entry.key % palette.length],
          );
        }).toList();
      }
      // Handle promiseResponse
      else if (salesbranchController.promiseResponse.value != null &&
          salesbranchController.promiseResponse.value!.success) {
        final locations =
            salesbranchController.promiseResponse.value!.data.locations;
        logger.d('Promise API Locations: $locations');
        branches = locations.asMap().entries.map((entry) {
          final location = entry.value;
          // Aggregate actual and promise values from dailyValues
          final totalActual = location.dailyValues.fold<double>(
            0.0,
            (sum, daily) => sum + daily.actual,
          );
          final totalPromised = location.dailyValues.fold<double>(
            0.0,
            (sum, daily) => sum + daily.promise,
          );
          return BranchPerformance(
            name: location.location,
            actual: totalActual,
            promised: totalPromised,
            color: palette[entry.key % palette.length],
          );
        }).toList();
      } else {
        errorMessage =
            salesbranchController.errorMessage.value ?? 'No data available';
      }

      logger.d('Mapped Branches: $branches');
      totalSales = branches.fold(0.0, (sum, b) => sum + b.actual);
      trendingBranch = branches.isNotEmpty
          ? branches.reduce((a, b) => a.actual > b.actual ? a : b)
          : null;

      // Filter branches based on selectedBranches
      final filteredBranches = selectedBranches.isEmpty
          ? branches
          : branches.where((b) => selectedBranches.contains(b.name)).toList();
      logger.d('Filtered Branches: $filteredBranches');

      return Scaffold(
        backgroundColor: AppStyle.backgroundColor,
        drawer: NavigationDrawerWidget(),
        appBar: CustomAppBar1(title: 'Branch Wise Sales'),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppStyle.w(16),
              AppStyle.h(12),
              AppStyle.w(16),
              AppStyle.h(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppStyle.h(12)),
                _buildFilters(),
                SizedBox(height: AppStyle.h(12)),
                if (salesbranchController.isLoading.value ||
                    filterController.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Column(
                    children: [
                      Center(
                        child: Text(
                          errorMessage,
                          style: AppStyle.normalTextStyle(),
                        ),
                      ),
                      SizedBox(height: AppStyle.h(12)),
                      ElevatedButton(
                        onPressed: _fetchSalesData,
                        child: Text('Retry', style: AppStyle.normalTextStyle()),
                      ),
                    ],
                  )
                else if (filterController.error.value != null)
                  Column(
                    children: [
                      Center(
                        child: Text(
                          filterController.error.value!,
                          style: AppStyle.normalTextStyle(),
                        ),
                      ),
                      SizedBox(height: AppStyle.h(12)),
                      ElevatedButton(
                        onPressed: () => filterController.loadFilters(),
                        child: Text(
                          'Retry Filters',
                          style: AppStyle.normalTextStyle(),
                        ),
                      ),
                    ],
                  )
                else if (filteredBranches.isEmpty)
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'No sales data available for selected branches',
                          style: AppStyle.normalTextStyle(),
                        ),
                      ),
                      SizedBox(height: AppStyle.h(12)),
                      ElevatedButton(
                        onPressed: _fetchSalesData,
                        child: Text('Retry', style: AppStyle.normalTextStyle()),
                      ),
                    ],
                  )
                else ...[
                  _buildTotalSalesCard(totalSales: totalSales),
                  SizedBox(height: AppStyle.h(16)),
                  if (trendingBranch != null &&
                      filteredBranches.contains(trendingBranch))
                    _buildTrendingManagerCard(
                      branchName: trendingBranch.name,
                      sales: trendingBranch.actual,
                    ),
                  SizedBox(height: AppStyle.h(20)),
                  _buildPieSummarySection(branches: filteredBranches),
                  SizedBox(height: AppStyle.h(20)),
                  _buildPerformanceHeader(),
                  SizedBox(height: AppStyle.h(12)),
                  ...filteredBranches.map((m) => _buildManagerTile(m)),
                  SizedBox(height: AppStyle.h(20)),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFilters() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: EdgeInsets.all(AppStyle.w(14)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _filterButton(
                  icon: Icons.location_on,
                  label: getBranchLabel(),
                  onTap: chooseBranches,
                ),
              ),
            ],
          ),
          SizedBox(height: AppStyle.h(12)),
          Row(
            children: [
              Expanded(
                child: _filterButton(
                  icon: Icons.calendar_month,
                  label: 'Start: ${formatDate(selectedStartDate.value)}',
                  onTap: pickStartDate,
                ),
              ),
              SizedBox(width: AppStyle.w(12)),
              Expanded(
                child: _filterButton(
                  icon: Icons.calendar_month,
                  label: 'End: ${formatDate(selectedEndDate.value)}',
                  onTap: pickEndDate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppStyle.h(12),
          horizontal: AppStyle.w(12),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(AppStyle.w(10)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppStyle.w(18), color: AppStyle.appBarColor),
            SizedBox(width: AppStyle.w(8)),
            Expanded(
              child: Text(
                label,
                style: AppStyle.normalTextStyle().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: AppStyle.w(20),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingManagerCard({
    required String branchName,
    required double sales,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppStyle.w(16),
        vertical: AppStyle.h(18),
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8F3FF),
            ),
            padding: EdgeInsets.all(AppStyle.w(12)),
            child: Icon(
              Icons.trending_up,
              color: const Color(0xFF0F7CFF),
              size: AppStyle.w(24),
            ),
          ),
          SizedBox(width: AppStyle.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trending Branch",
                  style: AppStyle.normalTextStyle().copyWith(
                    color: Colors.grey,
                    fontSize: AppStyle.normalFontSize * 0.8,
                  ),
                ),
                SizedBox(height: AppStyle.h(4)),
                Text(branchName, style: AppStyle.headTextStyle()),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sales.format(),
                style: AppStyle.normalTextStyle().copyWith(
                  fontSize: AppStyle.normalFontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F7CFF),
                ),
              ),
              SizedBox(height: AppStyle.h(4)),
              Text(
                "Highest Sales",
                style: AppStyle.normalTextStyle().copyWith(
                  fontSize: AppStyle.normalFontSize * 0.75,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSalesCard({required double totalSales}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppStyle.w(16),
        vertical: AppStyle.h(18),
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 232, 255, 236),
            ),
            padding: EdgeInsets.all(AppStyle.w(12)),
            child: Icon(
              Icons.currency_rupee,
              color: const Color(0xFF008060),
              size: AppStyle.w(24),
            ),
          ),
          SizedBox(width: AppStyle.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Sales",
                  style: AppStyle.normalTextStyle().copyWith(
                    color: Colors.grey,
                    fontSize: AppStyle.normalFontSize * 0.8,
                  ),
                ),
                SizedBox(height: AppStyle.h(4)),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDate(selectedStartDate.value),
                        style: AppStyle.normalTextStyle().copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        formatDate(selectedEndDate.value),
                        style: AppStyle.normalTextStyle().copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalSales.format(),
                style: AppStyle.normalTextStyle().copyWith(
                  fontSize: AppStyle.normalFontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF008060),
                ),
              ),
              SizedBox(height: AppStyle.h(4)),
              Text(
                selectedBranches.isEmpty
                    ? "All Branches"
                    : "${selectedBranches.length} Branches",
                style: AppStyle.normalTextStyle().copyWith(
                  fontSize: AppStyle.normalFontSize * 0.75,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieSummarySection({required List<BranchPerformance> branches}) {
    final totalActual = branches.fold(0.0, (p, e) => p + e.actual);

    if (totalActual == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Branch-wise Sales", style: AppStyle.headTextStyle()),
          SizedBox(height: AppStyle.h(8)),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppStyle.w(14)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppStyle.h(20),
              horizontal: AppStyle.w(16),
            ),
            child: Text(
              "No sales data available for the selected branches",
              style: AppStyle.normalTextStyle().copyWith(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    final slices = branches.asMap().entries.map((entry) {
      final m = entry.value;
      final percent = (m.actual / totalActual) * 100;
      return PieChartSectionData(
        value: m.actual,
        title: "${percent.toStringAsFixed(1)}%",
        radius: AppStyle.w(50),
        titleStyle: AppStyle.normalTextStyle().copyWith(
          fontSize: AppStyle.normalFontSize * 0.65,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        color: m.color,
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();

    logger.d('Pie Chart Slices: $slices');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Branch-wise Sales", style: AppStyle.headTextStyle()),
        SizedBox(height: AppStyle.h(8)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppStyle.w(14)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            vertical: AppStyle.h(20),
            horizontal: AppStyle.w(16),
          ),
          child: Column(
            children: [
              SizedBox(
                height: AppStyle.h(180),
                child: PieChart(
                  PieChartData(
                    sections: slices,
                    centerSpaceRadius: AppStyle.w(40),
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(enabled: true),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 400),
                ),
              ),
              SizedBox(height: AppStyle.h(12)),
              Wrap(
                spacing: AppStyle.w(10),
                runSpacing: AppStyle.h(6),
                children: branches.map((m) {
                  final percent = (m.actual / totalActual) * 100;
                  return _legendItem(
                    name: m.name,
                    value: "${percent.toStringAsFixed(1)}%",
                    color: m.color,
                  );
                }).toList(),
              ),
              SizedBox(height: AppStyle.h(6)),
              Text(
                "Sales contribution per branch",
                style: AppStyle.normalTextStyle().copyWith(
                  fontSize: AppStyle.normalFontSize * 0.75,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendItem({
    required String name,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppStyle.h(6),
        horizontal: AppStyle.w(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(8)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppStyle.w(10),
            height: AppStyle.h(10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: AppStyle.w(6)),
          Text(
            name,
            style: AppStyle.normalTextStyle().copyWith(
              fontSize: AppStyle.normalFontSize * 0.75,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppStyle.w(6)),
          Text(
            value,
            style: AppStyle.normalTextStyle().copyWith(
              fontSize: AppStyle.normalFontSize * 0.75,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text("Branch Sales", style: AppStyle.headTextStyle())),
      ],
    );
  }

  Widget _buildManagerTile(BranchPerformance m) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppStyle.h(8)),
      padding: EdgeInsets.all(AppStyle.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(12)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  m.name,
                  style: AppStyle.normalTextStyle().copyWith(
                    fontSize: AppStyle.normalFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppStyle.h(12)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sales",
                      style: AppStyle.normalTextStyle().copyWith(
                        fontSize: AppStyle.normalFontSize * 0.75,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: AppStyle.h(4)),
                    Text(
                      m.actual.format(),
                      style: AppStyle.normalTextStyle().copyWith(
                        fontSize: AppStyle.normalFontSize * 0.85,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension DoubleFormat on double {
  String format() {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }
}

class BranchPerformance {
  final String name;
  final double actual;
  final double promised;
  final Color color;

  const BranchPerformance({
    required this.name,
    required this.actual,
    required this.promised,
    this.color = const Color(0xFF0F7CFF),
  });
}
