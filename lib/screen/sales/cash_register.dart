import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar1_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';

class PaymentModeScreen extends StatefulWidget {
  const PaymentModeScreen({super.key});

  @override
  State<PaymentModeScreen> createState() => _PaymentModeScreenState();
}

class _PaymentModeScreenState extends State<PaymentModeScreen> {
  final List<String> branches = ['Branch A', 'Branch B', 'Branch C'];
  String selectedBranch = 'Branch A';
  DateTime? selectedStartDate = DateTime(2025, 8, 1);
  DateTime? selectedEndDate = DateTime(2025, 8, 31);

  // Dummy data
  final List<Map<String, dynamic>> paymentData = [
    {'name': 'Cash', 'amount': 50000.0, 'color': Colors.blue},
    {'name': 'UPI', 'amount': 30000.0, 'color': Colors.green},
    {'name': 'Card', 'amount': 20000.0, 'color': Colors.orange},
    {'name': 'Other', 'amount': 10000.0, 'color': Colors.purple},
  ];

  // Calculate total sales from dummy data
  double get total => paymentData.fold(0.0, (sum, item) => sum + item['amount']);

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    final f = DateFormat('dd MMM yyyy');
    return f.format(date);
  }

  String getDateRangeText() {
    if (selectedStartDate == null || selectedEndDate == null) {
      return 'Select Date Range';
    }
    return '${formatDate(selectedStartDate)} - ${formatDate(selectedEndDate)}';
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
    final tempSelected = List<String>.from(branches);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select Branches', style: AppStyle.headTextStyle()),
              content: branches.isEmpty
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
                                    tempSelected.addAll(branches);
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
                              itemCount: branches.length,
                              itemBuilder: (context, index) {
                                final branch = branches[index];
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
                      selectedBranch = tempSelected as String;
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

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(value);
  }

  List<PieChartSectionData> getSections(List<Map<String, dynamic>> paymentData) {
    final filtered = paymentData.where((item) => item['amount'] > 0).toList();
    final total = filtered.fold(0.0, (sum, item) => sum + item['amount']);

    return filtered.map((item) {
      final percentage = total > 0 ? (item['amount'] / total) * 100 : 0.0;
      return PieChartSectionData(
        color: item['color'],
        value: item['amount'],
        title: '${percentage.toStringAsFixed(1)}%',
        radius: AppStyle.w(70),
        titleStyle: AppStyle.normalTextStyle().copyWith(color: Colors.white),
      );
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

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar1(
        title: 'Cash Register',
        onNotificationPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications clicked!')),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(appStyle.defaultPadding),
            child: _buildFilters(appStyle),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Column(
                children: [
                  _buildCard(
                    appStyle,
                    title: "Total Sales",
                    content: SizedBox(
                      width: double.infinity,
                      child: Text(
                        formatCurrency(total),
                        style: AppStyle.headTextStyle().copyWith(
                          color: Colors.green,
                          fontSize: AppStyle.headFontSize * 0.8,
                        ),
                      ),
                    ),
                  ),
                  _buildCard(
                    appStyle,
                    title: "Payment Mode Chart",
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: AppStyle.h(220),
                          child: PieChart(
                            PieChartData(
                              sections: getSections(paymentData),
                              centerSpaceRadius: AppStyle.w(50),
                              sectionsSpace: 1,
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                        SizedBox(height: AppStyle.h(24)),
                        Wrap(
                          spacing: AppStyle.w(10),
                          runSpacing: AppStyle.h(6),
                          children: paymentData
                              .where((item) => item['amount'] > 0)
                              .map((m) {
                                final percent = total == 0 ? 0.0 : (m['amount'] / total) * 100;
                                return _legendItem(
                                  name: m['name'],
                                  value: "${percent.toStringAsFixed(1)}%",
                                  color: m['color'],
                                  appStyle: appStyle,
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppStyle.w(12)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paymentData.length,
                      separatorBuilder: (_, __) => SizedBox(height: AppStyle.h(10)),
                      itemBuilder: (context, index) {
                        final item = paymentData[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppStyle.w(12)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: AppStyle.w(8),
                                height: AppStyle.h(60),
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(AppStyle.w(12)),
                                    bottomLeft: Radius.circular(AppStyle.w(12)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    item['name'],
                                    style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  trailing: Text(
                                    formatCurrency(item['amount']),
                                    style: AppStyle.normalTextStyle().copyWith(
                                      color: item['amount'] < 0 ? Colors.red : AppStyle.textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppStyle.h(20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(AppStyle appStyle, {required String title, required Widget content}) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: AppStyle.w(12), vertical: AppStyle.h(3)),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.w(12))),
      child: Padding(
        padding: EdgeInsets.all(AppStyle.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyle.headTextStyle()),
            SizedBox(height: AppStyle.h(10)),
            content,
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
                  label: selectedBranch,
                  onTap: () => chooseBranches(),
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
          Container(
            width: AppStyle.w(10),
            height: AppStyle.h(10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: AppStyle.w(6)),
          Text(name, style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600)),
          SizedBox(width: AppStyle.w(6)),
          Text(value, style: AppStyle.normalTextStyle().copyWith(color: Colors.black54)),
        ],
      ),
    );
  }
}