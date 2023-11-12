import 'package:flutter/material.dart';

class CalendarScreeen extends StatefulWidget {
  const CalendarScreeen({super.key});

  @override
  State<CalendarScreeen> createState() => _CalendarScreeenState();
}

class _CalendarScreeenState extends State<CalendarScreeen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Calendar"),
    ));
  }
}
