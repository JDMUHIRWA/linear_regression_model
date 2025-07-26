import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(GPAPredictorApp());
}

class GPAPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Predictor',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Color(0xFF6366F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
        ),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        fontFamily: 'Inter',
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF475569)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ),
      home: InputFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InputFormPage extends StatefulWidget {
  @override
  _InputFormPageState createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _studyTimeController = TextEditingController();
  final TextEditingController _absencesController = TextEditingController();

  // Dropdown values
  int _gender = 0;
  int _parentalEducation = 2;
  int _parentalSupport = 2;
  int _gradeClass = 2;

  // Toggle values
  bool _tutoring = false;
  bool _extracurricular = false;
  bool _sports = false;
  bool _music = false;
  bool _volunteering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.school, size: 48, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'GPA Predictor',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Academic Success Prediction',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Student Information'),
                          SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildNumberField(
                                  'Age',
                                  _ageController,
                                  'Enter age (15-18)',
                                  Icons.person,
                                  minValue: 15,
                                  maxValue: 18,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  'Gender',
                                  _gender,
                                  ['Male', 'Female'],
                                  Icons.people,
                                  (value) => setState(() => _gender = value!),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24),
                          _buildSectionTitle('Academic Information'),
                          SizedBox(height: 16),

                          _buildNumberField(
                            'Weekly Study Hours',
                            _studyTimeController,
                            'Hours per week (0-20)',
                            Icons.book,
                            minValue: 0,
                            maxValue: 20,
                            isDecimal: true,
                          ),

                          SizedBox(height: 16),
                          _buildNumberField(
                            'Absences This Year',
                            _absencesController,
                            'Number of absences (0-30)',
                            Icons.calendar_today,
                            minValue: 0,
                            maxValue: 30,
                          ),

                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  'Current Grade',
                                  _gradeClass,
                                  [
                                    'A (3.5-4.0)',
                                    'B (3.0-3.5)',
                                    'C (2.5-3.0)',
                                    'D (2.0-2.5)',
                                    'F (<2.0)',
                                  ],
                                  Icons.grade,
                                  (value) =>
                                      setState(() => _gradeClass = value!),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 32),
                          _buildSectionTitle('Family Support'),
                          SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  'Parental Education',
                                  _parentalEducation,
                                  [
                                    'None',
                                    'High School',
                                    'Some College',
                                    'Bachelor\'s',
                                    'Higher',
                                  ],
                                  Icons.school,
                                  (value) => setState(
                                    () => _parentalEducation = value!,
                                  ),
                                ),
                              ),
                              SizedBox(width: 1),
                              Expanded(
                                child: _buildDropdown(
                                  'Parental Support',
                                  _parentalSupport,
                                  [
                                    'None',
                                    'Low',
                                    'Moderate',
                                    'High',
                                    'Very High',
                                  ],
                                  Icons.family_restroom,
                                  (value) =>
                                      setState(() => _parentalSupport = value!),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24),
                          _buildSectionTitle('Activities & Support'),
                          SizedBox(height: 16),

                          _buildToggleRow(
                            'Tutoring',
                            _tutoring,
                            Icons.person_pin,
                            (value) => setState(() => _tutoring = value),
                          ),

                          _buildToggleRow(
                            'Extracurricular Activities',
                            _extracurricular,
                            Icons.group_work,
                            (value) => setState(() => _extracurricular = value),
                          ),

                          _buildToggleRow(
                            'Sports',
                            _sports,
                            Icons.sports_basketball,
                            (value) => setState(() => _sports = value),
                          ),

                          _buildToggleRow(
                            'Music Activities',
                            _music,
                            Icons.music_note,
                            (value) => setState(() => _music = value),
                          ),

                          _buildToggleRow(
                            'Volunteering',
                            _volunteering,
                            Icons.volunteer_activism,
                            (value) => setState(() => _volunteering = value),
                          ),

                          SizedBox(height: 32),

                          // Predict Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _predictGPA,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                shadowColor: Color(0xFF6366F1).withOpacity(0.4),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.psychology, size: 24),
                                        SizedBox(width: 12),
                                        Text(
                                          'Predict GPA',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildNumberField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    required int minValue,
    required int maxValue,
    bool isDecimal = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isDecimal
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Color(0xFF6366F1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFFF9FAFB),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            final numValue = isDecimal
                ? double.tryParse(value)
                : int.tryParse(value);
            if (numValue == null) {
              return 'Please enter a valid number';
            }
            if (numValue < minValue || numValue > maxValue) {
              return '$label must be between $minValue and $maxValue';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    int value,
    List<String> items,
    IconData icon,
    Function(int?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Color(0xFF6366F1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFFF9FAFB),
          ),
          items: items.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildToggleRow(
    String label,
    bool value,
    IconData icon,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF6366F1), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF6366F1),
            activeTrackColor: Color(0xFF6366F1).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Future<void> _predictGPA() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Replace with your actual API URL
      const String apiUrl =
          'https://linear-regression-model-ofxu.onrender.com/predict';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'age': int.parse(_ageController.text),
          'gender': _gender,
          'ethnicity': 1, // Fixed for African American
          'parental_education': _parentalEducation,
          'study_time_weekly': double.parse(_studyTimeController.text),
          'absences': int.parse(_absencesController.text),
          'tutoring': _tutoring ? 1 : 0,
          'parental_support': _parentalSupport,
          'extracurricular': _extracurricular ? 1 : 0,
          'sports': _sports ? 1 : 0,
          'music': _music ? 1 : 0,
          'volunteering': _volunteering ? 1 : 0,
          'grade_class': _gradeClass,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsPage(result: result)),
        );
      } else {
        _showErrorDialog(
          'API Error',
          'Failed to get prediction. Please try again.',
        );
      }
    } catch (e) {
      _showErrorDialog(
        'Connection Error',
        'Please check your internet connection and API URL.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _studyTimeController.dispose();
    _absencesController.dispose();
    super.dispose();
  }
}

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultsPage({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double gpa = result['predicted_gpa']?.toDouble() ?? 0.0;
    final String grade = result['grade_category'] ?? 'N/A';
    final String confidence = result['confidence_level'] ?? 'Unknown';
    final Map<String, dynamic> factors = result['success_factors'] ?? {};

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prediction Results',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Academic Success Analysis',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Results Container
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // GPA Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6366F1).withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Predicted GPA',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                gpa.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Grade: $grade',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Confidence Card
                        _buildInfoCard(
                          'Confidence Level',
                          confidence,
                          Icons.psychology,
                          Color(0xFF10B981),
                        ),

                        SizedBox(height: 24),

                        // Success Factors
                        Text(
                          'Success Factors Analysis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 16),

                        ...factors.entries
                            .map(
                              (entry) => _buildFactorCard(
                                _getFactorTitle(entry.key),
                                entry.value.toString(),
                                _getFactorIcon(entry.key),
                                _getFactorColor(entry.value.toString()),
                              ),
                            )
                            .toList(),

                        SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6366F1),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'New Prediction',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFactorCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFactorTitle(String key) {
    switch (key) {
      case 'study_time':
        return 'Study Time';
      case 'parental_support':
        return 'Parental Support';
      case 'attendance':
        return 'Attendance';
      case 'activities':
        return 'Activities';
      default:
        return key.replaceAll('_', ' ').toUpperCase();
    }
  }

  IconData _getFactorIcon(String key) {
    switch (key) {
      case 'study_time':
        return Icons.schedule;
      case 'parental_support':
        return Icons.family_restroom;
      case 'attendance':
        return Icons.calendar_today;
      case 'activities':
        return Icons.sports;
      default:
        return Icons.info;
    }
  }

  Color _getFactorColor(String value) {
    if (value.toLowerCase().contains('high') ||
        value.toLowerCase().contains('excellent') ||
        value.toLowerCase().contains('strong')) {
      return Color(0xFF10B981);
    } else if (value.toLowerCase().contains('moderate') ||
        value.toLowerCase().contains('good')) {
      return Color(0xFFF59E0B);
    } else {
      return Color(0xFFEF4444);
    }
  }
}
