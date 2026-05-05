import 'package:fan_side_drawer/fan_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:healginx/constants/app_images.dart';
import 'package:healginx/core/local_cache/shared_preferences.dart';
import 'package:healginx/styles/app_colors.dart';
// import 'package:phleb_project_one/constants/app_images.dart';
// import 'package:phleb_project_one/core/local_cache/shared_preferences.dart';
// import 'package:phleb_project_one/core/navigation_service.dart';
// import 'package:phleb_project_one/feature/login/data/model/login_model.dart';
// import 'package:phleb_project_one/injection_container.dart';
// import 'package:phleb_project_one/styles/app_colors.dart';

import 'logout_dialog.dart';


class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey ;

  const CustomDrawer({super.key, required this.scaffoldKey});


  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  // LoginModel? loginModel;

  @override
  void initState() {
    _initMethod();
    super.initState();
  }

  _initMethod() async {
    // LoginModel? model = await SharedPreferencesClient.instance.getSessionData();
    // if(model != null){
    //   loginModel = model;
    //   setState(() {});
    // }
  }




  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 255,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with user info
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountName: Text("",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w500)),
            accountEmail: Text(
                "N/A",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey)),
            currentAccountPicture: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      AppImages.profileImage
                  )
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: FanSideDrawer(
                drawerType: DrawerType.pipe,
                animationDuration: const Duration(milliseconds: 200),
                menuItems: getMenuItems(context),
                selectedItemBackgroundColor: AppColors.primary.withOpacity(0.9),
                selectedColor: Colors.white,
                menuItemTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color(0xff8793A2)
                )
            ),
          ),
        ],
      ),
    ) ;
  }

  List<DrawerMenuItem> getMenuItems(BuildContext context) {
    Duration duration = const Duration(milliseconds: 200) ;

    return [
      DrawerMenuItem(
        title: 'Home',
        icon: Icons.other_houses_outlined,
        iconSize: 20,
        onMenuTapped: () {
          Future.delayed(duration, (){
            widget.scaffoldKey.currentState!.closeDrawer();

            // sl<NavigationService>().pushReplacement(FacilityListScreen());

          }) ;
        },
      ),
      DrawerMenuItem(
        title: 'Profile',
        icon: Icons.account_circle_outlined,
        iconSize: 20,
        onMenuTapped: () {
          Future.delayed(duration, (){
            widget.scaffoldKey.currentState!.closeDrawer() ;
           // const ProfileScreen().push(context) ;
          }) ;
        },
      ),
      DrawerMenuItem(
        title: 'Logout',
        icon: Icons.logout,
        iconSize: 20,
        onMenuTapped: () {
          Future.delayed(duration, (){
            widget.scaffoldKey.currentState!.closeDrawer() ;
            if(context.mounted) {
              LogoutDialog.show(context);
            }
          }) ;
        },
      ),
    ];
  }
}