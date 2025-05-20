import 'package:appdonationsgestor/components/card_item.dart';
import 'package:appdonationsgestor/resources/constant_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://imgs.search.brave.com/EH557LzfsHTfIMbszf0VhVSjTAxp2YIL1olc8zaL-ic/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWM2LmRlcG9zaXRw/aG90b3MuY29tLzEw/MzExNzQvNTk0L2kv/NDUwL2RlcG9zaXRw/aG90b3NfNTk0MjE0/MS1zdG9jay1waG90/by1ncm91cC1vZi1w/YXBlcmNoYWluLWhv/bGRpbmctaGFuZHMu/anBn",
                          ),
                        ),
                        title: Text(
                          "Lar dos idosos",
                          style: TextStyle(
                            color: ConstantsColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    CardItem(),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing",
                              style: TextStyle(
                                color: ConstantsColors.lightGray,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
