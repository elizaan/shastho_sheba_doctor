import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import '../blocs/feeadback.dart';
import '../widgets/drawer.dart';
import '../networking/response.dart';
import '../widgets/loading.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.feedback),
              Text(
                'Feedback',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.feedback),
        ),
        body: SafeArea(
          child: Center(
            child: ChangeNotifierProvider(
              create: (context) => FeedbackBloc(),
              child: Builder(
                builder: (context) {
                  FeedbackBloc feedbackBloc =
                      Provider.of<FeedbackBloc>(context);
                  return StreamBuilder(
                    stream: feedbackBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<String> data = snapshot.data;
                        switch (data.status) {
                          case Status.LOADING:
                            return Loading(data.message);
                            break;
                          case Status.COMPLETED:
                            Future.delayed(
                              Duration(
                                seconds: 2,
                              ),
                              () => Navigator.pop(context),
                            );
                            return Text(
                              data.data,
                              style: M,
                            );
                            break;
                          case Status.ERROR:
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(data.message),
                                  duration: Duration(seconds: 2),
                                ),
                              ),
                            );
                            break;
                        }
                      }
                      return _FeedbackForm();
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

class _FeedbackForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FeedbackBloc feedbackBloc = Provider.of<FeedbackBloc>(context);
    return ListView(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      children: <Widget>[
        Form(
          key: feedbackBloc.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Please share your valuable thought about our service with us!!!',
                style: M.copyWith(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: feedbackBloc.feedback,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: feedbackBloc.validator.feedbackValidator,
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                color: blue,
                onPressed: feedbackBloc.postFeedback,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
