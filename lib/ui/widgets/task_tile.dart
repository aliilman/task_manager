import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/ui/size_config.dart';

import '../theme.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
        width: SizeConfig.orientation == Orientation.landscape
            ? SizeConfig.screenWidth / 2
            : SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGClr(task.color)),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: Colors.grey[200], size: 18),
                        const SizedBox(width: 12),
                        Text('${task.startTime} - ${task.endTime}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.grey[100]!,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      task.note!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.grey[100]!,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
            Container(
              margin: const EdgeInsets.all(10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(task.isCompleted == 0 ? 'TODO' : 'COMPLETED',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
