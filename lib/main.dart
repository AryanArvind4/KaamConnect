import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLogs.initLogs(
    logLevelsEnabled: [LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR, LogLevel.SEVERE],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    directoryStructure: DirectoryStructure.FOR_DATE,
    logFileExtension: LogFileExtension.LOG,
    logsWriteDirectoryName: "MyLogs",
    logsExportDirectoryName: "MyLogs/Exported",
    debugFileOperations: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    String username = _usernameController.text;
    setState(() {
      _isUsernameValid = username.contains('@') && username.contains('.');
      FlutterLogs.logInfo("KaamConnect Assignment", "UsernameValidation", "Username validation: $_isUsernameValid");
    });
  }

  void _validatePassword() {
    String password = _passwordController.text;
    bool hasMinLength = password.length >= 8 && password.length <= 50;
    bool hasUppercase = password.contains(RegExp(r'[A-Z].*[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialChar = password.contains(RegExp(r'[@#^&!~]'));
    bool noAsterisk = !password.contains('*');

    setState(() {
      _isPasswordValid = hasMinLength && hasUppercase && hasLowercase && hasSpecialChar && noAsterisk;
      FlutterLogs.logInfo("KaamConnect Assignment", "PasswordValidation", "Password validation: $_isPasswordValid");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username (email)',
                  hintText: 'Enter your email',
                  errorText: _isUsernameValid ? null : 'Enter a valid email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  errorText: _isPasswordValid ? null : 'Password must be 8-50 characters, have 2 uppercase, 1 lowercase, 1 special character, and no *',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUsernameValid && _isPasswordValid ? _register : null,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() {
    FlutterLogs.logInfo("KaamConnect Assignment", "Registration", "User registered with Username: ${_usernameController.text}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration Successful')),
    );
  }
}
