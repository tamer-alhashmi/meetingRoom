import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/user/app_user.dart';
import '../widgets/welcome_widget.dart';

class UserBookingScreen extends StatefulWidget {
  final AppUser user; // AppUser is required

  const UserBookingScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserBookingScreenState createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  final CollectionReference _roomsCollection =
  FirebaseFirestore.instance.collection('rooms');
  final CollectionReference _reservationsCollection =
  FirebaseFirestore.instance.collection('reservations');

  String? _selectedRoomId;
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> _reservationsByDate = {};
  Map<String, String> _roomNames = {};
  Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _fetchReservations();
    _fetchRoomNames();
    _fetchUserNames();
  }

  Future<void> _fetchReservations() async {
    final snapshot = await _reservationsCollection.get();

    setState(() {
      _reservationsByDate = {};
      for (var doc in snapshot.docs) {
        final reservation = doc.data() as Map<String, dynamic>;
        final date = (reservation['date'] as Timestamp).toDate();
        final dateKey = DateTime(date.year, date.month, date.day);

        if (_reservationsByDate[dateKey] == null) {
          _reservationsByDate[dateKey] = [];
        }

        _reservationsByDate[dateKey]!.add({
          'roomName': reservation['roomName'] ?? 'Unknown Room',
          'userName': reservation['userName'] ?? 'Unknown User',
          'time': date,
          'status': reservation['status'],
        });
      }
    });

    debugPrint("Reservations Map: $_reservationsByDate");
  }

  Future<void> _fetchRoomNames() async {
    final snapshot = await _roomsCollection.get();
    setState(() {
      _roomNames = {
        for (var doc in snapshot.docs) doc.id: doc['name'],
      };
    });
  }

  Future<void> _fetchUserNames() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _userNames = {
        for (var doc in snapshot.docs) doc.id: doc['firstName'],
      };
    });
  }

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

  void _showReservationDetails(List<Map<String, dynamic>> reservations) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reservation Details'),
          content: SingleChildScrollView(
            child: Column(
              children: reservations.map((reservation) {
                return ListTile(
                  title: Text('Room: ${reservation['roomName']}'),
                  subtitle: Text(
                    'User: ${reservation['userName']}\n'
                        'Time: ${reservation['time']}\n'
                        'Status: ${reservation['status']}',
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showNewReservationDialog() {
    DateTime? selectedStartTime;
    DateTime? selectedEndTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Reservation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Select a Room'),
                value: _selectedRoomId,
                onChanged: (value) {
                  setState(() {
                    _selectedRoomId = value;
                  });
                },
                items: _roomNames.entries
                    .map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    selectedStartTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      picked.hour,
                      picked.minute,
                    );
                  }
                },
                child: Text(selectedStartTime == null
                    ? 'Select Start Time'
                    : selectedStartTime.toString()),
              ),
              TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    selectedEndTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      picked.hour,
                      picked.minute,
                    );
                  }
                },
                child: Text(selectedEndTime == null
                    ? 'Select End Time'
                    : selectedEndTime.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedRoomId != null &&
                    selectedStartTime != null &&
                    selectedEndTime != null) {
                  await _reservationsCollection.add({
                    'roomId': _selectedRoomId,
                    'roomName': _roomNames[_selectedRoomId],
                    'userId': widget.user.uid,
                    'userName': widget.user.firstName,
                    'date': Timestamp.fromDate(selectedStartTime!),
                    'endDate': Timestamp.fromDate(selectedEndTime!),
                    'status': 'pending',
                  });
                  await _fetchReservations();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please complete all fields.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _refreshData() async {
    await Future.wait([
      _fetchReservations(),
      _fetchRoomNames(),
      _fetchUserNames(),
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Booking', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              WelcomeWidget(user: widget.user),
              const SizedBox(height: 20.0),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                eventLoader: (day) {
                  final events = _reservationsByDate[day] ?? [];
                  return events;
                },
                onDaySelected: (selectedDay, _) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
          
                  final reservations = _reservationsByDate[selectedDay];
                  if (reservations != null && reservations.isNotEmpty) {
                    _showReservationDetails(reservations);
                  }
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Colors.orange, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  markersMaxCount: 3,
                  markersAlignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewReservationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
