import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../util/Navigator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  /// Variáveis de animação
  late AnimationController _iconAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _iconAnimation;
  late Animation<double> _formAnimation;

  /// Variáveis de formulário
  static final TextEditingController _email = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  String get username => _email.text;
  String get password => _pass.text;

  void doLogin(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);

      User? user = userCredential.user;

      if (user != null) {
        _pass.text = '';
        FirebaseAuthAppNavigator.goToHome(context);
      }
      print('Signed in: ${user!.uid}');
    } catch (e) {
      print('Error: ${e.toString()}');
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao realizar login'),
          backgroundColor: Colors.redAccent,
        ),
      );
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  void register(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: username, password: password);

      User? user = userCredential.user;

      if (user != null) {
        _email.text = '';
        _pass.text = '';
        FirebaseAuthAppNavigator.goToHome(context);
      }
    } catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text("Falha ao criar registro"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await _iconAnimationController.forward().orCancel;
      await _formAnimationController.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    _formAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _formAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_formAnimationController);
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);

    _iconAnimation.addListener(() => this.setState(() {}));

    _playAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _formAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Builder(
            builder: (context) => GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(new FocusNode()),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image(
                        image: new AssetImage("assets/images/guy.jpg"),
                        fit: BoxFit.cover,
                        color: Colors.black54,
                        colorBlendMode: BlendMode.darken,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //TODO: Colocar o Logo da Grippen com a animação
                            FlutterLogo(
                              size: _iconAnimation.value * 100,
                            ),
                            FadeTransition(
                              opacity: _formAnimation,
                              child: Form(
                                  child: Theme(
                                      data: ThemeData(
                                          brightness: Brightness.dark,
                                          primarySwatch: Colors.blue,
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                                  labelStyle: TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontSize: 20.0))),
                                      child: Container(
                                        padding: const EdgeInsets.all(60.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            TextFormField(
                                              controller: _email,
                                              decoration: InputDecoration(
                                                labelText: "Enter e-mail",
                                              ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            ),
                                            TextFormField(
                                              controller: _pass,
                                              decoration: InputDecoration(
                                                labelText: "Enter password",
                                              ),
                                              keyboardType: TextInputType.text,
                                              obscureText: true,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0)),
                                            MaterialButton(
                                              height: 40.0,
                                              minWidth: 100.0,
                                              color: Colors.blue[900],
                                              textColor: Colors.white70,
                                              child: new Text("Login"),
                                              onPressed: () {
                                                doLogin(context);
                                              },
                                              splashColor: Colors.blue,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                            ),
                                            MaterialButton(
                                              height: 40.0,
                                              minWidth: 100.0,
                                              color: Colors.black45,
                                              textColor: Colors.white70,
                                              child: new Text("Register"),
                                              onPressed: () {
                                                register(context);
                                              },
                                              splashColor: Colors.blue,
                                            )
                                          ],
                                        ),
                                      ))),
                            ),
                          ])
                    ],
                  ),
                )));
  }
}
