// import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:video_editor_git/Emojis/emoji.dart';
import 'package:video_editor_git/Emojis/emojiList.dart';
import 'package:video_editor_git/Screen/topioca.dart';
import 'package:video_editor_git/Screen/trimmerView.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
// import 'package:flutter/rendering.dart' as render;
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Trimmer")),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: ElevatedButton(
                child: Text("LOAD VIDEO"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.video,
                    allowCompression: false,
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return TrimmerView(file);
                      }),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            // Container(
            //   child: ElevatedButton(
            //       child: Text("LOAD EMOJI"),
            //       onPressed: () async {
            //
            //       }
            //
            //   ),
            // ),
            // SizedBox(height: 10),



            // Container(
            //   child: ElevatedButton(
            //     child: Text("Whatsapp Sticker"),
            //     onPressed: ()  {
            //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyStickerHomePage()));
            //     },
            //   ),
            // ),
            // EmojiPicker(
            //   rows: 3,
            //   columns: 7,
            //   buttonMode: ButtonMode.MATERIAL,
            //   recommendKeywords: ["racing", "horse"],
            //   numRecommended: 10,
            //   onEmojiSelected: (emoji, category) {
            //     print('emoji : '+emoji.toString());
            //     print('category : '+category.toString());
            //     },
            //   )

    // Container(
            //   child: ElevatedButton(
            //     child: Text("LOAD VIDEO"),
            //     onPressed: () async {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) {
            //           return CanvasPainting();
            //         }),
            //       );
            //     },
            //   ),
            // ),
            // MyTopiocaApp()
          ],
        ),
      ),
    );
  }
}


//void main() => runApp(CanvasPainting());
