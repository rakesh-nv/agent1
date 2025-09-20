import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';
import 'package:mbindiamy/controllers/login_controller.dart';
import 'package:mbindiamy/controllers/reporting_controller.dart';

import '../controllers/branch_manager_controller/sales_comparison_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/total_sales_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  late final AnimationController _bottomSheetController;
  late final Animation<double> _slideAnimation;
  late final AnimationController _fadeController;
  late final List<Animation<double>> _fieldFadeAnimations;

  bool _isUpdating = false;
  String? _selectedBranchId;

  final LoginController loginController = Get.find<LoginController>();
  final ReportingManagerController reportingManagerController =
      Get.find<ReportingManagerController>();
  final SalesComparisonController salesComparisonController = Get.find<SalesComparisonController>();
  final TotalSalesController totalSalesController = Get.find<TotalSalesController>();
  final profileController = Get.find<ProfileController>();

  final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();

    _bottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _bottomSheetController, curve: Curves.easeOutCubic));

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fieldFadeAnimations = List.generate(
      6, //
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(
            index * 0.2,
            (index + 1) * 0.2 > 1.0 ? 1.0 : (index + 1) * 0.2,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fadeController.forward();
      await reportingManagerController.getReportingManager();
      await loginController.loadUserData();
      await salesComparisonController.fetchThisMonthSales();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bottomSheetController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _showEditProfileBottomSheet(BuildContext context) {
    final loginResponse = loginController.loginResponse.value;
    if (loginResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user data available. Please try again later.')),
      );
      return;
    }

    final user = loginResponse.data!.user;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.mobile;
    _locationController.text = user.id;

    // // Fix: Set initial value to first branch or null if empty
    // _selectedBranchId = user.selectedBranchAliases.isNotEmpty
    //     ? user.selectedBranchAliases.first
    //     : null;

    _bottomSheetController.forward();
    _fadeController.forward();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, AppStyle.screenHeight * _slideAnimation.value),
                  child: child,
                );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: AppStyle.screenHeight * 0.65,
                  minHeight: AppStyle.screenHeight * 0.4,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppStyle.w(6))),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.75), Colors.white.withOpacity(0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.2),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppStyle.w(5),
                          AppStyle.h(3),
                          AppStyle.w(5),
                          MediaQuery.of(context).viewInsets.bottom + AppStyle.h(3),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(AppStyle.w(5)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppStyle.w(6)),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FadeTransition(
                                    opacity: _fieldFadeAnimations[0],
                                    child: Text(
                                      'Edit Profile',
                                      style: AppStyle.headTextStyle().copyWith(
                                        fontSize: AppStyle.headFontSize,
                                        fontWeight: FontWeight.bold,
                                        // color: ,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: AppStyle.h(2)),
                                  Divider(thickness: 1, color: Colors.grey.withOpacity(0.3)),
                                  _buildAnimatedField(
                                    index: 1,
                                    controller: _nameController,
                                    label: 'Name',
                                    icon: Icons.person,
                                    validator: (v) =>
                                        v!.trim().isEmpty ? 'Please enter your name' : null,
                                  ),
                                  _buildAnimatedField(
                                    index: 2,
                                    controller: _emailController,
                                    label: 'Email',
                                    icon: Icons.email,
                                    inputType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v!.trim().isEmpty) return 'Please enter your email';
                                      if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(v)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  _buildAnimatedField(
                                    index: 3,
                                    controller: _phoneController,
                                    label: 'Phone',
                                    icon: Icons.phone,
                                    inputType: TextInputType.phone,
                                    validator: (v) {
                                      if (v!.trim().isEmpty) return 'Please enter your phone';
                                      if (!RegExp(r'^[\+?\d\s-]{10,15}$').hasMatch(v)) {
                                        return 'Enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                  // _buildAnimatedField(
                                  //   index: 4,
                                  //   controller: _locationController,
                                  //   label: 'User ID',
                                  //   icon: Icons.badge,
                                  //   validator: (v) => v!.trim().isEmpty ? 'Please enter your user ID' : null,
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(top: AppStyle.h(3)),
                                  //   child: FadeTransition(
                                  //     opacity: _fieldFadeAnimations[5],
                                  //     child: DropdownButtonFormField<String>(
                                  //       value: _selectedBranchId,
                                  //       decoration: InputDecoration(
                                  //         labelText: 'Branch',
                                  //         prefixIcon: Icon(Icons.store, color: AppStyle.appBarColor),
                                  //         filled: true,
                                  //         fillColor: Colors.white.withOpacity(0.9),
                                  //         border: OutlineInputBorder(
                                  //           borderRadius: BorderRadius.circular(AppStyle.w(3)),
                                  //           borderSide: BorderSide.none,
                                  //         ),
                                  //         contentPadding: EdgeInsets.symmetric(
                                  //           horizontal: AppStyle.w(4),
                                  //           vertical: AppStyle.h(2.5),
                                  //         ),
                                  //       ),
                                  //       items: user.selectedBranchAliases.isEmpty
                                  //           ? [
                                  //               const DropdownMenuItem(
                                  //                 value: 'No Branches',
                                  //                 child: Text('No Branches'),
                                  //               ),
                                  //             ]
                                  //           : user.selectedBranchAliases.map((branch) {
                                  //               return DropdownMenuItem(
                                  //                 value: branch,
                                  //                 child: Text(branch),
                                  //               );
                                  //             }).toList(),
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           _selectedBranchId = value;
                                  //         });
                                  //       },
                                  //       validator: (value) {
                                  //         if (user.userType != 'head' && value == null) {
                                  //           return 'Please select a branch';
                                  //         }
                                  //         return null;
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: AppStyle.h(3)),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: profileController.isLoading.value
                                              ? null
                                              : () {
                                                  if (_formKey.currentState != null) {
                                                    _formKey.currentState!.reset();
                                                  }
                                                  _nameController.text = user.name;
                                                  _emailController.text = user.email;
                                                  _phoneController.text = user.mobile;
                                                  _locationController.text = user.id;
                                                  _selectedBranchId = user.id;
                                                  _bottomSheetController.reverse();
                                                  Navigator.pop(context);
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade200,
                                            foregroundColor: Colors.black87,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                      SizedBox(width: AppStyle.w(3)),
                                      Expanded(
                                        child: Obx(
                                          () => ElevatedButton(
                                            onPressed: profileController.isLoading.value
                                                ? null
                                                : () async {
                                                    if (_formKey.currentState!.validate()) {
                                                      // if (user.userType != 'head' && _selectedBranchId == null) {
                                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                                      //     const SnackBar(
                                                      //       content: Text('Branch ID is required'),
                                                      //     ),
                                                      //   );
                                                      //   return;
                                                      // }

                                                      await profileController.updateProfile(
                                                        id: user.id,
                                                        name: _nameController.text.trim(),
                                                        email: _emailController.text.trim(),
                                                        mobile: _phoneController.text.trim(),
                                                      );

                                                      if (profileController.errorMessage.value !=
                                                          null) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              profileController.errorMessage.value!,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        _bottomSheetController.reverse();
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Profile updated successfully!',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: profileController.isLoading.value
                                                  ? Colors.grey
                                                  : AppStyle.appBarColor,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              profileController.isLoading.value
                                                  ? 'Saving...'
                                                  : 'Save',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _bottomSheetController.reset();
      _fadeController.reset();
    });
  }

  Widget _buildAnimatedField({
    required int index,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: AppStyle.h(3)),
      child: FadeTransition(
        opacity: _fieldFadeAnimations[index],
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyle.w(3)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppStyle.w(4),
              vertical: AppStyle.h(2.5),
            ),
          ),
          style: AppStyle.normalTextStyle(),
          validator: validator,
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppStyle.h(1.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppStyle.textColor, size: AppStyle.w(5.5).clamp(20.0, 28.0)),
          SizedBox(width: AppStyle.w(3).clamp(8.0, 16.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyle.normalTextStyle().copyWith(
                    color: AppStyle.textColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: AppStyle.normalTextStyle().copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppStyle.init(context);

    return Obx(() {
      final loginResponse = loginController.loginResponse.value;
      if (loginResponse == null) {
        return const Center(child: CircularProgressIndicator());
      }
      final currentUser = loginResponse.data?.user;

      final bool isTabletOrDesktop = AppStyle.isTablet || AppStyle.isDesktop;
      final maxContentWidth = (AppStyle.screenWidth * (isTabletOrDesktop ? 0.8 : 1.0)).clamp(
        300.0,
        900.0,
      );
      final horizontalPadding = _getHorizontalPadding();

      // final String displayUserId = currentUser?.userType == 'head'
      //     ? 'All Branches'
      //     : (currentUser!.selectedBranchAliases.isNotEmpty
      //           ? currentUser.selectedBranchAliases.first
      //           : '');
      // final String displayUserId = currentUser?.isAllBranches == true
      //     ? 'All Branches'
      //     : (currentUser!.selectedBranchAliases.isNotEmpty
      //     ? currentUser.selectedBranchAliases.first
      //     : '');

      final userName = loginController.loginResponse.value?.data!.user.name ?? "Loading...";

      final user = loginResponse.data?.user;

      final userId = user == null
          ? ''
          : (user.userType.toLowerCase() == 'head' || user.isAllBranches == true)
          ? 'All Branches'
          : (user.selectedBranchAliases.isNotEmpty
                ? user.selectedBranchAliases.join(', ') // joins all branches as a string
                : '');
      return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: CustomAppBar(
          userName: userName,
          userId: userId,
          onNotificationPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Notifications clicked!')));
          },
        ),
        backgroundColor: AppStyle.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: isTabletOrDesktop
                          ? _buildTabletLayout(context)
                          : _buildMobileLayout(context),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  double _getHorizontalPadding() {
    if (AppStyle.isDesktop) return 60.0;
    if (AppStyle.isTablet) return 40.0;
    return 12.0;
  }

  Widget _buildMobileLayout(BuildContext context) {
    final loginResponse = loginController.loginResponse.value;
    if (loginResponse == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProfileHeader(context),
        SizedBox(height: AppStyle.h(4).clamp(16.0, 32.0)),
        _buildPersonalInfo(context),
        SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
        _buildWorkInfo(context),
        SizedBox(height: AppStyle.h(2.5).clamp(8.0, 16.0)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final loginResponse = loginController.loginResponse.value;
    if (loginResponse == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: Column(children: [_buildProfileHeader(context)])),
        SizedBox(width: AppStyle.w(4).clamp(16.0, 32.0)),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPersonalInfo(context),
              SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
              _buildWorkInfo(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final loginResponse = loginController.loginResponse.value;
    if (loginResponse == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: AppStyle.h(2).clamp(8.0, 16.0)),
      padding: EdgeInsets.all(AppStyle.w(5).clamp(14.0, 30.0)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppStyle.appBarColor, AppStyle.appBarColor.withOpacity(.7)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SizedBox(height: AppStyle.h(2).clamp(20, 20)),
            CircleAvatar(
              radius: AppStyle.w(10).clamp(40.0, 60.0),
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: AppStyle.w(15).clamp(40.0, 60.0),
                color: AppStyle.textColor,
              ),
            ),
            SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
            Text(
              loginResponse.data!.user.name,
              style: AppStyle.headTextStyle().copyWith(color: AppStyle.appBarTextColor),
            ),
            if (loginResponse.data!.user.userType == 'head')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppStyle.w(4), vertical: AppStyle.h(2)),
                child: Chip(
                  label: Text(
                    'All Branches',
                    style: AppStyle.normalTextStyle().copyWith(color: AppStyle.appBarColor),
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            Text(
              loginResponse.data!.user.grade,
              style: AppStyle.normalTextStyle().copyWith(
                color: AppStyle.appBarTextColor.withOpacity(0.7),
              ),
            ),
            SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _showEditProfileBottomSheet(context),
              icon: Icon(Icons.edit, size: AppStyle.w(4).clamp(16.0, 20.0)),
              label: Text('Edit Profile', style: AppStyle.normalTextStyle()),
            ),
            SizedBox(height: AppStyle.h(2).clamp(10, 10)),
          ],
        ),
      ),
    );

    // return Container(
    //   margin: EdgeInsets.only(top: AppStyle.h(2).clamp(8.0, 16.0)),
    //   padding: EdgeInsets.all(AppStyle.w(5).clamp(14.0, 30.0)),
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       colors: [AppStyle.appBarColor, AppStyle.appBarColor.withOpacity(.7)],
    //       begin: Alignment.bottomRight,
    //       end: Alignment.topLeft,
    //     ),
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   child: Column(
    //     children: [
    //       CircleAvatar(
    //         radius: AppStyle.w(10).clamp(40.0, 60.0),
    //         backgroundColor: Colors.white,
    //         child: Icon(
    //           Icons.person,
    //           size: AppStyle.w(15).clamp(40.0, 60.0),
    //           color: AppStyle.textColor,
    //         ),
    //       ),
    //       SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
    //       Text(
    //         loginResponse.data.user.name,
    //         style: AppStyle.headTextStyle().copyWith(
    //           color: AppStyle.appBarTextColor,
    //         ),
    //       ),
    //       if (loginResponse.data.user.userType == 'head')
    //         Padding(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: AppStyle.w(4),
    //             vertical: AppStyle.h(2),
    //           ),
    //           child: Chip(
    //             label: Text(
    //               'All Branches',
    //               style: AppStyle.normalTextStyle().copyWith(
    //                 color: AppStyle.appBarColor,
    //               ),
    //             ),
    //             backgroundColor: Colors.white,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(20),
    //             ),
    //           ),
    //         )
    //       else if (loginResponse.data.user.selectedBranchAliases.isNotEmpty)
    //         Container(
    //           height: loginResponse.data.user.selectedBranchAliases.length > 2
    //               ? AppStyle.h(12)
    //               : AppStyle.h(8),
    //           padding: EdgeInsets.symmetric(horizontal: AppStyle.w(4)),
    //           child: SingleChildScrollView(
    //             child: Wrap(
    //               spacing: AppStyle.w(2),
    //               runSpacing: AppStyle.h(1),
    //               children: loginResponse.data.user.selectedBranchAliases.map((
    //                 branch,
    //               ) {
    //                 return Text(branch);
    //               }).toList(),
    //             ),
    //           ),
    //         )
    //       else
    //         Text('No branches assigned'),
    //       Text(
    //         loginResponse.data.user.grade,
    //         style: AppStyle.normalTextStyle().copyWith(
    //           color: AppStyle.appBarTextColor.withOpacity(0.7),
    //         ),
    //       ),
    //       SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
    //       ElevatedButton.icon(
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: Colors.white,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //         ),
    //         onPressed: () => _showEditProfileBottomSheet(context),
    //         icon: Icon(Icons.edit, size: AppStyle.w(4).clamp(16.0, 20.0)),
    //         label: Text('Edit Profile', style: AppStyle.normalTextStyle()),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    final loginResponse = loginController.loginResponse.value;
    if (loginResponse == null) return const SizedBox.shrink();
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(AppStyle.w(4).clamp(16.0, 32.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personal Information", style: AppStyle.headTextStyle()),
            SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
            infoRow(Icons.person, "Name", loginResponse.data!.user.name),
            infoRow(Icons.email, "Email", loginResponse.data!.user.email),
            infoRow(Icons.phone, "Phone", loginResponse.data!.user.mobile),
            //infoRow(Icons.badge, "User ID", loginResponse.data.user.id),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkInfo(BuildContext context) {
    final loginResponse = loginController.loginResponse.value;
    if (loginResponse == null) return const SizedBox.shrink();
    String formattedLastLogin = 'Not specified';
    try {
      // debugPrint('loginResponse.timestamp: ${loginResponse.timestamp}');
      if (loginResponse.timestamp != null && loginResponse.timestamp!.isNotEmpty) {
        final dateTime = DateTime.parse(loginResponse.data!.user.templateId.createdAt);
        formattedLastLogin = DateFormat('dd MMM yyyy').format(dateTime);
      }
    } catch (e) {
      // Keep default 'Not specified' if parsing\ fails
    }
    // Fetch the manager's name from ReportingManagerController
    // final managerName = reportingManagerController.manager.value?.name ?? loginResponse.data.user.reportingTo;
    final reportingTo = reportingManagerController.manager.value.toString();
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(AppStyle.w(4).clamp(16.0, 32.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Work Information", style: AppStyle.headTextStyle()),
            SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
            infoRow(Icons.date_range, "Date of Joining", formattedLastLogin),
            infoRow(Icons.business, "Designation", loginResponse.data!.user.userType),
            infoRow(Icons.work, "Grade", loginResponse.data!.user.grade),
            if (loginResponse.data!.user.userType != 'head')
              infoRow(Icons.person_pin, "Reporting To", reportingTo), // Use managerName here
            SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),
            Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppStyle.w(5).clamp(16.0, 32.0)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppStyle.appBarColor, AppStyle.appBarColor.withOpacity(0.7)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Status",
                      style: AppStyle.headTextStyle().copyWith(color: AppStyle.appBarTextColor),
                    ),
                    SizedBox(height: AppStyle.h(2).clamp(8.0, 16.0)),

                    Obx(() {
                      final thisMonthSales =
                          salesComparisonController.thisMonthSalesData.value ?? 0.0;
                      return Text(
                        "Total Sales This Month : ₹${thisMonthSales.toStringAsFixed(0)}",
                        style: AppStyle.normalTextStyle().copyWith(color: AppStyle.appBarTextColor),
                      );
                    }),
                    //
                    // Text(
                    //   "Targets Achieved: 10/10",
                    //   style: AppStyle.normalTextStyle().copyWith(color: AppStyle.appBarTextColor),
                    // ),
                    Text(
                      "Performance Rating : ₹${totalSalesController.myIncentive.value != null ? totalSalesController.myIncentive.value!.toStringAsFixed(2) : 'N/A'}",
                      style: AppStyle.normalTextStyle().copyWith(color: AppStyle.appBarTextColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final LinearGradient? gradient;

  const _AnimatedButton({
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
    this.gradient,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null) {
          _scaleController.forward();
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null) {
          _scaleController.reverse();
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null) {
          _scaleController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppStyle.w(8).clamp(24.0, 40.0),
                vertical: AppStyle.h(3).clamp(12.0, 16.0),
              ),
              decoration: BoxDecoration(
                gradient: widget.gradient,
                color: widget.gradient == null ? widget.color : null,
                borderRadius: BorderRadius.circular(AppStyle.w(3)),
                boxShadow: widget.onPressed == null
                    ? null
                    : [
                        BoxShadow(
                          color: widget.color.withOpacity(0.4),
                          blurRadius: AppStyle.w(6),
                          offset: Offset(0, AppStyle.h(2)),
                          spreadRadius: 1,
                        ),
                      ],
              ),
              child: Text(
                widget.text,
                style: AppStyle.normalTextStyle().copyWith(
                  color: widget.textColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
