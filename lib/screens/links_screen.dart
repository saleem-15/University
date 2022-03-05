import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/link.dart';
import '../models/subject.dart';

class LinksScreen extends StatefulWidget {
  final Subject subject;
  const LinksScreen({required this.subject, Key? key}) : super(key: key);

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Links')),
      body: SizedBox(
        height: 300,
        child: ListView(
          children: widget.subject.links.map((e) {
            return Card(
              margin: const EdgeInsets.only(top: 20),
              // elevation: Themes.lightTheme.cardTheme.elevation,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  title: Text(
                    e.description,
                    style: const TextStyle(fontSize: 22),
                  ),
                  trailing: IconButton(
                    onPressed: () => showDeleteLink(context, e),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.orange,
                    ),
                  ),
                  onTap: () {
                    _launchURL(e.url);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch Url';
  }

  void showDeleteLink(BuildContext ctx, Link link) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are You sure you want to delete this link'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      widget.subject.deleteLink(link);
                    });

                    // when pressing delete  =>
                    // remove (Delete Confirmation) dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete')),
            ],
          );
        });
  }
}
