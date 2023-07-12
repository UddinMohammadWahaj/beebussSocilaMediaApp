import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';

enum MediaUploadCharacter { Auto, BestQuality, DataSaver }

class StorageAndData extends StatefulWidget {
  const StorageAndData({Key? key}) : super(key: key);

  @override
  _StorageAndDataState createState() => _StorageAndDataState();
}

class _StorageAndDataState extends State<StorageAndData> {
  bool _useLessDataAndCall = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage And Data'),
        flexibleSpace: gradientContainer(null),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                  leading: Icon(Icons.folder),
                  title: Text('Manage storage'),
                  subtitle: Text('480.3 MB'),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                ),
                ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 15, 0),
                  leading: Icon(Icons.data_usage),
                  title: Text('Manage storage'),
                  subtitle: Text('7.8 GB sent • 3.6 GB received'),
                ),
                SwitchListTile(
                  activeColor: secondaryColor,
                  contentPadding: EdgeInsets.fromLTRB(80, 0, 0, 15),
                  title: Text('Notify contacts'),
                  onChanged: (bool value) {
                    setState(() {
                      _useLessDataAndCall = value;
                    });
                  },
                  value: _useLessDataAndCall,
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Media auto-download'),
                      SizedBox(height: 10),
                      Text(
                          'Voice message are always automatically dowonloaded'),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          _mediaAutoDialog('When Using mobile data');
                        },
                        title: Text("When Using mobile data"),
                        subtitle: Text('No media'),
                      ),
                      ListTile(
                        onTap: () {
                          _mediaAutoDialog('When connected on Wi-Fi');
                        },
                        title: Text("When connected on Wi-Fi"),
                        subtitle: Text('No media'),
                      ),
                      ListTile(
                        onTap: () {
                          _mediaAutoDialog('When roaming');
                        },
                        title: Text("When roaming"),
                        subtitle: Text('No media'),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.6,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Media upload quality'),
                      SizedBox(height: 10),
                      Text('Choose th quality of media file to be sent'),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          _mediaUploadDialog();
                        },
                        title: Text("Photo upload quality"),
                        subtitle: Text('Auto (recommended)'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mediaAutoDialog(String $title) {
    Map<String, bool> _mediaAutoList = {
      'Photos': false,
      'Audio': false,
      'Videos': false,
      'Documents': false,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(5),
            title: Text($title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: _mediaAutoList.keys.map((String key) {
                return CheckboxListTile(
                  activeColor: secondaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(key),
                  onChanged: (bool? value) {
                    setState(() {
                      _mediaAutoList[key] = value!;
                    });
                  },
                  value: _mediaAutoList[key],
                );
              }).toList(),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )),
            ],
          );
        });
      },
    );
  }

  void _mediaUploadDialog() {
    MediaUploadCharacter _character = MediaUploadCharacter.Auto;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            title: Text("Photo upload quality"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(23, 20, 20, 0),
                  child: Text(
                      "Best quality photos are larger and can take longer to send"),
                ),
                RadioListTile<MediaUploadCharacter>(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  title: const Text('Auto (recommended)'),
                  activeColor: secondaryColor,
                  value: MediaUploadCharacter.Auto,
                  groupValue: _character,
                  onChanged: (MediaUploadCharacter? value) {
                    setState(() {
                      _character = value!;
                    });
                  },
                ),
                RadioListTile<MediaUploadCharacter>(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  title: const Text('Best quality'),
                  activeColor: secondaryColor,
                  value: MediaUploadCharacter.BestQuality,
                  groupValue: _character,
                  onChanged: (MediaUploadCharacter? value) {
                    setState(() {
                      _character = value!;
                    });
                  },
                ),
                RadioListTile<MediaUploadCharacter>(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  title: const Text('Data saver'),
                  activeColor: secondaryColor,
                  value: MediaUploadCharacter.DataSaver,
                  groupValue: _character,
                  onChanged: (MediaUploadCharacter? value) {
                    setState(() {
                      _character = value!;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: secondaryColor,
                    ),
                  )),
            ],
          );
        });
      },
    );
  }
}
