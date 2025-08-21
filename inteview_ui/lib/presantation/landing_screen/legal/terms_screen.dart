import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widget/custom_button.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          _buildCustomAppBar(context) ,
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms of Service',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: March 2024',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSection(
                    context,
                    '1. Acceptance of Terms',
                    'By accessing and using the Interview Coach platform, you accept and agree to be bound by the terms and provision of this agreement.',
                  ),

                  _buildSection(
                    context,
                    '2. Description of Service',
                    'Interview Coach is an AI-powered interview practice platform that provides:\n\n'
                    '• HR interview practice with behavioral questions\n'
                    '• Technical interview practice with coding challenges\n'
                    '• SQL query practice and database questions\n'
                    '• AI-powered feedback and performance analysis\n'
                    '• Real-time code execution and testing\n'
                    '• Progress tracking and performance analytics',
                  ),

                  _buildSection(
                    context,
                    '3. AI and Machine Learning',
                    'Our platform uses advanced AI technologies including:\n\n'
                    '• LangChain for intelligent question generation\n'
                    '• LangGraph for conversational interview flows\n'
                    '• Natural Language Processing for answer analysis\n'
                    '• Machine Learning for personalized feedback\n'
                    '• Real-time code execution and validation',
                  ),

                  _buildSection(
                    context,
                    '4. User Responsibilities',
                    'As a user of Interview Coach, you agree to:\n\n'
                    '• Provide accurate and truthful information\n'
                    '• Use the platform for educational purposes only\n'
                    '• Not attempt to reverse engineer or hack the system\n'
                    '• Respect intellectual property rights\n'
                    '• Maintain the confidentiality of your account',
                  ),

                  _buildSection(
                    context,
                    '5. Privacy and Data Protection',
                    'We are committed to protecting your privacy:\n\n'
                    '• Your interview responses are processed securely\n'
                    '• Personal data is encrypted and protected\n'
                    '• We do not share your data with third parties\n'
                    '• You can request data deletion at any time\n'
                    '• We comply with GDPR and other privacy regulations',
                  ),

                  _buildSection(
                    context,
                    '6. Intellectual Property',
                    'The Interview Coach platform and its content are protected by intellectual property laws:\n\n'
                    '• Platform code and design are proprietary\n'
                    '• Question bank and content are copyrighted\n'
                    '• AI models and algorithms are trade secrets\n'
                    '• User-generated content remains your property',
                  ),

                  _buildSection(
                    context,
                    '7. Limitation of Liability',
                    'Interview Coach is provided "as is" without warranties:\n\n'
                    '• We are not responsible for interview outcomes\n'
                    '• AI feedback is for educational purposes only\n'
                    '• We do not guarantee job placement or success\n'
                    '• Users are responsible for their own preparation',
                  ),

                  _buildSection(
                    context,
                    '8. Termination',
                    'We may terminate or suspend access to our service immediately, without prior notice, for any reason, including breach of these Terms.',
                  ),

                  _buildSection(
                    context,
                    '9. Changes to Terms',
                    'We reserve the right to modify these terms at any time. Continued use of the platform constitutes acceptance of updated terms.',
                  ),

                  _buildSection(
                    context,
                    '10. Contact Information',
                    'For questions about these Terms of Service, please contact us at:\n\n'
                    'Email: support@interviewcoach.ai\n'
                    'Address: [Your Company Address]\n'
                    'Phone: [Your Contact Number]',
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: CustomButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'I Understand',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Privacy and Policy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Customize Your Experience',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            SizedBox(width: 24,)

          ],
        ),
      ),
    );
  }
  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
} 