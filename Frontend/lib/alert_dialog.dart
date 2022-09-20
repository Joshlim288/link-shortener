import 'package:flutter/material.dart';
import 'package:frontend/api_connection.dart';

/// Contains logic for the dialogs shown in the application
/// Supports dialogs with and without input
/// Allows provision of the text to be displayed, and what API to call
class UrlAlertDialog extends StatefulWidget {
  const UrlAlertDialog({Key? key, required this.input, required this.apiCall}) : super(key: key);
  final String input;
  final Function apiCall;

  @override
  UrlAlertDialogState createState() => UrlAlertDialogState();
}

class UrlAlertDialogState extends State<UrlAlertDialog> {
  bool isLoading = true;
  String? responseText;
  int? responseCode;
  Widget? title, body;
  TextStyle titleStyle = const TextStyle(fontWeight: FontWeight.bold);

  void callback(String response, int statusCode) {
    setState(() {
      responseCode = statusCode;
      responseText = response;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.apiCall(widget.input, callback);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Still loading
      title = Text('Loading', style: titleStyle);
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: const [CircularProgressIndicator()],
      );
    } else {
      if (responseCode != 200) {
        // Request error
        title = Column(
          children: const [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 30,
            ),
            SizedBox(height: 5),
            Text('Request Failed'),
          ],
        );
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(responseText!)],
        );
      } else {
        // Request succeeded, display shortened url
        title = Column(
          children: const <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30,
            ),
            Text('Success'),
          ],
        );
        body = Column(
          children: [
            TextFormField(
              initialValue: responseText,
              readOnly: true,
              maxLines: 1,
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Copy to clipboard'))
          ],
        );
      }
    }
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Center(child: title),
      content: body,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
