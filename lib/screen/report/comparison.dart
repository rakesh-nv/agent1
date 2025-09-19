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
        return '₹${(this / 10000000).toStringAsFixed(2)}Cr';
      } else if (this >= 100000) {
        return '₹${(this / 100000).toStringAsFixed(2)}L';
      } else {
        return '₹${toStringAsFixed(0)}';
      }
    }
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    return f.format(this);
  }
}

// Mock SalesData class
class SalesData {
  final String? date;
  final double? totalSales;
  final double? qtySold;
  final double? avgPerBill;
  final int? numberOfBills;
  final int? totalCustomers;
  final int? newCustomers;

  SalesData({
    this.date,
    this.totalSales,
    this.qtySold,
    this.avgPerBill,
    this.numberOfBills,
    this.totalCustomers,
    this.newCustomers,
  });
}

class SalesComparisonScreen extends StatefulWidget {
  const SalesComparisonScreen({super.key});

  @override
  State<SalesComparisonScreen> createState() => _SalesComparisonScreenState();
}

class _SalesComparisonScreenState extends State<SalesComparisonScreen> {
  List<String> selectedBranches = ['Branch A', 'Branch B', 'Branch C'];
  DateTime? selectedStartDate = DateTime(2025, 8, 1);
  DateTime? selectedEndDate = DateTime(2025, 8, 31);

  final List<String> availableBranches = ['Branch A', 'Branch B', 'Branch C'];

  // Dummy data
  final List<SalesData> dummySalesData = [
    SalesData(
      date: '2025-08-01',
      totalSales: 5000000.0,
      qtySold: 1500.0,
      avgPerBill: 5000.0,
      numberOfBills: 1000,
      totalCustomers: 800,
      newCustomers: 200,
    ),
    SalesData(
      date: '2025-07-01',
      totalSales: 3000000.0,
      qtySold: 1000.0,
      avgPerBill: 4500.0,
      numberOfBills: 666,
      totalCustomers: 600,
      newCustomers: 150,
    ),
    SalesData(
      date: '2025-06-01',
      totalSales: 4000000.0,
      qtySold: 1200.0,
      avgPerBill: 4800.0,
      numberOfBills: 833,
      totalCustomers: 700,
      newCustomers: 180,
    ),
  ];

