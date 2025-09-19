import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar1_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';

class SalesProgressYearlyScreen extends StatefulWidget {
  const SalesProgressYearlyScreen({super.key});

  @override
  State<SalesProgressYearlyScreen> createState() => _SalesProgressYearlyScreenState();
}

class _SalesProgressYearlyScreenState extends State<SalesProgressYearlyScreen> {
  List<String> selectedBranches = ['Branch A', 'Branch B', 'Branch C'];
  DateTime? selectedStartDate = DateTime(2025, 7, 1);
  DateTime? selectedEndDate = DateTime(2025, 7, 31);
  final List<String> availableBranches = ['Branch A', 'Branch B', 'Branch C'];

  // Dummy data for line chart
  final Map<String, double> lastYearSales = {
    'April': 5.0, // in crores
    'June': 8.0,
    'August': 12.0,
    'November': 10.0,
    'March': 15.0,
  };

  final Map<String, double> currentYearSales = {
    'April': 7.0, // in crores
    'June': 10.0,
    'August': 14.0,
    'November': 12.0,
    'March': 18.0,
  };

  // Dummy data for insights and summary
  final String growthRate = '12.5%';
  final String peakPerformanceMonth = 'March';
  final String bestQuarter = 'Q4';
  final String targetAchievement = '85%';

  final List<String> displayMonths = ['Apr', 'Jun', 'Aug', 'Nov', 'Mar'];

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

