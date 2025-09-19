import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar1_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';


class Branches {
  final String? branchName;
  final int? openingStockQty;
  final int? closingStockQty;

  Branches({this.branchName, this.openingStockQty, this.closingStockQty});
}

class StockUnitWiseSalesScreen extends StatefulWidget {
  const StockUnitWiseSalesScreen({super.key});

  @override
  State<StockUnitWiseSalesScreen> createState() => _StockUnitWiseSalesScreenState();
}

class _StockUnitWiseSalesScreenState extends State<StockUnitWiseSalesScreen> {
  List<String> selectedBranches = ['Branch A', 'Branch B', 'Branch C'];
  DateTime? selectedStartDate = DateTime(2025, 7, 1);
  DateTime? selectedEndDate = DateTime(2025, 7, 31);
  final List<String> availableBranches = ['Branch A', 'Branch B', 'Branch C'];

  // Dummy data
  final List<Branches> dummyBranches = [
    Branches(branchName: 'North', openingStockQty: 1500, closingStockQty: 1200),
    Branches(branchName: 'South', openingStockQty: 2000, closingStockQty: 1800),
    Branches(branchName: 'East', openingStockQty: 1000, closingStockQty: 800),
    Branches(branchName: 'West', openingStockQty: 1800, closingStockQty: 1500),
  ];

