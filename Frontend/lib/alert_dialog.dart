import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  /// Variables used for tracking progress of the request, and what to display for each outcome
  bool isLoading = true;
  String? responseText;
  int? responseCode;
  Widget? title, body;
  TextStyle titleStyle = const TextStyle(fontWeight: FontWeight.bold);
  String frontendUrl = (const String.fromEnvironment('FRONTEND_URL')).length != 0 ? const String.fromEnvironment('FRONTEND_URL') : "http://localhost:8080/";

  /// Callback function passed to the request, will be called with the retrieved when request is complete
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
      /// Still loading
      title = Text('Loading', style: titleStyle);
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: const [CircularProgressIndicator()],
      );
    } else {
      if (responseCode != 200) {
        /// Request error
        title = Column(
          children: const [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(height: 5),
            Text('Request Failed'),
          ],
        );
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(responseText!)],
        );
      } else {
        /// Request succeeded, display shortened url
        responseText = '$frontendUrl#/${responseText!}';
        title = Column(
          children: const <Widget>[
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            Text('Success'),
          ],
        );
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              initialValue: responseText,
              readOnly: true,
              maxLines: 1,
            ),
          ],
        );
      }
    }

    /// Skeleton for the alert dialog, defines the overall structure
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Center(child: title),
      content: body,
      actions: <Widget>[
        if (responseCode == 200)
          TextButton(
            onPressed: () {
              setState(() {
                Clipboard.setData(ClipboardData(text: responseText));
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Icon(Icons.copy),
                  SizedBox(width: 10),
                  Text('Copy to Clipboard', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
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
