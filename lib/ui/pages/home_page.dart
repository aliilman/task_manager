import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/notification_services.dart';
import 'package:task_manager/services/theme_services.dart';
import 'package:task_manager/ui/pages/add_task_page.dart';
import 'package:task_manager/ui/theme.dart';
import 'package:task_manager/ui/widgets/button.dart';
import 'package:task_manager/ui/widgets/input_field.dart';
import 'package:task_manager/ui/widgets/task_tile.dart';

import '../size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  bool isClose = false;

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _addTaskBar(),
            const SizedBox(
              height: 11,
            ),
            _addDateBar(),
            const SizedBox(height: 6),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              'Today',
              style: headingStyle,
            )
          ]),
          MyButton(
              label: '+Add Task',
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: DateTime.now(),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        )),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        )),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      if (_taskController.tasksList.isEmpty) {
        return _noTaskMsg();
      } else {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemCount: _taskController.tasksList.length,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.tasksList[index];

                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selectedDate.day)) {
                  var hour = task.startTime.toString().split(':')[0];
                  var minutes = task.startTime.toString().split(':')[1];
                  debugPrint(' Hour : $hour');
                  debugPrint(' Minutes : $minutes');
                  // var date = DateFormat.jm().parse(task.startTime!);
                  // var myTime = DateFormat('HH:mm').format(date);

                  notifyHelper.scheduledNotification(
                      int.parse(hour),
                      int.parse(minutes),
                      // int.parse(myTime.toString().split(':')[0]),
                      // int.parse(myTime.toString().split(':')[1]),
                      task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 2000),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        );
      }
    }));
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 200),
                  SvgPicture.asset('images/task.svg',
                      color: primaryClr.withOpacity(0.5),
                      height: 90,
                      semanticsLabel: 'task'),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Text(
                      'You do not have any task yet!\nAdd new new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
          //  NotifyHelper()
          //  .displayNotification(title: 'Theme changed', body: 'Test');
          //  notifyHelper.scheduledNotification(hour, minutes, task)
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: const [
        CircleAvatar(
          radius: 19,
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        SizedBox(
          width: 30,
        )
      ],
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: 65,
          width: SizeConfig.screenWidth * 0.9,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: isClose
                      ? Get.isDarkMode
                          ? Colors.grey[600]!
                          : Colors.grey[300]!
                      : clr),
              borderRadius: BorderRadius.circular(20),
              color: isClose ? Colors.transparent : clr),
          child: Center(
              child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ))),
    );
  }

  //
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.only(top: 4),
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.3
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : Expanded(
                      child: _buildBottomSheet(
                          label: 'Görev Bitti',
                          onTap: () {
                            _taskController.markTaskCompleted(task.id!);

                            notifyHelper.cancelNotification(task);
                            Get.back();
                          },
                          clr: primaryClr),
                    ),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
              Expanded(
                child: _buildBottomSheet(
                    label: 'Görevi sil',
                    onTap: () {
                      _taskController.deleteTask(task);
                      notifyHelper.cancelNotification(task);
                      Get.back();
                    },
                    clr: primaryClr),
              ),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
              Expanded(
                child: _buildBottomSheet(
                    label: 'Iptal et',
                    onTap: () {
                      Get.back();
                    },
                    clr: primaryClr),
              ),
              const SizedBox(height: 20),
            ],
          )),
    ));
  }
}
