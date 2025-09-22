import 'dart:ui';

import 'package:flutter/material.dart' hide Size;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("RadioMel", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/Radio.png", fit: BoxFit.cover),
          ),
          Positioned(
            top: kToolbarHeight + 80,
            left: 10,
            right: 10,
            bottom: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    top: 50,
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "12 h 23 min 12 s",
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      
                      Text(
                        "Samedi 20 Semptembre 2025",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),

                      SizedBox(
                        height: 60,
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/images/pochette.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Text(
                        "High well to hell",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Text(
                        "Album",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Text(
                        "AC/DC",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Text(
                        "1982",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          vertical: 0,
                          horizontal: 25,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "3:10",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),

                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  inactiveTrackColor: Colors.black,
                                  activeTrackColor: Colors.white,
                                  trackHeight: 2,
                                  thumbColor: Colors.transparent,
                                  thumbShape: RoundSliderThumbShape(
                                    disabledThumbRadius: 0,
                                    enabledThumbRadius: 0,
                                  ),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 100,
                                  value: 50,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),

                            Icon(
                              Icons.arrow_right_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
