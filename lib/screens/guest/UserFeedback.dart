import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class UserFeedback extends StatefulWidget {
  @override
  _UserFeedbackState createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  double q1Rating = 0.0;
  double q2Rating = 0.0;
  double q3Rating = 0.0;
  double q4Rating = 0.0;
  TextEditingController extraFeedback = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(
            "Feedback",
            style: Theme.of(context).textTheme.headline3,
          ),
          Text("How Would You Rate the Cleanliness of the Restaurant?"),
          SmoothStarRating(
              allowHalfRating: true,
              onRated: (v) {
                setState(() {
                  q1Rating = v;
                });
              },
              starCount: 5,
              rating: q1Rating,
              size: 40.0,
              isReadOnly: false,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          Text("How Would You Rate Our Staff’s Ability to Meet Your Needs?"),
          SmoothStarRating(
              allowHalfRating: true,
              onRated: (v) {
                setState(() {
                  q2Rating = v;
                });
              },
              starCount: 5,
              rating: q2Rating,
              size: 40.0,
              isReadOnly: false,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          Text("How would you rate the Speed of Service?"),
          SmoothStarRating(
              allowHalfRating: true,
              onRated: (v) {
                setState(() {
                  q3Rating = v;
                });
              },
              starCount: 5,
              rating: q3Rating,
              size: 40.0,
              isReadOnly: false,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          Text("How would you rate the value of our food?"),
          SmoothStarRating(
              allowHalfRating: true,
              onRated: (v) {
                setState(() {
                  q4Rating = v;
                });
              },
              starCount: 5,
              rating: q4Rating,
              size: 40.0,
              isReadOnly: false,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          TextFormField(
            controller: extraFeedback,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Extra feedback",
              fillColor: Colors.teal.shade50,
              filled: true,
            ),
          ),
          RaisedButton(
            child: Text("Send Feedback"),
            onPressed: () => onSendFeedback(),
          )
        ],
      ),
    );
  }

  void onSendFeedback() {
    final feedback = {
      "q1": q1Rating,
      "q2": q2Rating,
      "q3": q3Rating,
      "q4": q4Rating,
      "extr_feedback": extraFeedback.text
    };
    Navigator.pop(context, feedback);
  }
}