  String formatApiDate(String? apiDate) {
    if (apiDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(apiDate);
      final f = DateFormat('dd MMM yyyy');
      return f.format(date);
    } catch (e) {
      print('Error parsing date $apiDate: $e');
      return apiDate;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    final f = DateFormat('dd MMM yyyy');
    return f.format(date);
  }

  String getDateRangeText(List<SalesData> salesData) {
    if (salesData.isEmpty) return 'Select Date Range';
    final startDate = salesData.first.date;
    final endDate = salesData.last.date;
    if (startDate == endDate || endDate == null) return formatApiDate(startDate);
    return '${formatApiDate(startDate)} - ${formatApiDate(endDate)}';
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
  List<SalesData> getFilteredSalesData() {
    if (selectedStartDate == null || selectedEndDate == null) return dummySalesData;
    return dummySalesData.where((data) {
      if (data.date == null) return false;
      try {
        final date = DateTime.parse(data.date!);
        return date.isAfter(selectedStartDate!.subtract(const Duration(days: 1))) &&
            date.isBefore(selectedEndDate!.add(const Duration(days: 1)));
      } catch (e) {
        print('Error parsing date ${data.date}: $e');
        return false;
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    selectedStartDate = DateTime(2025, 8, 1);
    selectedEndDate = DateTime(2025, 8, 31);
  }

  @override
  Widget build(BuildContext context) {
    AppStyle.init(context);
    final appStyle = AppStyle(context);
    final filteredSalesData = getFilteredSalesData();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar1(
        title: 'Sales Comparison',
        onNotificationPressed: () {
          print('Notification pressed');
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(AppStyle.w(16)),
        children: [
          _buildFilters(appStyle),
          SizedBox(height: AppStyle.h(10)),
          _buildBarChart(appStyle, filteredSalesData),
          SizedBox(height: AppStyle.h(10)),
          _buildDateHeader(appStyle, filteredSalesData),
          SizedBox(height: AppStyle.h(10)),
          ..._buildComparisonCards(appStyle, filteredSalesData),
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

  Widget _buildBarChart(AppStyle appStyle, List<SalesData> salesData) {
    if (salesData.isEmpty) {
      return Center(
        child: Text(
          'No sales data to display',
          style: AppStyle.normalTextStyle(),
        ),
      );
    }

    final maxY = salesData.isNotEmpty
        ? (salesData.map((e) => e.totalSales ?? 0).reduce((a, b) => a > b ? a : b) * 1.2).toDouble()
        : 11000000.0;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(16))),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(AppStyle.w(20)),
        child: Column(
          children: [
            Text(
              "Sales Chart (₹)",
              style: AppStyle.headTextStyle().copyWith(fontSize: AppStyle.normalFontSize),
            ),
            SizedBox(height: AppStyle.h(20)),
            SizedBox(
              height: AppStyle.h(300),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final data = salesData[groupIndex];
                        final lakhsValue = (data.totalSales ?? 0) / 100000;
                        return BarTooltipItem(
                          '${formatApiDate(data.date)}\n₹${lakhsValue.toStringAsFixed(2)}L',
                          AppStyle.normalTextStyle().copyWith(color: Colors.white, fontSize: AppStyle.normalFontSize * 0.8),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: AppStyle.w(60),
                        interval: maxY / 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "₹${(value / 1000000).toStringAsFixed(0)}L",
                            style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.75),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < salesData.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: AppStyle.h(3)),
                              child: Text(
                                formatApiDate(salesData[value.toInt()].date),
                                style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        interval: 1,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: salesData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (data.totalSales ?? 0).toDouble(),
                          width: AppStyle.w(28),
                          borderRadius: BorderRadius.circular(AppStyle.w(8)),
                          gradient: LinearGradient(
                            colors: [
                              index == 0 ? Color(0xFF4CAF50) : Color(0xFFF44336),
                              index == 0 ? Color(0xFF81C784) : Color(0xFFE57373),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                swapAnimationDuration: const Duration(milliseconds: 600),
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(AppStyle appStyle, List<SalesData> salesData) {
    final text = salesData.isEmpty
        ? "Comparison With Previous Sale\nSelect a Date Range"
        : "Comparison With Previous Sale\nFor The Period ${getDateRangeText(salesData)}";
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(12)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.8, fontWeight: FontWeight.w500),
      ),
    );
  }

  List<Widget> _buildComparisonCards(AppStyle appStyle, List<SalesData> salesData) {
    if (salesData.isEmpty) {
      return [
        Center(
          child: Text(
            'No comparison data available',
            style: AppStyle.normalTextStyle(),
          ),
        )
      ];
    }

    final colors = [Colors.green.shade600, Colors.red.shade600];
    return salesData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return Padding(
        padding: EdgeInsets.only(bottom: AppStyle.h(10)),
        child: _buildComparisonCard(
          title: formatApiDate(data.date) ?? 'Unknown Period',
          sale: (data.totalSales ?? 0).formatAsCurrency(compact: true),
          quantity: (data.qtySold ?? 0).toStringAsFixed(2),
          avgBill: (data.avgPerBill ?? 0).formatAsCurrency(compact: true),
          bills: (data.numberOfBills ?? 0).toString(),
          totalCustomers: (data.totalCustomers ?? 0).toString(),
          newCustomers: (data.newCustomers ?? 0).toString(),
          color: colors[index % colors.length],
          appStyle: appStyle,
        ),
      );
    }).toList();
  }

  Widget _buildComparisonCard({
    required String title,
    required String sale,
    required String quantity,
    required String avgBill,
    required String bills,
    required String totalCustomers,
    required String newCustomers,
    required Color color,
    required AppStyle appStyle,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(16))),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyle.w(16)),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(AppStyle.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyle.headTextStyle().copyWith(fontSize: AppStyle.normalFontSize, color: color),
            ),
            Divider(height: AppStyle.h(20), thickness: 1),
            _buildDataRow(Icons.currency_rupee, "Total Sales", sale, appStyle),
            _buildDataRow(Icons.shopping_cart, "Quantity Sold", quantity, appStyle),
            _buildDataRow(Icons.receipt, "Avg / Bill", avgBill, appStyle),
            _buildDataRow(Icons.list_alt, "No of Bills", bills, appStyle),
            _buildDataRow(Icons.people, "Total Customers", totalCustomers, appStyle),
            _buildDataRow(Icons.person_add_alt, "New Customers", newCustomers, appStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value, AppStyle appStyle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(6)),
      child: Row(
        children: [
          Icon(icon, size: AppStyle.w(20), color: Colors.blueGrey),
          SizedBox(width: AppStyle.w(10)),
          Expanded(child: Text(label, style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.normalFontSize * 0.9))),
          Text(
            value,
            style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.bold, fontSize: AppStyle.normalFontSize * 0.9),
          ),
        ],
      ),
    );
  }
}