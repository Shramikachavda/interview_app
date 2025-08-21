import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widget/custom_button.dart';
import 'monaco_editor.dart';

class CodingQuestion {
  final String id;
  final String title;
  final String description;
  final String initialCode;
  final String language;
  final List<String> testCases;
  final String expectedOutput;
  final String difficulty;

  CodingQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.initialCode,
    required this.language,
    required this.testCases,
    required this.expectedOutput,
    required this.difficulty,
  });
}

class EnhancedCodingScreen extends StatefulWidget {
  final CodingQuestion question;

  const EnhancedCodingScreen({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<EnhancedCodingScreen> createState() => _EnhancedCodingScreenState();
}

class _EnhancedCodingScreenState extends State<EnhancedCodingScreen> {
  String _currentCode = '';
  String _selectedLanguage = '';
  bool _isRunning = false;
  String _output = '';
  bool _showOutput = false;

  @override
  void initState() {
    super.initState();
    _currentCode = widget.question.initialCode;
    _selectedLanguage = widget.question.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coding Challenge'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Show language selection
              _showLanguageDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Question Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(widget.question.difficulty),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.question.difficulty.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _selectedLanguage.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.question.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.question.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          // Editor and Output Section
          Expanded(
            child: Row(
              children: [
                // Code Editor
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: MonacoEditor(
                        initialCode: _currentCode,
                        language: _selectedLanguage,
                        onCodeChanged: (code) {
                          setState(() {
                            _currentCode = code;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                // Output Panel
                if (_showOutput)
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Output',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _showOutput = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  _output,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontFamily: 'monospace',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: _runCode,
                    text: 'Run Code',
                    icon: const Icon(Icons.play_arrow),
                    isLoading: _isRunning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    onPressed: _showOutput ? null : _toggleOutput,
                    text: 'Show Output',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    onPressed: _submitCode,
                    text: 'Submit',
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successColor;
      case 'medium':
        return AppTheme.warningColor;
      case 'hard':
        return AppTheme.errorColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('python', 'Python'),
            _buildLanguageOption('javascript', 'JavaScript'),
            _buildLanguageOption('java', 'Java'),
            _buildLanguageOption('cpp', 'C++'),
            _buildLanguageOption('sql', 'SQL'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String displayName) {
    return ListTile(
      leading: Icon(
        _selectedLanguage == language ? Icons.check_circle : Icons.circle_outlined,
        color: _selectedLanguage == language ? AppTheme.primaryColor : Colors.grey,
      ),
      title: Text(displayName),
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  void _runCode() async {
    setState(() {
      _isRunning = true;
      _showOutput = true;
    });

    // Simulate code execution
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRunning = false;
      _output = '''
Running code...
Input: [1, 2, 3, 4, 5]
Output: [5, 4, 3, 2, 1]
Execution time: 0.002s
Memory used: 2.1MB
All test cases passed! ✅
''';
    });
  }

  void _toggleOutput() {
    setState(() {
      _showOutput = !_showOutput;
    });
  }

  void _submitCode() {
    // Show submission dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Solution'),
        content: const Text('Are you sure you want to submit your solution?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSubmissionResult();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showSubmissionResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submission Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✅ All test cases passed!'),
            const SizedBox(height: 8),
            const Text('Score: 100/100'),
            const SizedBox(height: 8),
            const Text('Time Complexity: O(n)'),
            const SizedBox(height: 8),
            const Text('Space Complexity: O(1)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 