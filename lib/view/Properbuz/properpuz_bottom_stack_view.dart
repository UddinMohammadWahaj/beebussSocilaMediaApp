import 'package:bizbultest/services/Properbuz/add_items_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_menu_controller.dart';
import 'package:bizbultest/services/Properbuz/report_controller.dart';
import 'package:bizbultest/services/Properbuz/tags_feed_controller.dart';
import 'package:bizbultest/services/Properbuz/tradesman_logo_icon.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_appbar.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/add_items_view.dart';
import 'package:bizbultest/view/Properbuz/add_new_item_view.dart';
import 'package:bizbultest/view/Properbuz/properbuz_feeds_view.dart';
import 'package:bizbultest/view/Properbuz/properbuz_home_view.dart';
import 'package:bizbultest/view/Properbuz/properbuz_menu_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProperbuzBottomStackView extends GetView<ProperbuzController> {
  final Function? setNavbar;
  final Function? changeColor;
  final Function? isChannelOpen;

  ProperbuzBottomStackView(
      {Key? key, this.setNavbar, this.changeColor, this.isChannelOpen})
      : super(key: key);

  var isTradesman = false.obs;
  BottomNavigationBarItem _bottomButton(IconData iconData, {msg: ''}) {
    return msg == ''
        ? BottomNavigationBarItem(
            label: '',
            icon: Icon(
              iconData,
              size: iconData == CustomIcons.menu_icon
                  ? 19
                  : iconData == CustomIcons.home_icon
                      ? 20
                      : iconData == CustomIcons.add_icon
                          ? 22
                          : 25,
            ),

            // title: Container(
            //   height: 0,
            // )
          )
        : isTradesman.value
            ? BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  iconData,
                  size: 25,
                  color: primaryPinkColor,
                ),

                // title: Container(
                //   height: 0,
                // )
              )
            : BottomNavigationBarItem(
                label: '',
                icon: Container(
                    child: Image.asset('assets/icons/tradesmaniconimage.png'),
                    height: 27,
                    width: 40)

                // title: Container(
                //   height: 0,
                // )
                );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => (ProperbuzController()), fenix: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppbar(
          setNavbar: setNavbar,
          isChannelOpen: isChannelOpen,
          changeColor: changeColor,
          elevation: 0,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          alignment: Alignment.center,
          height: 65,
          child: BottomNavigationBar(
            onTap: (int index) {
              if (index == 3) {
                isTradesman.value = true;
              } else {
                isTradesman.value = false;
              }
              controller.changeTabs(index);
            },
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.black,
            selectedItemColor: primaryPinkColor,
            currentIndex: controller.currentIndex.value,
            items: [
              _bottomButton(CustomIcons.search_icon),
              _bottomButton(CustomIcons.home_icon),
              _bottomButton(CustomIcons.add_icon),
              // _bottomButton(CustomIcons.manager),

              // _bottomButton(TradesmanLogo.icon_12, msg: 'tradesmanicon'),
              _bottomButton(CustomIcons.menu_icon),
            ],
          ),
        ),
      ),
      body: Obx(
        () => WillPopScope(
          onWillPop: () async {
            if (controller.currentIndex.value != 0) {
              controller.changeTabs(0);

              return false;
            } else {
              Navigator.pop(context);
              Get.delete<ProperbuzController>();
              Get.delete<ProperbuzFeedController>();
              Get.delete<AddItemsController>();
              Get.delete<ProperbuzMenuController>();
              Get.delete<ReportController>();
              setNavbar!(false);
              return true;
            }
          },
          child: IndexedStack(
            index: controller.currentIndex.value,
            children: [
              ProperbuzHomeView(
                setNavbar: setNavbar!,
                isChannelOpen: isChannelOpen!,
                changeColor: changeColor!,
              ),
              ProperbuzFeedsView(),
              AddItemsView(),
              // AddNewItemsView(),
              ProperbuzMenuView()
            ],
          ),
        ),
      ),
    );
  }
}
