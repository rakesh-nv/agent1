import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/BranchManagerSalesVsPromiseController.dart';
import 'package:mbindiamy/widget/InfoCard.dart';

class SalesVSPromiseInfoRow extends StatelessWidget {
  const SalesVSPromiseInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    final BranchManagerSalesVsPromiseController controller = Get.find();

    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      } else if (controller.errorMessage.isNotEmpty) {
        return Text('Error: ${controller.errorMessage.value}');
      } else if (controller.salesVsPromiseData.value != null) {
        final thisWeekSales = controller
            .salesVsPromiseData
            .value!
            .data
            .thisWeek
            .totals
            .totalSales;
        final lastWeekSales = controller
            .salesVsPromiseData
            .value!
            .data
            .lastWeek
            .totals
            .totalSales;

        // Calculate growth
        double growth = 0.0;
        Color growthColor = Colors.black87;
        if (lastWeekSales != 0) {
          growth = ((thisWeekSales - lastWeekSales) / lastWeekSales) * 100;
          if (growth > 0) {
            growthColor = Colors.green;
          } else if (growth < 0) {
            growthColor = Colors.red;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InfoCard(
                label: "Avg This Week",
                value: "₹${(thisWeekSales / 100000).toStringAsFixed(1)}L",
                color: Colors.green,
              ),
            ),
            Expanded(
              child: InfoCard(
                label: "Avg Last Week",
                value: "₹${(lastWeekSales / 100000).toStringAsFixed(1)}L",
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: InfoCard(
                label: "Growth",
                value: "${growth.toStringAsFixed(1)}%",
                color: growthColor,
              ),
            ),
          ],
        );
      } else {
        return const Text('No data available');
      }
    });
  }
}
