import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

/// Notification sayfası
class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen(
    this.payload,
  );

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Hello, Aziz',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have a new reminder',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: primaryClr),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  containerItems('Title', Icons.text_format),
                  const SizedBox(height: 20),
                  Text(
                    _payload.toString().split('|')[0],
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  containerItems('Description', Icons.description),
                  const SizedBox(height: 20),
                  Text(
                    _payload.toString().split('|')[1],
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  containerItems('Date', Icons.date_range),
                  const SizedBox(height: 20),
                  Text(
                    _payload.toString().split('|')[2],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Row containerItems(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        const SizedBox(width: 20),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ],
    );
  }
}
