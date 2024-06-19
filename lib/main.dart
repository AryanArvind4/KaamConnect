import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

void main() async {
  // ensures flutter framework is fully initialized before starting
  WidgetsFlutterBinding.ensureInitialized();
  
  // initialize logging settings
  await FlutterLogs.initLogs(
    // specifies types of log that will be recorded
    logLevelsEnabled: [LogLevel.INFO, LogLevel.WARNING, LogLevel.ERROR, LogLevel.SEVERE],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    // directoryStructure - organizes log files by date
    directoryStructure: DirectoryStructure.FOR_DATE,
    logFileExtension: LogFileExtension.LOG,
    logsWriteDirectoryName: "MyLogs",
    logsExportDirectoryName: "MyLogs/Exported",
    debugFileOperations: true,
  );
  
  // run the app
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
      debugShowCheckedModeBanner: false, // removes the debug banner
    );
  }
}

// manages the state of registration page
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // allows us to submit or reset the form
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // track validity of password and username
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    
    // call validator function when username or password is changed
    _usernameController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
  }

  // used to ensure memory management
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    // retrieve the username
    String username = _usernameController.text;
    setState(() {
      // check if the username is valid
      _isUsernameValid = username.contains('@') && username.contains('.');
      FlutterLogs.logInfo("KaamConnect Assignment", "UsernameValidation", "Username validation: $_isUsernameValid");
    });
  }

  void _validatePassword() {
    // retrieve the password
    String password = _passwordController.text;
    
    // check the conditions for validation of the password
    bool hasMinLength = password.length >= 8 && password.length <= 50;
    bool hasUppercase = password.contains(RegExp(r'[A-Z].*[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialChar = password.contains(RegExp(r'[@#^&!~]'));
    bool noAsterisk = !password.contains('*');

    setState(() {
      // update the validity of the password
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
              // username input field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username (email)',
                  hintText: 'Enter your email',
                  errorText: _isUsernameValid ? null : 'Enter a valid email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              // password input field
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
              
              // register button
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
    // log the registration event
    FlutterLogs.logInfo("KaamConnect Assignment", "Registration", "User registered with Username: ${_usernameController.text}");
    
    // show a snackbar displaying the registration success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration Successful')),
    );
  }
}
