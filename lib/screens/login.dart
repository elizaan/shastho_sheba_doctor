import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import '../routes.dart';
import '../blocs/login.dart';
import '../networking/response.dart';
import '../widgets/loading.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context).settings.arguments;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Text('Login'),
        ),
        body: SafeArea(
          child: Center(
            child: ChangeNotifierProvider(
              create: (context) => LoginBloc(),
              child: Builder(
                builder: (context) {
                  LoginBloc loginBloc = Provider.of<LoginBloc>(context);
                  if (message != null) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          duration: Duration(seconds: 2),
                        ),
                      ),
                    );
                  }
                  return StreamBuilder(
                    stream: loginBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<String> data = snapshot.data;
                        switch (data.status) {
                          case Status.LOADING:
                            return Loading(data.message);
                          case Status.COMPLETED:
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => Navigator.pushReplacementNamed(
                                  context, homeScreen),
                            );
                            break;
                          case Status.ERROR:
                            loginBloc.errorMessage = data.message;
                            break;
                        }
                      }
                      return _LoginForm();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = Provider.of<LoginBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: loginBloc.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: SizedBox()),
            TextFormField(
              controller: loginBloc.mobileNo,
              decoration: InputDecoration(
                labelText: 'Mobile No.',
                icon: Icon(Icons.phone_android),
                errorText: loginBloc.errorMessage,
              ),
            ),
            TextFormField(
              controller: loginBloc.pass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    loginBloc.login();
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  color: blue,
                  label: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Don\'t have an account?'),
                  SizedBox(
                    width: 5,
                  ),
                  FlatButton(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: blue,
                    onPressed: () {
                      Navigator.pushNamed(context, registScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
