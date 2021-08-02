import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/feedback.dart';

class FeedbackBloc extends ChangeNotifier implements BaseBloc {
  FeedbackRepository _feedbackRepository;
  StreamController _feedbackController;

  final formKey = GlobalKey<FormState>();
  final feedback = TextEditingController();
  Validator validator;

  StreamSink<Response<String>> get sink => _feedbackController.sink;

  Stream<Response<String>> get stream => _feedbackController.stream;

  FeedbackBloc() {
    _feedbackRepository = FeedbackRepository();
    _feedbackController = StreamController<Response<String>>();
    validator = Validator(feedback);
  }

  void postFeedback() async {
    if (formKey.currentState.validate()) {
      sink.add(Response.loading('Please Wait'));
      try {
        await _feedbackRepository.postFeedback(feedback.text);
        sink.add(Response.completed('Feedback Given Successfully!!!'));
      } catch (e) {
        sink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    _feedbackController?.close();
    super.dispose();
  }
}

class Validator {
  TextEditingController feedback;

  Validator(this.feedback);

  String feedbackValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter your feedback';
    }
    return null;
  }
}
