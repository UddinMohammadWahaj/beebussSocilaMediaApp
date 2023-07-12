import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Wallet/widgets/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zefyrka/zefyrka.dart';

import '../../services/Wallet/bebuzeewalletcontroller.dart';
import '../Wallet/models/credicarmiodle.dart';

class BebuzeeWalletView extends StatefulWidget {
  BebuzeeWalletView({Key? key}) : super(key: key);

  @override
  State<BebuzeeWalletView> createState() => _BebuzeeWalletViewState();
}

class _BebuzeeWalletViewState extends State<BebuzeeWalletView> {
  var walletController = Get.put(BebuzeeWalletController());
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BebuzeeWalletController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//  Widget cu
    // List<CreditCardModel> getCreditCards() {
    //   List<CreditCardModel> creditCards = [];

    //   creditCards.add(CreditCardModel(
    //       "3015788947523652",
    //       "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png",
    //       "04/25",
    //       "217"));
    //   return creditCards;
    // }

    Widget walletCard() {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            width: 100.0.w,
            height: 25.0.h,
            child: Obx(() => walletController.walletBal.value.isNotEmpty
                ? CreditCard(
                    card: CreditCardModel(
                        "3015788947523652",
                        "https://resources.mynewsdesk.com/image/upload/ojf8ed4taaxccncp6pcp.png",
                        "04/25",
                        "217",
                        walletController.walletBal.value)

                    //  getCreditCards()[0],
                    )
                : Container(
                    child: Center(child: loadingAnimation()),
                  ))),
      );
    }

    Widget cutsomExpenseCard(index) {
      return ListTile(
        leading: CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.attach_money,
              color: Colors.white,
            )),
        title:
            Text('${walletController.wallletHistoryList[index].description}'),
        trailing: Text(
            '${walletController.wallletHistoryList[index].credited == '0' ? '-' : '+'} \$ ${walletController.wallletHistoryList[index].credited == '0' ? walletController.wallletHistoryList[index].debited : walletController.wallletHistoryList[index].credited}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        isThreeLine: true,
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${walletController.wallletHistoryList[index].creditedAt}')
            ],
          ),
        ),
      );
    }

    Widget recentTransactions() {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 100.0.h,
          child: Column(children: [
            Container(
              width: 100.0.w,
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transcations',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 3.0.h),
                      ),
                      InkWell(onTap: () {}, child: Text('View All'))
                    ],
                  )),
            ),

            Obx(
              () => walletController.wallletHistoryList.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: walletController.wallletHistoryList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return cutsomExpenseCard(index);
                      },
                    )
                  : Container(
                      child: Center(
                      child: Text('No Transaction History found'),
                    )),
            )
            // cutsomExpenseCard()
          ]),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text('Your Wallet', style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: [walletCard(), recentTransactions()]),
        )));
  }
}
