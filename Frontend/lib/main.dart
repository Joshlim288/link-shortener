import 'package:flutter/material.dart';
import 'package:frontend/alert_dialog.dart';
import 'package:frontend/api_connection.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

/// Entry point of the application, defines the home page
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GovTech Url Shortener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        List<String> pathComponents = settings.name!.split('/');
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const MyHomePage(
                title: 'Url Shortener',
              ),
            );
            break;
          default:
            return MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: 'Url Shortener',
                code: pathComponents.last,
              ),
            );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.code}) : super(key: key);
  final String title;
  final String? code;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.code != null) {
      ApiConnection.retrieveUrl(widget.code!, (response, statusCode) async {
        if (statusCode == 200) {
          final Uri url = Uri.parse(response);
          if (!await launchUrl(url)) {
            throw 'Could not launch $url';
          }
          if (!mounted) return;
          Navigator.of(context).pop();
        }
      });
    }
  }

  void submitData() async {
    showDialog(
      context: context,
      builder: (context) => UrlAlertDialog(
        input: inputController.text,
        apiCall: ApiConnection.shortenUrl,
      ),
    );
  }

  Widget urlInputBar() {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Form(
              key: formKey,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  submitData();
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'e.g. http://www.google.com',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: inputController,
                maxLines: 1,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: submitData,
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Get Shortened URL',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset(
              'assets/background.jpg',
            ),
          ),
        ),
        const Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            color: Colors.black54,
            child: SizedBox(width: 1250, height: 400),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'URL SHORTENER',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  'Enter a URL:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                urlInputBar(),
                const SizedBox(height: 20),
                submitButton(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
