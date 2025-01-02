import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationCalendar extends StatefulWidget {
  final Map<DateTime, List<Map<String, dynamic>>> reservationsByDate;
  final Function(DateTime, List<Map<String, dynamic>>) onDaySelected;

  const ReservationCalendar({
    Key? key,
    required this.reservationsByDate,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  _ReservationCalendarState createState() => _ReservationCalendarState();
}

class _ReservationCalendarState extends State<ReservationCalendar> {
  DateTime _selectedDate = DateTime.now();

  Color _getReservationColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.orange;
      case 'pending':
        return Colors.yellow;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _selectedDate,
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      eventLoader: (day) {
        final localDay = DateTime(day.year, day.month, day.day);
        return widget.reservationsByDate[localDay] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
        });
        final events = widget.reservationsByDate[selectedDay] ?? [];
        widget.onDaySelected(selectedDay, events);
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 3,
        markersAlignment: Alignment.bottomCenter,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          final eventList = events.cast<Map<String, dynamic>>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: eventList.map((e) {
              final statusColor = _getReservationColor(e['status'] ?? 'Unknown');
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
