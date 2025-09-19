import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar1_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';

// Extension for Indian Rupee formatting
extension INR on num {
  String formatAsCurrency({bool compact = false}) {
    if (compact) {
      if (this >= 10000000) {
        return '₹${(this / 10000000).toStringAsFixed(1)}Cr';
      } else if (this >= 100000) {
        return '₹${(this / 100000).toStringAsFixed(1)}L';
      } else {
        return '₹${toStringAsFixed(0)}';
      }
    }
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    return f.format(this);
  }
}

// Mock data classes
class MockMonthData {
  final String? name;
  final int? totalSales;
  final String? growthPercentage;
  final Map<String, int>? dailySales;

  MockMonthData({
    this.name,
    this.totalSales,
    this.growthPercentage,
    this.dailySales,
  });
}

class MockMonthlyData {
  final MockMonthData? currentMonth;
  final MockMonthData? lastMonth;

  MockMonthlyData({
    this.currentMonth,
    this.lastMonth,
  });
}

class MonthlySalesScreen extends StatefulWidget {
  const MonthlySalesScreen({super.key});

  @override
  State<MonthlySalesScreen> createState() => _MonthlySalesScreenState();
}

class _MonthlySalesScreenState extends State<MonthlySalesScreen> {
  List<String> selectedBranches = ['Branch A', 'Branch B', 'Branch C'];
  DateTime? selectedStartDate = DateTime(2025, 7, 1);
  DateTime? selectedEndDate = DateTime(2025, 7, 31);
  final List<String> availableBranches = ['Branch A', 'Branch B', 'Branch C'];

