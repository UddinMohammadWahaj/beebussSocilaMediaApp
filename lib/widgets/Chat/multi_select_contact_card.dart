import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/text_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class MultiSelectContactCard extends StatelessWidget {
  final Contact? contact;
  final String? searchKeyword;
  final VoidCallback? onProfileTap;
  final VoidCallback? onTap;
  final List<Contact>? allContacts;
  final List<Contact>? selectedContacts;

  MultiSelectContactCard(
      {this.contact,
      this.searchKeyword,
      this.onProfileTap,
      this.onTap,
      this.allContacts,
      this.selectedContacts});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selectedContacts!.contains(contact)
          ? Colors.grey.withOpacity(0.3)
          : Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        leading: Stack(
          children: [
            SizedBox(
              width: 45.0,
              height: 45.0,
              child: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.account_circle,
                    size: 45.0,
                  ),
                  color: lightGrey,
                  onPressed: onProfileTap),
            ),
            selectedContacts!.contains(contact)
                ? Positioned(
                    top: 25,
                    left: 25,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: darkColor,
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
        title: searchKeyword == null || searchKeyword!.isEmpty
            ? Text(
                // contact!.displayName == "" && contact!.displayName.to == null ? contact.phones.first.value : contact.displayName,
                contact!.displayName!,
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
      ),
    );
  }
}
