import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterMidi flutterMidi=FlutterMidi();
  var path ='assets/guitars.sf2';

  @override
  void initState() {
    load(path);
    super.initState();
  }
  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    flutterMidi.prepare(sf2: _byte,/*name:path.replaceAll('asset/','')*/);//when the path is not assets we can change it thisway
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Multi Piano",),
          leading: TextButton(onPressed: () async{
            await FlutterEmailSender.send(email);
          }, child:Icon(Icons.mail),),
          actions: [
            DropdownButton<String>(
              value: path ?? "assets/guitars.sf2",
              onChanged: (String? value) {
                setState(() {
                  path = value!;
                }
                );
              },
              items: [
                DropdownMenuItem(child: Text('paino'), value: path,),
                DropdownMenuItem(child: Text('quiter'), value: 'assets/piano.sf2',),
              ],
            ),
          ],
        ),
        body: InteractivePiano(
          keyWidth: 60,
          noteRange: NoteRange.forClefs([Clef.Bass, Clef.Alto, Clef.Treble]),
          onNotePositionTapped: (position) {
             flutterMidi.playMidiNote(midi:position.pitch);
          },
        ));
  }
  final Email email = Email(
    body: 'Email body',
    subject: 'Email subject',
    recipients: ['talataya144@gmail.com'],
    attachmentPaths: ['/path/to/attachment.zip'],
    isHTML: false,
  );
}
