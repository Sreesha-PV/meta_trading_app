import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/screens/services/authservices.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Drawer(
      shape:  const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,),
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Obx(() {
          //   final userDetails = userController.userDetails.value;
          //   // if (userDetails.isEmpty) {
          //   //   return const Center(child: CircularProgressIndicator());
          //   // }
          //   final userDetails = userController.userDetails.value;
          //   if (userDetails == null || userDetails.isEmpty) {
          //     return const Center(child: CircularProgressIndicator());
          //   }
          //   // final data = userDetails['data'];
          //   if (data == null) {
          //     return const Padding(
          //       padding: EdgeInsets.all(16),
          //       child: Text('Guest', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //     );
          //   }
          //   return Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('${data['firstName']} ${data['lastName']}',
          //             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //         if (data['email'] != null)
          //           Text(data['email'], style: const TextStyle(
          //             // color: Colors.grey
          //             color:AppColors.textSecondary
          //             )),
          //         if (data['accountType'] != null)
          //           Text('Account Type: ${data['accountType']}',
          //               style: const TextStyle(
          //                 // color: Color.fromARGB(255, 158, 158, 158)
          //                 color:AppColors.textSecondary
          //                 )),
          //       ],
          //     ),
          //   );
          // }),



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
        // Name
       
          // Text(
          //   user.name,
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),

        // Email
       
          Text(
            user.email,
            style: const TextStyle(color: AppColors.textSecondary),
          ),

        // ID
      
          Text(
            'User ID: ${user.userId}',
            style: const TextStyle(color: AppColors.textSecondary),
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
                  leading: const Icon(
                    Icons.show_chart,
                    // color: Colors.black,
                    color: AppColors.textPrimary,
                    ),
                  title: const Text('Trade',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle navigation
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  // Icon(CupertinoIcons.article_outlined)
                  leading: const Icon(CupertinoIcons.news,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('News',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle navigation
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.email_outlined,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('Mailbox',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle navigation
                  },
                ),
                
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  // Icon(CupertinoIcons.book_solid)
                  leading: const Icon(CupertinoIcons.book_solid,
                  // color: Colors.black,
                  color:AppColors.textPrimary,
                  ),
                  title: const Text('Journal',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.settings,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('Settings',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.calendar_today_outlined,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('Economic calendar',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.people_outline,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('Traders Community',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.send_outlined,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('MQL5 Algo Trading',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(CupertinoIcons.question_circle,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('User guide',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.info_outline,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('About',style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                    // handle logout
                  },
                ),

                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  leading: const Icon(Icons.logout_rounded,
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  ),
                  title: const Text('Logout',style: TextStyle(fontWeight: FontWeight.bold),),
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
