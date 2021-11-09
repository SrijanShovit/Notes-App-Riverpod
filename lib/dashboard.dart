import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app_riverpod/providers/notes_provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late FocusNode txtFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtFocusNode.dispose();
  }

  final formKey = GlobalKey<FormState>();

  final notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes app"),
      ),
      body: Center(
        child: Column(
          children: [
            Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      controller: notesCtrl,
                      focusNode: txtFocusNode,
                    ),
                    MaterialButton(
                      onPressed: () {
                        //to trigger validating of form
                        if (formKey.currentState!.validate()) {
                          context
                              .read(notesProvider)
                              .onSaveNote(notesCtrl.text);
                          formKey.currentState!.save();

                          //clear input once button is pressed
                          notesCtrl.clear();
                          //remove keyboard on pressing button
                          txtFocusNode.unfocus();
                          //reset state of form
                          formKey.currentState!.reset();

                          //show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Note added"),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.green),
                          );
                        }
                      },
                      child: Text("Submit"),
                      color: Colors.blue[600],
                    )
                  ],
                )),
            NotesListView()
          ],
        ),
      ),
    );
  }
}

//consumer widget is from riverPod
//on wrapping with consumer widgets also all provider values are directly accessible
class NotesListView extends ConsumerWidget {
  const NotesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //watch will look at all events or changes occuring in the provider and react
    final notesWatcher = watch(notesProvider);

    return Expanded(
      child: ListView.builder(
          itemCount: notesWatcher.notesList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(notesWatcher.notesList[index].toString()),
                trailing: GestureDetector(
                    onTap: () {
                      context.read(notesProvider).onDeleteNote(index);
                      //show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Note deleted"),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red),
                      );
                    },
                    child: Icon(Icons.delete)),
              ),
            );
          }),
    );
  }
}
