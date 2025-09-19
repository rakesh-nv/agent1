import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar1_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';
// Added for kDebugMode if needed

// Extension for Indian Rupee formatting
extension INR on num {
  String format() {
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    return f.format(this);
  }
}

// Mock data model to replace Areamanage
class MockAreamanage {
  final double totalSales;
  final String date;
  final ManagerPerformance? topTrendingManager;
  final List<ManagerPerformance> managersPerformance;

  MockAreamanage({
    required this.totalSales,
    required this.date,
    this.topTrendingManager,
    required this.managersPerformance,
  });
}

// Mock ManagerPerformance class
class ManagerPerformance {
  final String name;
  final double actual;
  final double promised;
  final Color color;

  const ManagerPerformance({
    required this.name,
    required this.actual,
    required this.promised,
    this.color = const Color(0xFF0F7CFF),
  });
}

class AreaManagerSalesScreen extends StatefulWidget {
  const AreaManagerSalesScreen({super.key});

  @override
  State<AreaManagerSalesScreen> createState() => _AreaManagerSalesScreenState();
}

class _AreaManagerSalesScreenState extends State<AreaManagerSalesScreen> {
  List<String> selectedBranches = ['Branch A', 'Branch B', 'Branch C'];
  DateTime? selectedStartDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime? selectedEndDate = DateTime.now();

  final List<String> availableBranches = ['Branch A', 'Branch B', 'Branch C'];

  // Mock data
  late final MockAreamanage mockData = MockAreamanage(
    totalSales: 500000.0,
    date: formatRange(), // Dynamically set date based on selected range
    topTrendingManager: const ManagerPerformance(
      name: 'John Doe',
      actual: 150000.0,
      promised: 120000.0,
    ),
    managersPerformance: [
      const ManagerPerformance(name: 'John Doe', actual: 150000.0, promised: 120000.0),
      const ManagerPerformance(name: 'Jane Smith', actual: 120000.0, promised: 130000.0),
      const ManagerPerformance(name: 'Alex Brown', actual: 100000.0, promised: 90000.0),
      const ManagerPerformance(name: 'Emily Davis', actual: 80000.0, promised: 85000.0),
      const ManagerPerformance(name: 'Michael Lee', actual: 50000.0, promised: 60000.0),
    ],
  );

