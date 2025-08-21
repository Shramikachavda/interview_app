import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widget/custom_button.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          _buildCustomAppBar(context)
,           Expanded(
  child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
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
                    '1. Information We Collect',
                    'We collect the following types of information:\n\n'
                    '• Personal Information: Name, email, experience level\n'
                    '• Interview Data: Your responses, code submissions, performance metrics\n'
                    '• Usage Data: Session duration, question attempts, progress tracking\n'
                    '• Technical Data: Device information, IP address, browser type\n'
                    '• AI Training Data: Anonymized responses for model improvement',
                  ),

                  _buildSection(
                    context,
                    '2. How We Use Your Information',
                    'Your information is used to:\n\n'
                    '• Provide personalized interview practice sessions\n'
                    '• Generate AI-powered feedback and recommendations\n'
                    '• Track your progress and performance analytics\n'
                    '• Improve our AI models and question bank\n'
                    '• Ensure platform security and prevent fraud\n'
                    '• Send important updates and notifications',
                  ),

                  _buildSection(
                    context,
                    '3. AI and Machine Learning',
                    'Our AI systems process your data to:\n\n'
                    '• Analyze interview responses using Natural Language Processing\n'
                    '• Evaluate code submissions and provide feedback\n'
                    '• Generate personalized question recommendations\n'
                    '• Improve conversation flows using LangGraph\n'
                    '• Train models to provide better assistance\n'
                    '• Ensure fair and unbiased evaluation',
                  ),

                  _buildSection(
                    context,
                    '4. Data Security',
                    'We implement robust security measures:\n\n'
                    '• End-to-end encryption for all data transmission\n'
                    '• Secure cloud storage with industry-standard protection\n'
                    '• Regular security audits and vulnerability assessments\n'
                    '• Access controls and authentication protocols\n'
                    '• Data backup and disaster recovery procedures\n'
                    '• Compliance with GDPR, CCPA, and other regulations',
                  ),

                  _buildSection(
                    context,
                    '5. Data Sharing',
                    'We do not sell your personal information. Data may be shared with:\n\n'
                    '• Service providers who assist in platform operation\n'
                    '• AI model providers for processing and analysis\n'
                    '• Legal authorities when required by law\n'
                    '• Third parties with your explicit consent\n'
                    '• Anonymized data for research and improvement',
                  ),

                  _buildSection(
                    context,
                    '6. Your Rights',
                    'You have the following rights regarding your data:\n\n'
                    '• Access: Request a copy of your personal data\n'
                    '• Rectification: Correct inaccurate information\n'
                    '• Erasure: Request deletion of your data\n'
                    '• Portability: Export your data in a standard format\n'
                    '• Objection: Opt-out of certain data processing\n'
                    '• Restriction: Limit how we process your data',
                  ),

                  _buildSection(
                    context,
                    '7. Data Retention',
                    'We retain your data for:\n\n'
                    '• Active account data: Until account deletion\n'
                    '• Interview sessions: 2 years for progress tracking\n'
                    '• Analytics data: 3 years for platform improvement\n'
                    '• AI training data: Indefinitely in anonymized form\n'
                    '• Legal requirements: As required by applicable law',
                  ),

                  _buildSection(
                    context,
                    '8. Cookies and Tracking',
                    'We use cookies and similar technologies to:\n\n'
                    '• Maintain your session and preferences\n'
                    '• Analyze platform usage and performance\n'
                    '• Provide personalized content and recommendations\n'
                    '• Ensure security and prevent fraud\n'
                    '• Improve user experience and functionality',
                  ),

                  _buildSection(
                    context,
                    '9. Children\'s Privacy',
                    'Our platform is not intended for children under 13. We do not knowingly collect personal information from children under 13. If you believe we have collected such information, please contact us immediately.',
                  ),

                  _buildSection(
                    context,
                    '10. International Transfers',
                    'Your data may be processed in countries other than your own. We ensure adequate protection through:\n\n'
                    '• Standard contractual clauses\n'
                    '• Adequacy decisions by relevant authorities\n'
                    '• Appropriate safeguards and security measures\n'
                    '• Compliance with local data protection laws',
                  ),

                  _buildSection(
                    context,
                    '11. Changes to This Policy',
                    'We may update this Privacy Policy from time to time. We will notify you of any material changes by:\n\n'
                    '• Posting the updated policy on our platform\n'
                    '• Sending email notifications to registered users\n'
                    '• Displaying prominent notices on our website\n'
                    '• Requiring consent for significant changes',
                  ),

                  _buildSection(
                    context,
                    '12. Contact Us',
                    'If you have questions about this Privacy Policy, please contact us at:\n\n'
                    'Email: privacy@interviewcoach.ai\n'
                    'Data Protection Officer: dpo@interviewcoach.ai\n'
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