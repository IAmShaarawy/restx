import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class WaiterFeedback extends StatelessWidget {
  final Map data;

  WaiterFeedback(this.data);

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
              starCount: 5,
              rating: data["q1"],
              size: 40.0,
              isReadOnly: true,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          Text("How Would You Rate Our Staff’s Ability to Meet Your Needs?"),
          SmoothStarRating(
              allowHalfRating: true,
              starCount: 5,
              rating: data["q2"],
              size: 40.0,
              isReadOnly: true,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          Text("How would you rate the Speed of Service?"),
          SmoothStarRating(
              allowHalfRating: true,
              starCount: 5,
              rating: data["q3"],
              size: 40.0,
              isReadOnly: true,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          Text("How would you rate the value of our food?"),
          SmoothStarRating(
              allowHalfRating: true,
              starCount: 5,
              rating: data["q4"],
              size: 40.0,
              isReadOnly: true,
              color: Colors.amberAccent,
              borderColor: Colors.amber,
              spacing: 0.0),
          TextFormField(
            enabled: false,
            initialValue: data["extr_feedback"],
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Extra feedback",
              fillColor: Colors.teal.shade50,
              filled: true,
            ),
          ),
          RaisedButton(
            child: Text("Done"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