  // Palette for managers
  final List<Color> palette = const [
    Color(0xFF3B82F6), // Blue
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF10B981), // Green
    Color(0xFF8B5CF6), // Purple
    Color(0xFF0F7CFF), // Deep Blue
    Color(0xFFEC4899), // Pink
    Color(0xFF22C55E), // Lime
  ];

  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    final f = DateFormat('dd MMM yyyy');
    return f.format(date);
  }

  String formatRange() {
    final start = selectedStartDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = selectedEndDate ?? DateTime.now();
    final f = DateFormat('dd MMM yyyy');
    return "${f.format(start)} - ${f.format(end)}";
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
  Widget build(context) {
    AppStyle.init(context);
    final appStyle = AppStyle(context);

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar1(
        title: 'Area Manager Wise Sales',
        onNotificationPressed: () {
          print('Notification pressed');
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(AppStyle.w(16), AppStyle.h(12), AppStyle.w(16), AppStyle.h(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppStyle.h(12)),
            _buildFilters(appStyle),
            SizedBox(height: AppStyle.h(12)),
            _buildTotalSalesCard(appStyle, mockData),
            SizedBox(height: AppStyle.h(16)),
            _buildTrendingManagerCard(appStyle, mockData),
            SizedBox(height: AppStyle.h(20)),
            _buildPieSummarySection(appStyle, mockData),
            SizedBox(height: AppStyle.h(20)),
            _buildPerformanceHeader(appStyle, mockData),
            SizedBox(height: AppStyle.h(12)),
            ...mockData.managersPerformance.asMap().entries.map((entry) {
              final index = entry.key;
              final manager = entry.value;
              return _buildManagerTile(
                ManagerPerformance(
                  name: manager.name,
                  actual: manager.actual,
                  promised: manager.promised,
                  color: palette[index % palette.length],
                ),
                appStyle,
              );
            }),
            SizedBox(height: AppStyle.h(22)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(AppStyle appStyle) {
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
                  appStyle: appStyle,
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
                  appStyle: appStyle,
                ),
              ),
              SizedBox(width: AppStyle.w(12)),
              Expanded(
                child: _filterButton(
                  icon: Icons.calendar_month,
                  label: 'End: ${formatDate(selectedEndDate)}',
                  onTap: pickEndDate,
                  appStyle: appStyle,
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
    required AppStyle appStyle,
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

  Widget _buildTrendingManagerCard(AppStyle appStyle, MockAreamanage? data) {
    final trendingManager = data?.topTrendingManager?.name ?? 'Unknown';
    final trendingManagerSales = data?.topTrendingManager?.actual ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: EdgeInsets.symmetric(horizontal: AppStyle.w(16), vertical: AppStyle.h(18)),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppStyle.backgroundColor),
            padding: EdgeInsets.all(AppStyle.w(12)),
            child: Icon(Icons.trending_up, color: AppStyle.appBarColor, size: AppStyle.w(24)),
          ),
          SizedBox(width: AppStyle.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trending Manager", style: AppStyle.normalTextStyle().copyWith(color: Colors.grey, fontSize: AppStyle.normalFontSize * 0.8)),
                SizedBox(height: AppStyle.h(4)),
                Text(trendingManager, style: AppStyle.normalTextStyle()),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trendingManagerSales.format(),
                style: AppStyle.headTextStyle().copyWith(color: AppStyle.appBarColor, fontSize: AppStyle.normalFontSize),
              ),
              SizedBox(height: AppStyle.h(4)),
              Text("Highest Sales", style: AppStyle.normalTextStyle().copyWith(color: Colors.grey, fontSize: AppStyle.normalFontSize * 0.75)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSalesCard(AppStyle appStyle, MockAreamanage? data) {
    final totalSales = data?.totalSales ?? 0.0;
    final date = data?.date ?? formatRange();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: EdgeInsets.symmetric(horizontal: AppStyle.w(16), vertical: AppStyle.h(18)),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppStyle.backgroundColor),
            padding: EdgeInsets.all(AppStyle.w(12)),
            child: Icon(Icons.currency_rupee, color: AppStyle.appBarColor, size: AppStyle.w(24)),
          ),
          SizedBox(width: AppStyle.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Sales", style: AppStyle.normalTextStyle().copyWith(color: Colors.grey, fontSize: AppStyle.normalFontSize * 0.8)),
                SizedBox(height: AppStyle.h(4)),
                Text(
                  date,
                  style: AppStyle.normalTextStyle(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalSales.format(),
                style: AppStyle.headTextStyle().copyWith(color: AppStyle.appBarColor, fontSize: AppStyle.normalFontSize),
              ),
              SizedBox(height: AppStyle.h(4)),
              Text("All Managers", style: AppStyle.normalTextStyle().copyWith(color: Colors.grey, fontSize: AppStyle.normalFontSize * 0.75)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieSummarySection(AppStyle appStyle, MockAreamanage? data) {
    final managers = data?.managersPerformance ?? [];
    final totalActual = managers.fold(0.0, (p, e) => p + e.actual);
    final slices = managers.asMap().entries.map((entry) {
      final index = entry.key;
      final m = entry.value;
      final percent = totalActual == 0 ? 0.0 : (m.actual / totalActual) * 100;
      return PieChartSectionData(
        value: percent,
        title: "${percent.toStringAsFixed(1)}%",
        radius: AppStyle.w(50),
        titleStyle: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.6, fontWeight: FontWeight.w600, color: Colors.black87),
        color: palette[index % palette.length],
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Area Manager wise Sale", style: AppStyle.headTextStyle()),
        SizedBox(height: AppStyle.h(8)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppStyle.w(14)),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
          ),
          padding: EdgeInsets.symmetric(vertical: AppStyle.h(20), horizontal: AppStyle.w(16)),
          child: Column(
            children: [
              SizedBox(height: AppStyle.h(12)),
              SizedBox(
                height: AppStyle.h(180),
                child: PieChart(
                  PieChartData(
                    sections: slices,
                    centerSpaceRadius: AppStyle.w(40),
                    sectionsSpace: 2,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 400),
                ),
              ),
              SizedBox(height: AppStyle.h(12)),
              Wrap(
                spacing: AppStyle.w(10),
                runSpacing: AppStyle.h(6),
                children: managers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final m = entry.value;
                  final percent = totalActual == 0 ? 0.0 : (m.actual / totalActual) * 100;
                  return _legendItem(
                    name: m.name,
                    value: "${percent.toStringAsFixed(1)}%",
                    color: palette[index % palette.length],
                    appStyle: appStyle,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendItem({required String name, required String value, required Color color, required AppStyle appStyle}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(6), horizontal: AppStyle.w(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(8)),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: AppStyle.w(10), height: AppStyle.h(10), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: AppStyle.w(6)),
          Text(name, style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.75, fontWeight: FontWeight.w600)),
          SizedBox(width: AppStyle.w(6)),
          Text(value, style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.75, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeader(AppStyle appStyle, MockAreamanage? data) {
    final managers = data?.managersPerformance ?? [];
    final totalActual = managers.fold(0.0, (p, e) => p + e.actual);
    final totalPromised = managers.fold(0.0, (p, e) => p + e.promised);
    final overallPercent = totalPromised == 0 ? 0.0 : (totalActual / totalPromised) * 100;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "Performance vs Promises",
            style: AppStyle.headTextStyle(),
          ),
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: AppStyle.w(10), vertical: AppStyle.h(6)),
        //   decoration: BoxDecoration(
        //     color: overallPercent >= 100 ? const Color(0xFFDFF7EB) : const Color(0xFFFFF2F2),
        //     borderRadius: BorderRadius.circular(AppStyle.w(20)),
        //   ),
        //   child: Row(
        //     children: [
        //       Icon(
        //         overallPercent >= 100 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
        //         size: AppStyle.w(14),
        //         color: overallPercent >= 100 ? Colors.green : Colors.red,
        //       ),
        //       SizedBox(width: AppStyle.w(4)),
        //       Text(
        //         "${overallPercent.toStringAsFixed(1)}%",
        //         style: AppStyle.normalTextStyle().copyWith(
        //           fontSize: AppStyle.normalFontSize * 0.75,
        //           fontWeight: FontWeight.w600,
        //           color: overallPercent >= 100 ? Colors.green : Colors.red,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildManagerTile(ManagerPerformance m, AppStyle appStyle) {
    final achievedPercent = m.promised == 0 ? 0.0 : (m.actual / m.promised) * 100;
    final diff = m.actual - m.promised;
    final bool positive = diff >= 0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppStyle.h(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(14)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppStyle.w(14), vertical: AppStyle.h(12)),
            child: Row(
              children: [
                Container(width: AppStyle.w(12), height: AppStyle.h(12), decoration: BoxDecoration(shape: BoxShape.circle, color: m.color)),
                SizedBox(width: AppStyle.w(8)),
                Expanded(child: Text(m.name, style: AppStyle.headTextStyle().copyWith(fontSize: AppStyle.normalFontSize))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppStyle.w(12), vertical: AppStyle.h(6)),
                  decoration: BoxDecoration(
                    color: positive ? const Color(0xFFDFF7EB) : const Color(0xFFFFF2F2),
                    borderRadius: BorderRadius.circular(AppStyle.w(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: AppStyle.w(14),
                        color: positive ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: AppStyle.w(4)),
                      Text(
                        "${achievedPercent.toStringAsFixed(1)}%",
                        style: AppStyle.normalTextStyle().copyWith(
                          fontSize: AppStyle.normalFontSize * 0.75,
                          fontWeight: FontWeight.w600,
                          color: positive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppStyle.w(14)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppStyle.w(6)),
              child: LinearProgressIndicator(
                value: (m.promised == 0) ? 0 : (m.actual / m.promised).clamp(0, 1),
                minHeight: AppStyle.h(8),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(m.color),
              ),
            ),
          ),
          SizedBox(height: AppStyle.h(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppStyle.w(14), vertical: AppStyle.h(10)),
            child: Column(
              children: [
                _infoRow("Actual Sales", m.actual.format(), highlight: true, valueColor: AppStyle.appBarColor, appStyle: appStyle),
                SizedBox(height: AppStyle.h(8)),
                _infoRow("Promised", m.promised.format(), appStyle: appStyle),
                SizedBox(height: AppStyle.h(8)),
                _infoRow(
                  "Difference",
                  (positive ? "+" : "-") + diff.abs().format().replaceAll('₹', '₹'),
                  valueColor: positive ? Colors.green : Colors.red,
                  appStyle: appStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false, Color? valueColor, required AppStyle appStyle}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.circular(AppStyle.w(6)),
      ),
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(10), horizontal: AppStyle.w(12)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.8))),
          Text(
            value,
            style: AppStyle.normalTextStyle().copyWith(
              fontSize: AppStyle.normalFontSize * 0.9,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
              color: valueColor ?? (highlight ? AppStyle.appBarColor : AppStyle.textColor),
            ),
          ),
        ],
      ),
    );
  }
}