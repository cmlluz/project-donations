import 'package:appdonationsgestor/components/card_item.dart';
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
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://imgs.search.brave.com/EH557LzfsHTfIMbszf0VhVSjTAxp2YIL1olc8zaL-ic/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWM2LmRlcG9zaXRw/aG90b3MuY29tLzEw/MzExNzQvNTk0L2kv/NDUwL2RlcG9zaXRw/aG90b3NfNTk0MjE0/MS1zdG9jay1waG90/by1ncm91cC1vZi1w/YXBlcmNoYWluLWhv/bGRpbmctaGFuZHMu/anBn",
                        ),
                      ),
                      title: Text("Lar dos idosos"),
                    ),
                    CardItem(),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing",
                        ),
                      ],
                    ),
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
