import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  List<Meeting> meetings;

  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFFFF3232), false));

    return meetings;
  }

  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<CoolStep> steps = [
      CoolStep(
        title: "Enter Your Name",
        subtitle: "Please Enter Your Name to Get Started",
        content: Form(
            key: _formKey1,
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Enter Your Name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
            )),
        validation: () {
          if (!_formKey1.currentState.validate()) {
            return "Fill form correctly";
          }
          return null;
        },
      ),
      CoolStep(
          title: "Select A Time Slot",
          subtitle: "Please Fill the Details To Add Event",
          content: SfCalendar(
            view: CalendarView.timelineMonth,
            dataSource: MeetingDataSource(_getDataSource()),
            // by default the month appointment display mode set as Indicator, we can
            // change the display mode as appointment using the appointment display
            // mode property
            monthViewSettings: MonthViewSettings(
                showAgenda: true,
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
          ),
          validation: null),
    ];

    final stepper = CoolStepper(
      onCompleted: () {},
      steps: steps,
      config: CoolStepperConfig(
        headerColor: Color.fromRGBO(255, 222, 21, 1),
        backText: "PREV",
        nextText: "NEXT",
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        title: Text(
          'Add Event',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(child: stepper),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
