import 'package:flutter/material.dart';

import '../models/card_info.model.dart';

class ListScreen extends StatelessWidget {
  final List<CardInfo> cardList;

  static const routeName = 'list-screen';

  const ListScreen({
    required this.cardList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // pinned content
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.teal,
                  Color.fromARGB(255, 255, 0, 191),
                ],
              ),
            ),
            child: Stack(
              children: [
                // menu button
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                // app logo
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // car icon
                      Icon(
                        Icons.directions_car,
                        size: 100,
                        color: Colors.white,
                      ),
                      // m-Vahan text
                      Text(
                        'm-Vahan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // v(s) text
                      Text(
                        'v(s) 1.3.8',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // list
          Expanded(
            child: ListView(
              children: [
                for (final info in cardList)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      title: Text(
                        info.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: info.image,
                      onTap: () {
                        Navigator.of(context).pushNamed(info.routeName);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
