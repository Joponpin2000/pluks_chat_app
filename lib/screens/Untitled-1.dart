// appBar: AppBar(
//   title: Text("Chats"),
//   leading: GestureDetector(
//     onTap: () {
//       setState(() {
//         drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
//             ? FSBStatus.FSB_CLOSE
//             : FSBStatus.FSB_OPEN;
//       });
//     },
//     child: Icon(Icons.menu),
//   ),
//   centerTitle: true,
//   elevation: 0.0,
//   actions: <Widget>[
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: PopupMenuButton(
//         elevation: 3.2,
//         child: Icon(
//           Icons.more_vert,
//           color: Theme.of(context).accentColor,
//         ),
//         itemBuilder: (context) => {
//           PopupMenuItem(
//             child: Text("Settings"),
//           ),
//           PopupMenuItem(
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SearchScreen(),
//                   ),
//                 );
//               },
//               child: Text("Search"),
//             ),
//           ),
//         }.toList(),
//       ),
//     ),
//   ],
// ),
