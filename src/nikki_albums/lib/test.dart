// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(const App());
//
// class App extends StatelessWidget {
//   const App({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'LAN Transfer',
//       theme: ThemeData(useMaterial3: true),
//       home: const HomePage(),
//     );
//   }
// }
//
// /* ==========================================================
//    1. 设备发现：UDP 组播 + 广播
//    ========================================================== */
// class Discovery {
//   static const int _port = 4545;
//   static final InternetAddress _group =
//   InternetAddress('224.0.0.251'); // mDNS 地址
//   RawDatagramSocket? _socket;
//   final void Function(String ip, String name) onDevice;
//   Discovery(this.onDevice);
//
//   Future<void> start({String myName = 'unknown'}) async {
//     _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _port);
//     _socket!.joinMulticast(_group);
//     _socket!.broadcastEnabled = true;
//     _socket!.listen((event) {
//       if (event == RawSocketEvent.read) {
//         final dg = _socket!.receive();
//         if (dg == null) return;
//         final str = utf8.decode(dg.data);
//         if (str.startsWith('IAM|')) {
//           final ip = dg.address.address;
//           final name = str.split('|')[1];
//           onDevice(ip, name);
//         }
//       }
//     });
//
//     // 每 1 秒广播一次
//     while (true) {
//       final data = utf8.encode('IAM|$myName');
//       _socket!.send(data, _group, _port);
//       // 再向每个网段广播一次
//       for (final addr in await _localAddress()) {
//         final list = addr.split('.')..removeLast();
//         final broad = '${list.join('.')}.255';
//         _socket!.send(data, InternetAddress(broad), _port);
//       }
//       await Future.delayed(const Duration(seconds: 1));
//     }
//   }
//
//   void stop() => _socket?.close();
//
//   static Future<List<String>> _localAddress() async =>
//       (await NetworkInterface.list(
//           includeLoopback: false, type: InternetAddressType.IPv4))
//           .expand((i) => i.addresses)
//           .map((a) => a.address)
//           .toList();
// }
//
// /* ==========================================================
//    2. 文件传输：TCP + 分块
//    ========================================================== */
// class FileSender {
//   final String host;
//   final int port;
//   final void Function(int, int) onProgress;
//   FileSender(this.host, this.port, this.onProgress);
//
//   Future<void> send(File file) async {
//     final socket = await Socket.connect(host, port);
//     final size = file.lengthSync();
//     final name = file.uri.pathSegments.last;
//     // 头：文件名长度(4B) + 文件名 + 文件长度(8B)
//     final nameBytes = utf8.encode(name);
//     final header = BytesBuilder()
//       ..addByte((nameBytes.length >> 8) & 0xFF)
//       ..addByte(nameBytes.length & 0xFF)
//       ..add(nameBytes)
//       ..add(_u64(size));
//     socket.add(header.toBytes());
//
//     int sent = 0;
//     await for (final chunk in file.openRead(0, size)) {
//       socket.add(chunk);
//       sent += chunk.length;
//       onProgress(sent, size);
//     }
//     await socket.flush();
//     await socket.close();
//   }
//
//   Uint8List _u64(int v) =>
//       Uint8List(8)..buffer.asByteData().setUint64(0, v, Endian.big);
// }
//
// class FileReceiver {
//   final int port;
//   final void Function(int, int) onProgress;
//   FileReceiver(this.port, this.onProgress);
//
//   Future<void> start() async {
//     final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
//     await for (final socket in server) {
//       _handle(socket);
//       // 只接受一个连接，后续可扩展
//       break;
//     }
//   }
//
//   Future<void> _handle(Socket socket) async {
//     final reader = socket.cast<Uint8List>();
//     await for (final data in reader) {
//       _buffer.addAll(data);
//       if (_name == null && _buffer.length > 2) _parseHeader();
//       if (_name != null && _total != null && _file == null) _createFile();
//       if (_file != null) {
//         final need = _total! - _got;
//         final avail = _buffer.length;
//         final take = min(need, avail);
//         final chunk = _buffer.sublist(0, take);
//         _buffer = _buffer.sublist(take);
//         _file!.writeAsBytesSync(chunk, mode: FileMode.append);
//         _got += take;
//         onProgress(_got, _total!);
//         if (_got == _total!) {
//           _file = null;
//           socket.close();
//           break;
//         }
//       }
//     }
//   }
//
//   /* ---------- 内部状态 ---------- */
//   late var _buffer = <int>[];
//   String? _name;
//   int? _total;
//   int _got = 0;
//   File? _file;
//
//   void _parseHeader() {
//     final bb = ByteData.sublistView(Uint8List.fromList(_buffer));
//     final nameLen = bb.getUint16(0, Endian.big);
//     if (_buffer.length < 2 + nameLen + 8) return; // 不够继续等
//     _name = utf8.decode(_buffer.sublist(2, 2 + nameLen));
//     _total = bb.getUint64(2 + nameLen, Endian.big);
//     _buffer.removeRange(0, 2 + nameLen + 8);
//   }
//
//   void _createFile() {
//     final dir = Directory.systemTemp.createTempSync('lan_recv_');
//     _file = File('${dir.path}/$_name');
//     _got = 0;
//   }
// }
//
// /* ==========================================================
//    3. UI 层
//    ========================================================== */
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final devices = <String, String>{}; // ip -> name
//   Discovery? _discovery;
//   String? _selectedIp;
//   int _role = 0; // 0 未选  1 发送  2 接收
//   int _sent = 0, _total = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDiscovery();
//   }
//
//   void _startDiscovery() {
//     _discovery = Discovery((ip, name) => setState(() => devices[ip] = name));
//     _discovery!.start(myName: 'Flutter_${Random().nextInt(100)}');
//   }
//
//   @override
//   void dispose() {
//     _discovery?.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('局域网文件传输')),
//       body: Column(
//         children: [
//           const Padding(
//               padding: EdgeInsets.all(12),
//               child: Text('1. 先让两台设备运行本App；\n'
//                   '2. 下方会列出同一局域网内的设备；\n'
//                   '3. 选择角色后即可发送或接收文件。')),
//           Expanded(
//             child: ListView(
//               children: devices.entries
//                   .map((e) => RadioListTile<String>(
//                 value: e.key,
//                 groupValue: _selectedIp,
//                 onChanged: (v) => setState(() => _selectedIp = v),
//                 title: Text('${e.value}  (${e.key})'),
//               ))
//                   .toList(),
//             ),
//           ),
//           if (_selectedIp != null) ...[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                     onPressed: () => _role == 0 ? _setRole(1) : null,
//                     child: const Text('发送文件')),
//                 ElevatedButton(
//                     onPressed: () => _role == 0 ? _setRole(2) : null,
//                     child: const Text('接收文件')),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//           if (_role == 1)
//             ElevatedButton(
//                 onPressed: _pickAndSend, child: const Text('选择文件并发送')),
//           if (_role == 2 && _total == 0)
//             const CircularProgressIndicator()
//           else if (_total > 0)
//             LinearProgressIndicator(value: _sent / _total),
//           Text('$_sent / $_total')
//         ],
//       ),
//     );
//   }
//
//   void _setRole(int r) => setState(() => _role = r);
//
//   Future<void> _pickAndSend() async {
//     // 简单起见，这里用系统文件选择器
//     final result = await showDialog<File>(
//         context: context,
//         builder: (_) => const FilePickerDialog());
//     if (result == null) return;
//     setState(() {
//       _total = result.lengthSync();
//       _sent = 0;
//     });
//     // 端口固定 5454
//     FileSender(_selectedIp!, 5454, (s, t) => setState(() {
//       _sent = s;
//       _total = t;
//     })).send(result);
//   }
// }
//
// /* 简易文件选择弹窗（仅桌面端可用） */
// class FilePickerDialog extends StatelessWidget {
//   const FilePickerDialog({super.key});
//   @override
//   Widget build(BuildContext context) {
//     late Directory dir;
//     if(Platform.isAndroid){
//       dir = Directory('/storage/emulated/0');
//     }else if(Platform.isWindows){
//       dir = Directory(r'C:\');
//     }
//
//
//     return AlertDialog(
//       title: const Text('选择文件'),
//       content: SizedBox(
//         width: 300,
//         height: 300,
//         child: ListView(
//           children: dir
//               .listSync()
//               .whereType<File>()
//               .map((f) => ListTile(
//             title: Text(f.path.split('/').last),
//             onTap: () => Navigator.pop(context, f),
//           ))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }