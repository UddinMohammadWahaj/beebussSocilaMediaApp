import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Contact? contact;
  final String? searchKeyword;
  final VoidCallback? onProfileTap;
  final VoidCallback? onTap;

  ContactCard(
      {this.contact, this.searchKeyword, this.onProfileTap, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      leading: SizedBox(
        width: 45.0,
        height: 45.0,
        child: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: Icon(
              Icons.account_circle,
              size: 40.0,
            ),
            color: lightGrey,
            onPressed: onProfileTap),
      ),
      title: searchKeyword == null || searchKeyword!.isEmpty
          ? Text(
              // ignore: unnecessary_null_comparison
              contact!.displayName! == "" && contact!.displayName! == null
                  ? contact!.phones!.first.value!
                  : contact!.displayName!,
              maxLines: 2,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            )
          : TextHelpers.getHighlightedText(
              contact!.displayName!,
              searchKeyword!,
              TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
//      subtitle: Text(
//        _contact.displayName.lastMessage.content,
//        maxLines: 1,
//      ),
      onTap: onTap,
    );
  }
}