  int get totalOpeningStockQty => dummyBranches.fold(0, (sum, e) => sum + (e.openingStockQty ?? 0));
  int get totalClosingStockQty => dummyBranches.fold(0, (sum, e) => sum + (e.closingStockQty ?? 0));

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    final f = DateFormat('dd MMM yyyy');
    return f.format(date);
  }

  Future<void> pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? now.subtract(const Duration(days: 30)),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(12))),
                padding: EdgeInsets.symmetric(horizontal: AppStyle.w(16), vertical: AppStyle.h(8)),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(16))),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
        if (selectedEndDate == null || picked.isAfter(selectedEndDate!)) {
          selectedEndDate = picked;
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? now,
      firstDate: selectedStartDate ?? DateTime(now.year - 2),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(12))),
                padding: EdgeInsets.symmetric(horizontal: AppStyle.w(16), vertical: AppStyle.h(8)),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(16))),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
        if (selectedStartDate == null || picked.isBefore(selectedStartDate!)) {
          selectedStartDate = picked;
        }
      });
    }
  }

  Future<void> chooseBranches() async {
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
                      height: AppStyle.screenHeight * 0.4,
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
                                child: const Text('Select All'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setDialogState(() {
                                    tempSelected.clear();
                                  });
                                },
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: availableBranches.length,
                              itemBuilder: (context, index) {
                                final branch = availableBranches[index];
                                return CheckboxListTile(
                                  title: Text(branch, style: AppStyle.normalTextStyle()),
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
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedBranches = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String getBranchLabel() {
    if (selectedBranches.isEmpty) return 'Select Branches';
    if (selectedBranches.length == availableBranches.length && availableBranches.isNotEmpty) {
      return 'All Branches';
    }
    return '${selectedBranches.length} selected';
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: AppStyle.backgroundColor,
      
      appBar: CustomAppBar1(title: 'Stock Qty Wise Sales'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(AppStyle.w(16), AppStyle.h(16), AppStyle.w(16), AppStyle.h(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(),
              SizedBox(height: AppStyle.h(16)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppStyle.w(16)),
                  border: Border.all(color: const Color(0xFFE8EDF3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(AppStyle.w(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        title: "Opening Balance Stock",
                        value: totalOpeningStockQty,
                        color: const Color(0xFF33B37A),
                      ),
                    ),
                    SizedBox(width: AppStyle.w(12)),
                    Expanded(
                      child: _summaryCard(
                        title: "Running Closing Stock",
                        value: totalClosingStockQty,
                        color: AppStyle.appBarColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppStyle.h(24)),
              _buildBranchPieChart(
                selectedBranches.length == availableBranches.length
                    ? dummyBranches
                    : dummyBranches.where((b) => selectedBranches.contains(b.branchName)).toList(),
              ),
              SizedBox(height: AppStyle.h(24)),
              ...(selectedBranches.length == availableBranches.length
                      ? dummyBranches
                      : dummyBranches.where((b) => selectedBranches.contains(b.branchName)).toList())
                  .map((b) => _buildBranchTile(b)),
              SizedBox(height: AppStyle.h(12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
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
                  label: 'Start: ${formatDate(selectedStartDate)}',
                  onTap: pickStartDate,
                ),
              ),
              SizedBox(width: AppStyle.w(12)),
              Expanded(
                child: _filterButton(
                  icon: Icons.calendar_month,
                  label: 'End: ${formatDate(selectedEndDate)}',
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
        padding: EdgeInsets.symmetric(vertical: AppStyle.h(12), horizontal: AppStyle.w(12)),
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
                style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: AppStyle.w(20), color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required num value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(16), horizontal: AppStyle.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        border: Border.all(color: const Color(0xFFE8EDF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: AppStyle.h(14)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stock Qty",
                style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.75, color: Colors.black54),
              ),
              SizedBox(height: AppStyle.h(4)),
              Text(
                value.toString(),
                style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchPieChart(List<Branches> data) {
    final totalUnits = data.fold<double>(0, (sum, e) => sum + (e.closingStockQty ?? 0));
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFF0F7CFF),
      const Color(0xFFEC4899),
      const Color(0xFF22C55E),
    ];

    final sections = List.generate(data.length, (i) {
      final b = data[i];
      final percent = totalUnits == 0 ? 0.0 : ((b.closingStockQty ?? 0) / totalUnits) * 100;
      return PieChartSectionData(
        value: percent,
        title: "${percent.toStringAsFixed(1)}%",
        radius: AppStyle.w(52),
        titleStyle: AppStyle.normalTextStyle().copyWith(
          fontSize: AppStyle.normalFontSize * 0.65,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        color: colors[i % colors.length],
        titlePositionPercentageOffset: 0.55,
      );
    });

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(16)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
      ),
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(18), horizontal: AppStyle.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Branch-wise Stock Units", style: AppStyle.headTextStyle()),
          SizedBox(height: AppStyle.h(8)),
          SizedBox(
            height: AppStyle.h(220),
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: AppStyle.w(50),
                    sectionsSpace: 3,
                    pieTouchData: PieTouchData(enabled: true),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 400),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      totalUnits.toStringAsFixed(0),
                      style: AppStyle.normalTextStyle().copyWith(
                        fontSize: AppStyle.normalFontSize * 1.2,
                        color: AppStyle.appBarColor,
                      ),
                    ),
                    SizedBox(height: AppStyle.h(4)),
                    Text(
                      "Total Units",
                      style: AppStyle.normalTextStyle().copyWith(
                        fontSize: AppStyle.normalFontSize * 0.75,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppStyle.h(12)),
          Wrap(
            spacing: AppStyle.w(8),
            runSpacing: AppStyle.h(8),
            children: List.generate(data.length, (i) {
              final b = data[i];
              final percent = totalUnits == 0 ? 0.0 : ((b.closingStockQty ?? 0) / totalUnits) * 100;
              return _legendItem(
                name: b.branchName ?? 'Unknown',
                value: "${percent.toStringAsFixed(1)}%",
                color: colors[i % colors.length],
              );
            }),
          ),
          SizedBox(height: AppStyle.h(6)),
          Text(
            "Units in stock per branch",
            style: AppStyle.normalTextStyle().copyWith(
              fontSize: AppStyle.normalFontSize * 0.75,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem({
    required String name,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(6), horizontal: AppStyle.w(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(8)),
        border: Border.all(color: const Color(0xFFE1E8F5)),
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

  Widget _buildBranchTile(Branches b) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppStyle.h(6)),
      padding: EdgeInsets.all(AppStyle.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        border: Border.all(color: const Color(0xFFE8EDF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            b.branchName ?? 'Unknown',
            style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize),
          ),
          SizedBox(height: AppStyle.h(12)),
          Divider(color: Colors.grey.shade200, height: 1),
          SizedBox(height: AppStyle.h(12)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Opening Stock Qty",
                      style: AppStyle.normalTextStyle().copyWith(
                        fontSize: AppStyle.normalFontSize * 0.75,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: AppStyle.h(6)),
                    Text(
                      (b.openingStockQty ?? 0).toString(),
                      style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Closing Stock Qty",
                      style: AppStyle.normalTextStyle().copyWith(
                        fontSize: AppStyle.normalFontSize * 0.75,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: AppStyle.h(6)),
                    Text(
                      (b.closingStockQty ?? 0).toString(),
                      style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600),
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