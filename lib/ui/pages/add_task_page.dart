import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/ui/theme.dart';
import 'package:task_manager/ui/widgets/button.dart';
import 'package:task_manager/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController? _titleController = TextEditingController();
  final TextEditingController? _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 10)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';

  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _seleectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add Task', style: headingStyle),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter Note here',
                controller: _noteController,
              ),
              InputField(
                onTap: _getDateFromUser,
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getTimeFormUser(isStartedTime: true);
                      },
                      child: InputField(
                        onTap: () => getTimeFormUser(isStartedTime: true),
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            getTimeFormUser(isStartedTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getTimeFormUser(isStartedTime: false);
                      },
                      child: InputField(
                        onTap: () => getTimeFormUser(isStartedTime: false),
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            getTimeFormUser(isStartedTime: false);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //
              InputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes early',
                  widget: DropdownButton(
                    borderRadius: BorderRadius.circular(11),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: remindList.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text('$value'),
                      );
                    }).toList(),
                    underline: const SizedBox(height: 0),
                    elevation: 4,
                  )),
              InputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    borderRadius: BorderRadius.circular(11),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRepeat = newValue.toString();
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: repeatList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    underline: const SizedBox(height: 0),
                    elevation: 4,
                  )),
              const SizedBox(height: 20),
              Row(children: [
                _colorPalette(),
                const Spacer(),
                MyButton(
                  label: 'Create Task',
                  onTap: () async {
                    _validateDate();
                  },
                ),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Appbar Widget burası
  _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
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

  /// Görev detaylarını kontrol etmek için
  _validateDate() {
    if (_titleController!.text.isNotEmpty && _noteController!.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController!.text.isEmpty ||
        _noteController!.text.isEmpty) {
      Get.snackbar('Required', 'All field are required!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      return print('###### SOMETHING WRONG #######');
    }
  }

// Görevi veritabana ekleme metodu
  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
      title: _titleController!.text,
      note: _noteController!.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _seleectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print('$value');
  }

  // Color i seçmek için
  Column _colorPalette() {
    return Column(
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _seleectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  child: _seleectedColor == index
                      ? const Icon(Icons.done, size: 16, color: Colors.white)
                      : null,
                  radius: 21,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

// tarih seçici
  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2030));

    if (_pickedDate != null)
      setState(() {
        _selectedDate = _pickedDate;
      });
    else {
      print('Time cancled or something wrong');
    }
  }

// saat seçici
  getTimeFormUser({required bool isStartedTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartedTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    String _formattedTime = _pickedTime!.format(context);

    if (isStartedTime) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (!isStartedTime) {
      setState(() {
        _endTime = _formattedTime;
      });
    } else {
      print('Time cancled or something wrong');
    }
  }
}