  FlTitlesData get _titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: AppStyle.h(25),
            interval: 1,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx < 0 || idx >= displayMonths.length) return const SizedBox();
              String month = displayMonths[idx];
              return SideTitleWidget(
                meta: meta,
                //axisSide: meta.axisSide,
                child: Text(
                  month,
                  style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.7),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                //axisSide: meta.axisSide,
                child: Text(
                  "${value.toInt()}Cr",
                  style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.6),
                ),
              );
            },
            reservedSize: AppStyle.w(35),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  List<FlSpot> buildSpots(Map<String, double> yearData) {
    List<FlSpot> spots = [];
    final months = ['April', 'June', 'August', 'November', 'March'];
    for (int i = 0; i < displayMonths.length; i++) {
      final month = months[i];
      final val = yearData[month] ?? 0.0;
      spots.add(FlSpot(i.toDouble(), val));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    AppStyle.init(context);
    final appStyle = AppStyle(context);

    final List<Color> tooltipColors = [
      const Color(0xFF1565C0), // Blue for last year
      AppStyle.appBarColor, // AppStyle color for current year
    ];

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar1(
        title: 'Yearly Sales Progress',
        onNotificationPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications clicked!')),
          );
        },
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: appStyle.defaultPadding, vertical: AppStyle.h(19)),
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: _buildFilters(appStyle),
          ),
          SizedBox(height: AppStyle.h(20)),
          _whiteCard(
            appStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppStyle.h(20)),
                Text(
                  "Sales Progress Yearly",
                  style: AppStyle.headTextStyle().copyWith(height: 1.1),
                ),
                SizedBox(height: AppStyle.h(4)),
                Text(
                  "Quarterly comparison between ${formatDate(selectedStartDate)} - ${formatDate(selectedEndDate)}",
                  style: AppStyle.normalTextStyle().copyWith(color: Colors.black54),
                ),
                SizedBox(height: AppStyle.h(18)),
                SizedBox(
                  height: AppStyle.h(260),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (v) => FlLine(
                          color: Colors.grey.withOpacity(0.15),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: _titlesData,
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                      ),
                      minY: 0,
                      maxY: 30,
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (group) => Colors.white,
                          tooltipPadding: EdgeInsets.all(AppStyle.w(12)),
                          tooltipMargin: AppStyle.h(4),
                          maxContentWidth: 180,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItems: (touchedSpots) {
                            if (touchedSpots.isEmpty) return [];
                            final monthIndex = touchedSpots.first.x.toInt();
                            if (monthIndex < 0 || monthIndex >= displayMonths.length) return [];
                            final month = displayMonths[monthIndex];

                            return touchedSpots.asMap().entries.map((entry) {
                              final index = entry.key;
                              final spot = entry.value;
                              final value = spot.y;
                              final color = tooltipColors[index % tooltipColors.length];
                              final label = index == 0 ? 'Last Year' : 'Current Year';

                              return LineTooltipItem(
                                '',
                                AppStyle.normalTextStyle(),
                                children: [
                                  if (index == 0)
                                    TextSpan(
                                      text: '$month\n',
                                      style: AppStyle.normalTextStyle().copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppStyle.normalFontSize,
                                      ),
                                    ),
                                  TextSpan(
                                    text: '$label: ₹${value.toStringAsFixed(1)}Cr',
                                    style: AppStyle.normalTextStyle().copyWith(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppStyle.normalFontSize * 0.85,
                                    ),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: buildSpots(lastYearSales),
                          isCurved: true,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          color: const Color(0xFF1565C0),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF1565C0).withOpacity(0.1),
                          ),
                        ),
                        LineChartBarData(
                          spots: buildSpots(currentYearSales),
                          isCurved: true,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          color: AppStyle.appBarColor,
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppStyle.appBarColor.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppStyle.h(10)),
                Row(
                  children: [
                    _legendDot(
                      color: const Color(0xFF1565C0),
                      label: 'Last Year',
                      appStyle: appStyle,
                    ),
                    SizedBox(width: AppStyle.w(16)),
                    _legendDot(
                      color: AppStyle.appBarColor,
                      label: 'Current Year',
                      appStyle: appStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppStyle.h(16)),
          _whiteCard(
            appStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Key Insights",
                  style: AppStyle.headTextStyle().copyWith(height: 1.1),
                ),
                SizedBox(height: AppStyle.h(12)),
                _insightRow(
                  color: const Color(0xFF1565C0),
                  text: "Sales growth of $growthRate compared to last year",
                  appStyle: appStyle,
                ),
                SizedBox(height: AppStyle.h(6)),
                _insightRow(
                  color: AppStyle.appBarColor,
                  text: "Peak performance in $peakPerformanceMonth",
                  appStyle: appStyle,
                ),
                SizedBox(height: AppStyle.h(6)),
                _insightRow(
                  color: const Color(0xFF1565C0),
                  text: "Best quarter: $bestQuarter",
                  appStyle: appStyle,
                ),
              ],
            ),
          ),
          SizedBox(height: AppStyle.h(16)),
          _whiteCard(
            appStyle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Performance Summary",
                  style: AppStyle.headTextStyle().copyWith(height: 1.1),
                ),
                SizedBox(height: AppStyle.h(12)),
                Row(
                  children: [
                    Expanded(
                      child: _summaryRow(
                        title: "Best Quarter",
                        value: bestQuarter,
                        appStyle: appStyle,
                      ),
                    ),
                    Expanded(
                      child: _summaryRow(
                        title: "Growth Rate",
                        value: growthRate,
                        valueColor: const Color(0xFF1565C0),
                        appStyle: appStyle,
                      ),
                    ),
                    Expanded(
                      child: _summaryRow(
                        title: "Target Achievement",
                        value: targetAchievement,
                        valueColor: const Color(0xFF1565C0),
                        appStyle: appStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppStyle.h(30)),
        ],
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

  Widget _whiteCard(AppStyle appStyle, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppStyle.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _legendDot({required Color color, required String label, required AppStyle appStyle}) {
    return Row(
      children: [
        Container(
          width: AppStyle.w(12),
          height: AppStyle.h(12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppStyle.w(6)),
        Text(
          label,
          style: AppStyle.normalTextStyle(),
        ),
      ],
    );
  }

  Widget _insightRow({required Color color, required String text, required AppStyle appStyle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: AppStyle.h(6)),
          width: AppStyle.w(10),
          height: AppStyle.h(10),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppStyle.w(10)),
        Expanded(
          child: Text(
            text,
            style: AppStyle.normalTextStyle(),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    Color? valueColor,
    required AppStyle appStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.normalTextStyle().copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppStyle.h(6)),
        Text(
          value,
          style: AppStyle.headTextStyle().copyWith(
            color: valueColor ?? AppStyle.textColor,
          ),
        ),
      ],
    );
  }
}