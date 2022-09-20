import 'package:flutter/material.dart';

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
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Url Shortener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Enter a URL:',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: '',
                ),
              ),
              const SizedBox(height: 20),
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          decoration: const InputDecoration(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
