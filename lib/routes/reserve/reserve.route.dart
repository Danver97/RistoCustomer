
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prova/api/reserve.api.dart';
import 'package:prova/models/reservation.dart';
import 'package:prova/routes/reserve/calendar.widget.dart';
import 'package:prova/routes/reserve/hourpicker.widget.dart';
import 'package:prova/routes/reserve/peoplePicker.widget.dart';
import 'package:prova/routes/restaurant_details/timetables/timetables.dart';

class ReserveRoute extends StatelessWidget {
  static String routeName = '/restaurant/reserve';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve'),
      ),
      body: ReservationBody(),
    );
  }

}

enum ReservationRequestResult {
  success,
  noAvailability,
  error,
}

class ReservationBody extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ReservationBodyState();

}

class ReservationBodyState extends State<ReservationBody> {
  ReservationRequestResult result;
  Reservation reservation;

  WeekTimetable _getTimetable(BuildContext context) {
    return ModalRoute.of(context).settings.arguments;
  }

  _onReservationComplete(Reservation reservation) async {
    var response = await ReserveApi.makeReservation(reservation);
      setState(() {
        this.reservation = reservation;
        if (response.statusCode == 200)
          result = ReservationRequestResult.success;
        else if (response.statusCode == 409)
          result = ReservationRequestResult.noAvailability;
        else
          result = ReservationRequestResult.error;
      });
  }

  @override
  Widget build(BuildContext context) {
    var timetable = _getTimetable(context);
    return result == null
        ? ReservationForm(timetable: timetable, onReservationCompleted: _onReservationComplete)
        : ReservationRequestResultWidget(result: result, reservation: reservation,);
  }
}


class ReservationRequestResultWidget extends StatelessWidget {
  final ReservationRequestResult result;
  final Reservation reservation;

  ReservationRequestResultWidget({@required this.result, this.reservation}) {
    if (this.result == ReservationRequestResult.success && this.reservation == null)
      throw new ArgumentError("'reservation' can't be null if 'result' equals 'ReservationRequestResult.success'");
  }

  Icon _icon() {
    double size = 64;
    Color color = Colors.white;
    switch(result) {
      case ReservationRequestResult.success:
        return Icon(Icons.done, size: size, color: color,);
      case ReservationRequestResult.noAvailability:
        return Icon(Icons.warning, size: size, color: color,);
      case ReservationRequestResult.error:
        return Icon(Icons.close, size: size, color: color,);
    }
    return null;
  }

  Color _backgroundColor() {
    switch(result) {
      case ReservationRequestResult.success:
        return Colors.green;
      case ReservationRequestResult.noAvailability:
        return Color(0xFFF8C600);
      case ReservationRequestResult.error:
        return Colors.red;
    }
    return null;
  }

  String _text(BuildContext context) {
    switch(result) {
      case ReservationRequestResult.success:
        var dateFormat = DateFormat('dd/MM/yyyy');
        var dateText = dateFormat.format(reservation.day);
        var timeText = reservation.time.format(context);
        return '${reservation.peopleNumber} People · $dateText · $timeText';
      case ReservationRequestResult.noAvailability:
        return 'Oh no! Seems that all tables are full!\nPlease retry to reserve on another day or\non the same day but another hour.';
      case ReservationRequestResult.error:
        return 'Oh no! Something went wrong. Please retry.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(32),
                decoration: ShapeDecoration(
                  color: _backgroundColor(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10000))),
                ),
                child: _icon(),
              ),
              Padding(padding: EdgeInsets.only(top: 20),),
              Text(_text(context), textAlign: TextAlign.center,),
            ],
          ),
        ],
      ),
    );
  }

}


class ReservationForm extends StatefulWidget {
  final WeekTimetable timetable;
  final Function onReservationCompleted;

  ReservationForm({@required this.timetable, this.onReservationCompleted});

  @override
  State<StatefulWidget> createState() => ReservationFormState();

}

class ReservationFormState extends State<ReservationForm> {
  // Reservation state
  int peoplePicked;
  DateTime dayPicked;
  TimeOfDay timePicked;

  // Step state
  int peopleStepIndex = 0;
  int dateStepIndex = 1;
  int timeStepIndex = 2;
  
