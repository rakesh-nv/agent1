import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbindiamy/widget/custom_drawer.dart';

// Utility class for responsive sizing
class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late bool isMobile;
  static late bool isTablet;
  static late bool isDesktop;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1024;
    isDesktop = screenWidth >= 1024;
  }

  static double w(double width) => screenWidth * (width / 375);

  static double h(double height) => screenHeight * (height / 812);
}

class BillingManagerScreen extends StatefulWidget {
  const BillingManagerScreen({super.key});

  @override
  State<BillingManagerScreen> createState() => _BillingManagerScreenState();
}

class _BillingManagerScreenState extends State<BillingManagerScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final horizontalPadding = SizeConfig.isDesktop
        ? SizeConfig.w(60)
        : SizeConfig.isTablet
        ? SizeConfig.w(40)
        : SizeConfig.w(12);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: const CustomDrawer(), // Use the new CustomDrawer widget

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        toolbarHeight: SizeConfig.h(100),
        flexibleSpace: Container(
          padding: EdgeInsets.only(left: 5),
          color: Colors.green.shade700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vishal Sharma",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "BID: XN12",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeConfig.w(14),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "Reporting: Anjali Mehera",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeConfig.w(14),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    CupertinoIcons.bell,
                    color: Colors.white,
                    size: SizeConfig.w(24),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: SizeConfig.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage invoices, transactions, and financial records",
              style: TextStyle(
                fontSize: SizeConfig.w(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Daily Revenue Card
            _infoCard(
              "Daily Revenue",
              "₹45,280",
              "",
              // No specific icon provided in the image for this card
              Icons.attach_money,
              Colors.blue.shade100,
              Colors.blue.shade800,
              "+8.2%",
              "Today's total",
              Colors.green,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Pending Bills Card
            _infoCard(
              "Pending Bills",
              "12",
              "",
              // No specific icon provided in the image for this card
              Icons.schedule,
              Colors.orange.shade100,
              Colors.orange.shade800,
              "-3",
              "Awaiting payment",
              Colors.red,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Completed Transactions Card
            _infoCard(
              "Completed Transactions",
              "156",
              "",
              // No specific icon provided in the image for this card
              Icons.check_circle,
              Colors.green.shade100,
              Colors.green.shade800,
              "+24",
              "Today",
              Colors.green,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Average Transaction Card
            _infoCard(
              "Average Transaction",
              "₹2,840",
              "",
              // No specific icon provided in the image for this card
              Icons.calculate,
              Colors.purple.shade100,
              Colors.purple.shade800,
              "+5.8%",
              "Per transaction",
              Colors.green,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Recent Transactions Section
            _buildRecentTransactions(context),
            SizedBox(height: SizeConfig.h(16)),

            // Payment Methods Section
            _buildPaymentMethods(context),
            SizedBox(height: SizeConfig.h(16)),
          ],
        ),
      ),
    );
  }

  // Helper widget for info cards
  Widget _infoCard(
    String title,
    String value,
    String trendValue,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
    String trendChange,
    String trendDescription,
    Color trendColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeConfig.w(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(SizeConfig.w(8)),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: SizeConfig.w(24)),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(8)),
            Text(
              value,
              style: TextStyle(
                fontSize: SizeConfig.w(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.h(8)),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(6),
                    vertical: SizeConfig.h(2),
                  ),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trendChange,
                    style: TextStyle(
                      color: trendColor,
                      fontSize: SizeConfig.w(12),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.w(8)),
                Text(
                  trendDescription,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: SizeConfig.w(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for Recent Transactions section
Widget _buildRecentTransactions(BuildContext context) {
  final transactions = [
    {
      "name": "John Doe",
      "txnId": "TXN001",
      "time": "10:30 AM",
      "amount": "₹2,500",
      "status": "completed",
      "statusColor": Colors.green,
    },
    {
      "name": "Jane Smith",
      "txnId": "TXN002",
      "time": "10:25 AM",
      "amount": "₹1,200",
      "status": "pending",
      "statusColor": Colors.orange,
    },
    {
      "name": "Mike Johnson",
      "txnId": "TXN003",
      "time": "10:20 AM",
      "amount": "₹3,800",
      "status": "completed",
      "statusColor": Colors.green,
    },
    {
      "name": "Sarah Wilson",
      "txnId": "TXN004",
      "time": "10:15 AM",
      "amount": "₹950",
      "status": "failed",
      "statusColor": Colors.red,
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Recent Transactions",
        style: TextStyle(
          fontSize: SizeConfig.w(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: SizeConfig.h(4)),
      Text(
        "Latest billing activities and payments",
        style: TextStyle(fontSize: SizeConfig.w(14), color: Colors.grey[600]),
      ),
      SizedBox(height: SizeConfig.h(16)),
      ...transactions
          .map(
            (txn) => _buildTransactionCard(
              txn["name"] as String,
              txn["txnId"] as String,
              txn["time"] as String,
              txn["amount"] as String,
              txn["status"] as String,
              txn["statusColor"] as Color,
            ),
          )
          .toList(),
    ],
  );
}

// Helper widget for individual transaction cards
Widget _buildTransactionCard(
  String name,
  String txnId,
  String time,
  String amount,
  String status,
  Color statusColor,
) {
  return Card(
    margin: EdgeInsets.only(bottom: SizeConfig.h(12)),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.w(16)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.w(10)),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.credit_card,
              color: Colors.blue.shade800,
              size: SizeConfig.w(24),
            ),
          ),
          SizedBox(width: SizeConfig.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: SizeConfig.w(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.h(4)),
                Text(
                  "$txnId • $time",
                  style: TextStyle(
                    fontSize: SizeConfig.w(13),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: SizeConfig.w(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.h(4)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(8),
                  vertical: SizeConfig.h(4),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: SizeConfig.w(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Widget for Payment Methods section
Widget _buildPaymentMethods(BuildContext context) {
  final paymentData = [
    {"method": "Cash Payment", "percentage": 45, "color": Colors.blue},
    {"method": "Card Payment", "percentage": 35, "color": Colors.green},
    {"method": "UPI/Digital", "percentage": 20, "color": Colors.orange},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Payment Methods",
        style: TextStyle(
          fontSize: SizeConfig.w(20),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: SizeConfig.h(4)),
      Text(
        "Transaction breakdown by payment type",
        style: TextStyle(fontSize: SizeConfig.w(14), color: Colors.grey[600]),
      ),
      SizedBox(height: SizeConfig.h(16)),
      ...paymentData
          .map(
            (data) => _buildPaymentMethodItem(
              data["method"] as String,
              data["percentage"] as int,
              data["color"] as Color,
            ),
          )
          .toList(),
    ],
  );
}

// Helper widget for individual payment method items
Widget _buildPaymentMethodItem(String method, int percentage, Color color) {
  return Padding(
    padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
    child: Row(
      children: [
        Container(
          width: SizeConfig.w(10),
          height: SizeConfig.h(10),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: SizeConfig.w(12)),
        Expanded(
          child: Text(
            method,
            style: TextStyle(
              fontSize: SizeConfig.w(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          "$percentage%",
          style: TextStyle(
            fontSize: SizeConfig.w(14),
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    ),
  );
}