  // Dummy data
  final List<MockMonthlyData> dummyMonthlyData = [
    MockMonthlyData(
      currentMonth: MockMonthData(
        name: 'Jul 2025',
        totalSales: 5000000,
        growthPercentage: '10%',
        dailySales: {
          '01': 150000,
          '02': 160000,
          '03': 170000,
          '04': 180000,
          '05': 190000,
          '06': 200000,
          '07': 210000,
          '08': 220000,
          '09': 230000,
          '10': 240000,
          '11': 250000,
          '12': 260000,
          '13': 270000,
          '14': 280000,
          '15': 290000,
          '16': 300000,
          '17': 310000,
          '18': 320000,
          '19': 330000,
          '20': 340000,
          '21': 350000,
          '22': 360000,
          '23': 370000,
          '24': 380000,
          '25': 390000,
          '26': 400000,
          '27': 410000,
          '28': 420000,
          '29': 430000,
          '30': 440000,
        },
      ),
      lastMonth: MockMonthData(
        name: 'Jun 2025',
        totalSales: 4500000,
        growthPercentage: '8%',
        dailySales: {
          '01': 140000,
          '02': 150000,
          '03': 160000,
          '04': 170000,
          '05': 180000,
          '06': 190000,
          '07': 200000,
          '08': 210000,
          '09': 220000,
          '10': 230000,
          '11': 240000,
          '12': 250000,
          '13': 260000,
          '14': 270000,
          '15': 280000,
          '16': 290000,
          '17': 300000,
          '18': 310000,
          '19': 320000,
          '20': 330000,
          '21': 340000,
          '22': 350000,
          '23': 360000,
          '24': 370000,
          '25': 380000,
          '26': 390000,
          '27': 400000,
          '28': 410000,
          '29': 420000,
          '30': 430000,
        },
      ),
    ),
    MockMonthlyData(
      currentMonth: MockMonthData(
        name: 'Aug 2025',
        totalSales: 5500000,
        growthPercentage: '12%',
        dailySales: {
          '01': 160000,
          '02': 170000,
          '03': 180000,
          '04': 190000,
          '05': 200000,
          '06': 210000,
          '07': 220000,
          '08': 230000,
          '09': 240000,
          '10': 250000,
          '11': 260000,
          '12': 270000,
          '13': 280000,
          '14': 290000,
          '15': 300000,
          '16': 310000,
          '17': 320000,
          '18': 330000,
          '19': 340000,
          '20': 350000,
          '21': 360000,
          '22': 370000,
          '23': 380000,
          '24': 390000,
          '25': 400000,
          '26': 410000,
          '27': 420000,
          '28': 430000,
          '29': 440000,
          '30': 450000,
        },
      ),
      lastMonth: MockMonthData(
        name: 'Jul 2025',
        totalSales: 5000000,
        growthPercentage: '10%',
        dailySales: {
          '01': 150000,
          '02': 160000,
          '03': 170000,
          '04': 180000,
          '05': 190000,
          '06': 200000,
          '07': 210000,
          '08': 220000,
          '09': 230000,
          '10': 240000,
          '11': 250000,
          '12': 260000,
          '13': 270000,
          '14': 280000,
          '15': 290000,
          '16': 300000,
          '17': 310000,
          '18': 320000,
          '19': 330000,
          '20': 340000,
          '21': 350000,
          '22': 360000,
          '23': 370000,
          '24': 380000,
          '25': 390000,
          '26': 400000,
          '27': 410000,
          '28': 420000,
          '29': 430000,
          '30': 440000,
        },
      ),
    ),
  ];

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    final f = DateFormat('dd MMM yyyy');
    return f.format(date);
  }

  String getDateRangeText(MockMonthlyData? monthlyData) {
    if (monthlyData?.currentMonth?.name != null) {
      return monthlyData!.currentMonth!.name!;
    }
    return 'Select Date Range';
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

  // Filter dummy data based on selected date range
  MockMonthlyData? getFilteredMonthlyData() {
    if (selectedStartDate == null || selectedEndDate == null) return dummyMonthlyData.first;
    return dummyMonthlyData.firstWhere(
      (data) {
        if (data.currentMonth?.name == null) return false;
        try {
          final monthYear = data.currentMonth!.name!.split(' ');
          final month = DateFormat.MMMM().parse(monthYear[0]).month;
          final year = int.parse(monthYear[1]);
          final dataDate = DateTime(year, month);
          return dataDate.isAfter(selectedStartDate!.subtract(const Duration(days: 1))) &&
              dataDate.isBefore(selectedEndDate!.add(const Duration(days: 1)));
        } catch (e) {
          print('Error parsing date ${data.currentMonth?.name}: $e');
          return false;
        }
      },
      orElse: () => dummyMonthlyData.first,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedStartDate = DateTime(2025, 7, 1);
    selectedEndDate = DateTime(2025, 7, 31);
  }

  @override
  Widget build(BuildContext context) {
    AppStyle.init(context);
    final appStyle = AppStyle(context);
    final monthlyData = getFilteredMonthlyData();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar1(
        title: 'Monthly Sales Progress',
        onNotificationPressed: () {
          print('Notification pressed');
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppStyle.w(16), vertical: AppStyle.h(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(appStyle, monthlyData),
            SizedBox(height: AppStyle.h(20)),
            _salesCard(
              "Current Month Sales",
              monthlyData?.currentMonth?.totalSales ?? 0,
              monthlyData?.currentMonth?.growthPercentage ?? '0%',
              Colors.blue,
              appStyle,
            ),
            SizedBox(height: AppStyle.h(16)),
            _salesCard(
              "Last Month Sales",
              monthlyData?.lastMonth?.totalSales ?? 0,
              monthlyData?.lastMonth?.growthPercentage ?? '0%',
              Colors.green,
              appStyle,
            ),
            SizedBox(height: AppStyle.h(16)),
            _chartCard(appStyle, monthlyData),
            SizedBox(height: AppStyle.h(30)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(AppStyle appStyle, MockMonthlyData? monthlyData) {
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

  Widget _salesCard(String title, int totalSales, String change, Color iconColor, AppStyle appStyle) {
    return Container(
      padding: EdgeInsets.all(AppStyle.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(16)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.9, color: Colors.black54),
              ),
              Text(
                '₹',
                style: TextStyle(color: iconColor, fontSize: AppStyle.normalFontSize * 1.5),
              ),
            ],
          ),
          SizedBox(height: AppStyle.h(1)),
          Text(
            totalSales.formatAsCurrency(compact: true),
            style: AppStyle.headTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 1.5),
          ),
          SizedBox(height: AppStyle.h(1)),
          Row(
            children: [
              Icon(Icons.arrow_upward, size: AppStyle.w(16), color: iconColor),
              SizedBox(width: AppStyle.w(4)),
              Text(
                "$change vs last month",
                style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.85, color: iconColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartCard(AppStyle appStyle, MockMonthlyData? monthlyData) {
    final dailySalesCurrent = monthlyData?.currentMonth?.dailySales;
    final dailySalesLast = monthlyData?.lastMonth?.dailySales;
    final List<FlSpot> currentMonthSpots = [];
    final List<FlSpot> lastMonthSpots = [];

    // Generate FlSpots for daily sales (days 1 to 30)
    for (int i = 1; i <= 30; i++) {
      final day = i.toString().padLeft(2, '0');
      final currentValue = _getDailySalesValue(dailySalesCurrent, day)?.toDouble() ?? 0.0;
      final lastValue = _getDailySalesValue(dailySalesLast, day)?.toDouble() ?? 0.0;
      currentMonthSpots.add(FlSpot(i.toDouble() - 1, currentValue / 100000)); // Scale to lakhs
      lastMonthSpots.add(FlSpot(i.toDouble() - 1, lastValue / 100000)); // Scale to lakhs
    }

    // Calculate maxY for the chart
    final maxY = (currentMonthSpots.isNotEmpty
            ? currentMonthSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b)
            : 1.0) *
        1.2;
    // Ensure maxY is rounded up to the nearest 5 for a clean 5-lakh interval
    final adjustedMaxY = (maxY / 5).ceil() * 5.0;

    return Container(
      padding: EdgeInsets.all(AppStyle.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyle.w(16)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sales Progress Monthly",
            style: AppStyle.headTextStyle().copyWith(fontSize: AppStyle.normalFontSize),
          ),
          SizedBox(height: AppStyle.h(12)),
          SizedBox(
            height: AppStyle.h(260),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchSpotThreshold: 20,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (group) => Colors.white,
                    tooltipPadding: EdgeInsets.symmetric(horizontal: AppStyle.w(10), vertical: AppStyle.h(8)),
getTooltipItems: (touchedSpots) {
  if (touchedSpots.isEmpty) return [];

  final touchedX = touchedSpots.first.x;
  final day = (touchedX.toInt() + 1).toString().padLeft(2, '0');

  final currentValue = _getDailySalesValue(dailySalesCurrent, day)?.toDouble() ?? 0.0;
  final lastValue = _getDailySalesValue(dailySalesLast, day)?.toDouble() ?? 0.0;

  final currentMonthName = monthlyData?.currentMonth?.name?.split(' ').first ?? 'Jul';
  final lastMonthName = monthlyData?.lastMonth?.name?.split(' ').first ?? 'Jun';

  final tooltipText = [
    TextSpan(
      text: "$currentMonthName $day: ${currentValue.formatAsCurrency(compact: true)}\n",
      style: AppStyle.headTextStyle().copyWith(
        color: Colors.blue,
        fontSize: AppStyle.normalFontSize * 0.8,
      ),
    ),
    TextSpan(
      text: "$lastMonthName $day: ${lastValue.formatAsCurrency(compact: true)}",
      style: AppStyle.headTextStyle().copyWith(
        color: Colors.red,
        fontSize: AppStyle.normalFontSize * 0.8,
      ),
    ),
  ];

  // Ensure same length as touchedSpots
  return List.generate(touchedSpots.length, (index) {
    return LineTooltipItem(
      "",
      const TextStyle(),
      children: index == 0 ? tooltipText : [],
    );
  });
}

                  ),
                ),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: AppStyle.w(40), // Increased to accommodate larger labels
                      interval: 5, // 5-lakh gap (since y-values are in lakhs)
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${(value * 1).toStringAsFixed(0)}L',
                          style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.6),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        if (value % 5 == 0) {
                          final monthName = monthlyData?.currentMonth?.name?.split(' ').first ?? 'Jul';
                          return Text(
                            "$monthName ${(value.toInt() + 1).toString().padLeft(2, '0')}",
                            style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.6),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                minY: 0,
                maxY: adjustedMaxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: currentMonthSpots,
                    isCurved: true,
                    gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: lastMonthSpots,
                    isCurved: false,
                    gradient: const LinearGradient(colors: [Colors.red, Colors.orange]),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dashArray: [5, 5],
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppStyle.h(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: AppStyle.w(10), color: Colors.blue),
              SizedBox(width: AppStyle.w(4)),
              Text("Current Month", style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.75)),
              SizedBox(width: AppStyle.w(16)),
              Icon(Icons.circle, size: AppStyle.w(10), color: Colors.red),
              SizedBox(width: AppStyle.w(4)),
              Text("Last Month", style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.75)),
            ],
          ),
        ],
      ),
    );
  }

  int? _getDailySalesValue(Map<String, int>? dailySales, String day) {
    return dailySales?[day];
  }
}