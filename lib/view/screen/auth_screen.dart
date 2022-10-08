import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/http_exception.dart';
import '../../provider/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 1]),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 8),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.deepOrange.shade300,
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 8,
                                offset: Offset(0, 2),
                                color: Colors.black38),
                          ]),
                      child: Text(
                        "My Shop",
                        style: TextStyle(
                            color: Theme.of(context)
                                .accentTextTheme
                                .headline6!
                                .color,
                            fontFamily: 'Anton',
                            fontSize: 50),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: const AuthCard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { login, signUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _form = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authMap = {
    'email': '',
    'password': '',
  };
    bool _isLoading = false;
  final passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.15), end: const Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 3000),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains("@")) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authMap['email'] = val!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authMap['password'] = val!;
                  },
                ),
                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.signUp ? 120 : 0),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signUp,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        obscureText: true,
                        validator: _authMode == AuthMode.signUp
                            ? (val) {
                                if (val != passwordController.text) {
                                  return 'Password does not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading) CircularProgressIndicator(),
                RaisedButton(
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  color: Theme.of(context).primaryColor,
                  textColor:
                      Theme.of(context).primaryTextTheme.headline6!.color,
                  child: Text(_authMode == AuthMode.login ? "Login" : "SingUp"),
                ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                      '${_authMode == AuthMode.login ? "SignUp" : "Login"} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _switchAuthMode() {
    if(_authMode==AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });

      _controller.forward();
    }

      else{
        setState(() {
          _authMode = AuthMode.login;

        });
        _controller.reverse();
      }

  }

  Future<void> _submit() async{
    if(!_form.currentState!.validate()){
      return;
    }
    FocusScope.of(context).unfocus();
    _form.currentState!.save();

      setState(() {
        _isLoading=true;
      });

    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false).login(
            _authMap['email'] as String, _authMap['password'] as String);
      }
      else {
        await Provider.of<Auth>(context, listen: false).signUp(
            _authMap['email'] as String, _authMap['password'] as String);
      }
    }
    on HttpException catch(error){
      var errorMessage ='Authentication Failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage='This email address  is already in use';
      }
      else if(error.toString().contains('INVALID_EMAIL')){
        errorMessage='This is not a valid email';
      }
      else if(error.toString().contains('WEAK_PASSWORD')){
        errorMessage='This Password is too weak';
      }

      else if(error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage='Could not find a user with that email';
      }
      else if(error.toString().contains('INVALID_PASSWORD')){
        errorMessage='Invalid Password';
      }
      _showErrorDialog(errorMessage);

      }
    catch(error){
      const errorMessage ='Could not authenticate you, Please try again';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading=false;
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(context: context,
        builder: (ctx)=>AlertDialog(
          title: const Text("An Error Occurred"),
          content: Text(errorMessage),
          actions: [
            FlatButton(
                onPressed: ()=>Navigator.of(ctx).pop(), child: const Text("Okey"))
          ],
        ),
    );
  }

}