  int stepEnabler = 0;
  int stepIndex = 0;
  bool completed = false;
  List<Step> steps;

  bool isStepEnabled(int stepIndex) {
    return stepEnabler >= stepIndex;
  }


  Step _stepPeople() {
    return Step(
      title: Text('People'),
      subtitle: peoplePicked != null ? Text('$peoplePicked') : null,
      isActive: isStepEnabled(peopleStepIndex),
      content: PeoplePicker(initialPeopleSelected: peoplePicked, onPeopleSelected: _onPeopleSelected, onPeopleDeselected: _onPeopleDeselected),
    );
  }

  Step _stepDate() {
    return Step(
      title: Text('Date'),
      subtitle: dayPicked != null ? Text('${dayPicked.day}-${dayPicked.month}-${dayPicked.year}') : null,
      isActive: isStepEnabled(dateStepIndex),
      content: Calendar(
        timetable: widget.timetable,
        initialDayPicked: dayPicked,
        onDaySelected: _daySelected,
        onDayDeselected: _dayDeselected,
      ),
    );
  }
  
  Step _stepTime(BuildContext context) {
    return Step(
      title: Text('Time'),
      subtitle: timePicked != null ? Text('${timePicked.format(context)}') : null,
      isActive: isStepEnabled(timeStepIndex),
      content: HourPicker(
        day: dayPicked,
        dayTimetable: demoTimetables.getDay(dayPicked?.weekday ?? 1),
        initialHourSelected: timePicked,
        onHourSelected: _timeSelected,
        onHourDeselected: _timeDeselected,
      ),
    );
  }

  /* Step _stepReview() {
    return Step(
      title: Text('Review'),
      isActive: true,
      content: Text('Review'),
    );
  } */

  // Reservation callbacks
  // PeoplePicker
  _onPeopleSelected(int people) {
    print('onPeopleSelected');
    setState(() {
      peoplePicked = people;
      dayPicked = null;
      timePicked = null;
      stepEnabler = dateStepIndex;
    });
    _next();
  }
  _onPeopleDeselected() {
    print('onPeopleDeselected');
    setState(() {
      peoplePicked = null;
      dayPicked = null;
      timePicked = null;
      stepEnabler = peopleStepIndex;
    });
  }
  // DayPicker
  _daySelected(DateTime day) {
    print('daySelected');
    setState(() {
      dayPicked = day;
      timePicked = null;
      stepEnabler = timeStepIndex;
    });
    _next();
  }
  _dayDeselected() {
    print('dayDeselected');
    setState(() {
      dayPicked = null;
      timePicked = null;
      stepEnabler = dateStepIndex;
    });
  }
  // TimePicker
  _timeSelected(TimeOfDay time) {
    print('timeSelected');
    setState(() {
      timePicked = time;
    });
    _validateReservationData();
  }
  _timeDeselected() {
    print('timeDeselected');
    setState(() {
      timePicked = null;
    });
  }

  _validateReservationData() {
    if (peoplePicked != null && dayPicked != null && timePicked != null) {
      print('RESERVATION COMPLETED!');
      if (widget.onReservationCompleted != null)
        widget.onReservationCompleted(Reservation(peopleNumber: peoplePicked, day: dayPicked, time: timePicked));
    }
  }

  // Step callbacks
  _next() {
    if (stepIndex + 1 < steps.length) {
      _goTo(stepIndex + 1);
    } else 
      setState(() {
        completed = true;
      });
  }

  /* _cancel() {
    if (stepIndex > 0)
      setState(() {
        stepIndex -= 1;
      });
  } */

  void _goTo(int step) {
    setState(() {
      if (step < steps.length && step <= stepEnabler)
        stepIndex = step;
    });
  }


  @override
  Widget build(BuildContext context) {
    steps = [
          _stepPeople(),
          _stepDate(),
          _stepTime(context),
          // _stepReview(),
        ];
    return Stepper(
        type: StepperType.horizontal,
        steps: steps,
        currentStep: stepIndex,
        /* onStepContinue: _next,
        onStepCancel: _cancel, */
        onStepTapped: (step) => _goTo(step),
        controlsBuilder: (BuildContext context, {Function onStepContinue, Function onStepCancel}) => Row(),
      );
  }

}
