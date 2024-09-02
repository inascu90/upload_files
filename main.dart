// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io' as io;
// import 'package:path/path.dart' as path;
// import 'package:flutter/foundation.dart' show kIsWeb;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: VideoUploadPage(),
//     );
//   }
// }

// class VideoUploadPage extends StatefulWidget {
//   @override
//   _VideoUploadPageState createState() => _VideoUploadPageState();
// }

// class _VideoUploadPageState extends State<VideoUploadPage> {
//   PlatformFile? _selectedFile;

//   Future<void> _pickVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.first;
//       });
//     }
//   }


// Future<void> _uploadVideo() async {
//   if (_selectedFile == null) return;

//   String uploadUrl = 'http://100.125.217.38:5000/upload';  // Use your Flask server's IP address

//   try {
//     var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

//     if (kIsWeb) {
//       // For web, use bytes instead of path
//       Uint8List fileBytes = _selectedFile!.bytes!;
//       request.files.add(http.MultipartFile.fromBytes(
//         'video',
//         fileBytes,
//         filename: _selectedFile!.name,
//       ));
//     } else {
//       // For mobile (Android, iOS) and desktop, use the file path
//       io.File file = io.File(_selectedFile!.path!);
//       request.files.add(await http.MultipartFile.fromPath(
//         'video',
//         file.path,
//         filename: path.basename(file.path),
//       ));
//     }

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       print('Upload successful!');
//     } else {
//       print('Upload failed with status: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error occurred: $e');
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Upload Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _pickVideo,
//               child: Text('Select Video'),
//             ),
//             SizedBox(height: 20),
//             _selectedFile != null
//                 ? Text('Selected file: ${_selectedFile!.name}')
//                 : Text('No file selected.'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploadVideo,
//               child: Text('Upload Video'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      _selectedFile = video;// Store the selected video file
    });
  }

  Future<void> _uploadVideo() async {
    if (_selectedFile == null) return;

    String uploadUrl = 'http://192.168.1.20:5000/upload';  // Flask server URL

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
 
      if (kIsWeb) {
        // Web platform
        Uint8List fileBytes = await _selectedFile!.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'video',
          fileBytes,
          filename: _selectedFile!.name,
        ));
      } else {
        // Android, iOS, and desktop
        io.File file = io.File(_selectedFile!.path!);
        request.files.add(await http.MultipartFile.fromPath(
          'video',
          file.path,
          filename: path.basename(file.path),
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Upload successful!');
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Uploader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MyHomePage()));
}
