// import 'package:socket_io_client/socket_io_client.dart';
// import 'package:flutter/material.dart';

// class SocketPage extends StatefulWidget {
//   const SocketPage({Key key}) : super(key: key);

//   @override
//   State<SocketPage> createState() => _SocketPageState();
// }

// class _SocketPageState extends State<SocketPage> {
//   Socket socket; //initalize the Socket.IO Client Object
//   TextEditingController textEditingController;
//   @override
//   void initState() {
//     print("socket getting initialised");
//     initializeSocket();
//     super
//         .initState(); //--> call the initializeSocket method in the initState of our app.
//   }

//   @override
//   void dispose() {
//     socket
//         .disconnect(); // --> disconnects the Socket.IO client once the screen is disposed
//     super.dispose();
//   }

//   void sendDataToSocket() {
//     socket.emit(
//       "message",
//       {
//         "id": socket.id,
//         "message": 'Testing message', //--> message to be sent
//         "username": 'TupAc',
//         "sentAt": DateTime.now().toLocal().toString().substring(0, 16),
//       },
//     );
//   }

//   void initializeSocket() {
//     socket = io("http://127.0.0.1:3000/", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//     });
//     socket.connect(); //connect the Socket.IO Client to the Server

//     //SOCKET EVENTS
//     // --> listening for connection
//     socket.on('connect', (data) {
//       print(socket.connected);
//     });

//     //listen for incoming messages from the Server.
//     socket.on('message', (data) {
//       print(data); //
//     });
//     socket.emit('hello', {});
//     //listens when the client is disconnected from the Server
//     socket.on('disconnect', (data) {
//       print('disconnect');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Socket Test Page')),
//       body: Container(
//         child: Center(
//             child: TextField(
//           controller: textEditingController,
//         )),
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.send),
//           onPressed: () {
//             print("clicked on socket!!!!");
//             sendDataToSocket();
//           }),
//     );
//   }
// }
