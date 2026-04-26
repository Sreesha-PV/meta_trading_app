import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/config/theme/app_textstyle.dart';
import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/app/services/authservices.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Drawer(
      shape:  const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,),
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
        

          Obx(() {
  final user = userController.userDetails.value;

  if (user == null) {
    return const Center(child: CircularProgressIndicator());
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
          Text(
            user.email,
            // style: const TextStyle(color: AppColors.textSecondary),
            style: AppTextStyle.body2_400.textSecondary(context),
          ),

        // ID
      
          Text(
            'User ID: ${user.userId}',
            // style: const TextStyle(color: AppColors.textSecondary),
            style: AppTextStyle.body2_400.textSecondary(context),

          ),
      ],
    ),
  );
}),


          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(
                    Icons.show_chart,
                    // color: Colors.black,
                    color: AppColors.textPrimary(context),
                    ),
                  title:  Text('Trade',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle navigation
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  // Icon(CupertinoIcons.article_outlined)
                  leading:  Icon(CupertinoIcons.news,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title:  Text('News',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle navigation
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.email_outlined,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title: Text('Mailbox',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle navigation
                  },
                ),
                
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  // Icon(CupertinoIcons.book_solid)
                  leading:  Icon(CupertinoIcons.book_solid,
                  // color: Colors.black,
                  color:AppColors.textPrimary(context),
                  ),
                  title:  Text('Journal',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.settings,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title:  Text('Settings',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.calendar_today_outlined,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title:  Text('Economic calendar',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.people_outline,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title:  Text('Traders Community',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.send_outlined,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title:  Text('MQL5 Algo Trading',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),
                  
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(CupertinoIcons.question_circle,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title: Text('User guide',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.info_outline,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title: Text('About',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),

                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading:  Icon(Icons.logout_rounded,
                  // color: Colors.black,
                  color: AppColors.textPrimary(context),
                  ),
                  title: Text('Logout',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: AppTextStyle.body2_700.textPrimary(context),

                  ),
                  onTap: () async {
                    await AuthService().logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
