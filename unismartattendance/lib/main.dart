// Full improved main.dart file

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Attendance',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasPreviousReport = false;

  @override
  void initState() {
    super.initState();
    _checkPreviousReport();
  }

  Future<void> _checkPreviousReport() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      hasPreviousReport = prefs.containsKey('lastReport');
    });
  }

  void _openLastReport() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('lastReport');
    if (jsonData != null) {
      final data = jsonDecode(jsonData);
      final students =
          (data['students'] as List)
              .map<Map<String, String>>((e) => Map<String, String>.from(e))
              .toList();
      final course = data['course'];
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AttendanceReportScreen(students: students, course: course),
        ),
      );
    }
  }

  final List<String> quotes = [
    "Dream big. Start small. Act now.",
    "Push yourself, no one else will.",
    "Great things never come from comfort zones.",
    "Your only limit is your mind.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Smart Attendance, by Alex Rweyemamu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children:
                    quotes
                        .map(
                          (quote) => Container(
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Center(
                              child: Text(
                                quote,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Attendance'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClassSelectionScreen(),
                  ),
                );
              },
            ),
            if (hasPreviousReport)
              TextButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('View Last Report'),
                onPressed: _openLastReport,
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class ClassSelectionScreen extends StatelessWidget {
  const ClassSelectionScreen({super.key});

  final List<String> classes = const ['COET 1', 'COET 2', 'COET 3', 'COET 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Class')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children:
            classes
                .map(
                  (cls) => Card(
                    child: ListTile(
                      title: Text(cls),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CRSelectionScreen(className: cls),
                            ),
                          ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class CRSelectionScreen extends StatelessWidget {
  final String className;
  const CRSelectionScreen({super.key, required this.className});

  List<String> getCRsForClass(String className) {
    switch (className) {
      case 'COET 1':
        return ['Ayan', 'Sara'];
      case 'COET 2':
        return ['Hassan', 'Zara'];
      case 'COET 3':
        return ['Imran', 'Nida'];
      case 'COET 4':
        return ['Tariq', 'Amna'];
      default:
        return ['Default CR'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final crs = getCRsForClass(className);

    return Scaffold(
      appBar: AppBar(title: Text('Select CR - $className')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children:
            crs
                .map(
                  (cr) => Card(
                    child: ListTile(
                      title: Text(cr),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => CourseSelectionScreen(
                                    className: className,
                                  ),
                            ),
                          ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class CourseSelectionScreen extends StatelessWidget {
  final String className;
  const CourseSelectionScreen({super.key, required this.className});

  List<String> getCoursesForClass(String className) {
    switch (className) {
      case 'COET 1':
        return ['Intro to CE', 'Basic Electronics', 'Digital Logic'];
      case 'COET 2':
        return ['Microprocessors', 'Data Structures', 'OOP'];
      case 'COET 3':
        return ['OS', 'DBMS', 'Computer Networks'];
      case 'COET 4':
        return ['AI & ML', 'Cybersecurity', 'Cloud Computing'];
      default:
        return ['General Course'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = getCoursesForClass(className);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Course')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children:
            courses
                .map(
                  (course) => Card(
                    child: ListTile(
                      title: Text(course),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => StudentEntryScreen(course: course),
                            ),
                          ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class StudentEntryScreen extends StatefulWidget {
  final String course;
  const StudentEntryScreen({super.key, required this.course});

  @override
  State<StudentEntryScreen> createState() => _StudentEntryScreenState();
}

class _StudentEntryScreenState extends State<StudentEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> students = [];
  String name = '';
  String id = '';
  int? editingIndex;

  void _addOrUpdateStudent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        if (editingIndex == null) {
          students.add({'name': name, 'id': id});
        } else {
          students[editingIndex!] = {'name': name, 'id': id};
          editingIndex = null;
        }
        name = '';
        id = '';
      });
      _formKey.currentState!.reset();
    }
  }

  void _startEditing(int index) {
    setState(() {
      editingIndex = index;
      name = students[index]['name']!;
      id = students[index]['id']!;
    });
  }

  void _deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
      if (editingIndex == index) {
        editingIndex = null;
        _formKey.currentState?.reset();
      }
    });
  }

  void _saveLastReport() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({'students': students, 'course': widget.course});
    await prefs.setString('lastReport', data);
  }

  void _finishAndViewReport() {
    if (students.isNotEmpty) {
      _saveLastReport(); // Add this line
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AttendanceReportScreen(
                students: students,
                course: widget.course,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingIndex != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Student Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                    ),
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Enter a name'
                                : null,
                    onChanged: (value) => name = value,
                  ),
                  TextFormField(
                    initialValue: id,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.length < 4 ||
                          value.length > 8) {
                        return 'ID must be 4-8 digits';
                      }
                      return null;
                    },
                    onChanged: (value) => id = value,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addOrUpdateStudent,
                        child: Text(isEditing ? 'Save Changes' : 'Add Student'),
                      ),
                      const SizedBox(width: 16),
                      if (!isEditing)
                        ElevatedButton(
                          onPressed: _finishAndViewReport,
                          child: const Text('Done'),
                        ),
                      if (isEditing)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              editingIndex = null;
                              name = '';
                              id = '';
                              _formKey.currentState?.reset();
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(students[index]['name']!),
                      subtitle: Text("ID: ${students[index]['id']!}"),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _startEditing(index),
                      onLongPress: () => _deleteStudent(index),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceReportScreen extends StatelessWidget {
  final List<Map<String, String>> students;
  final String course;

  const AttendanceReportScreen({
    super.key,
    required this.students,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Course: $course",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children:
                    students
                        .map(
                          (s) => ListTile(
                            title: Text(s['name']!),
                            subtitle: Text("ID: ${s['id']}"),
                            leading: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget:
                            (value, meta) => const Text('Students'),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: students.length.toDouble(),
                          color: Colors.indigo,
                          width: 40,
                          borderRadius: BorderRadius.circular(8),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 20,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Export to PDF'),
                onPressed: () async {
                  final pdf = pw.Document();
                  pdf.addPage(
                    pw.Page(
                      build:
                          (pw.Context context) => pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "Attendance Report - $course",
                                style: pw.TextStyle(fontSize: 20),
                              ),
                              pw.SizedBox(height: 10),
                              ...students.map(
                                (s) => pw.Text("${s['name']} (ID: ${s['id']})"),
                              ),
                            ],
                          ),
                    ),
                  );
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdf.save(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
