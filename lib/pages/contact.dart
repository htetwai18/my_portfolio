import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hwl_portforlio/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  final String page;
  const ContactPage({
    super.key,
    required this.page,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // Add controllers to get the text field values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _navbarFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Start slightly below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _navbarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0,
            curve: Curves.easeOut), // Appears towards the end
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose the controllers when the widget is removed
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // This is the new function to send the email
  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      const serviceId = 'service_dx6jkwf';
      const templateId = 'template_dsbktpk';
      const userId = 'nEOpcklJoxm-lX5As';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'name': _nameController.text,
            'email': _emailController.text,
            'message': _messageController.text,
          }
        }),
      );

      if (response.statusCode == 200) {
        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully!')),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to send message. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isDesktop = screenSize.width > 800; // Arbitrary breakpoint
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: Stack(
          children: [
            Positioned(
              top: isDesktop ? 40 : 20, // Adjust padding for desktop/mobile
              right: isDesktop ? 60 : 12,
              left: isDesktop ? null : 12,
              child: FadeTransition(
                opacity: _navbarFadeAnimation,
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      NavLink(title: 'Home', page: widget.page),
                      NavLink(title: 'Projects', page: widget.page),
                      NavLink(title: 'Experiences', page: widget.page),
                      NavLink(title: 'Education', page: widget.page),
                      NavLink(title: 'Contact', page: widget.page),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                padding: EdgeInsets.only(
                  top: isDesktop ? 40 : 20,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(
                              maxWidth: 800), // Max width for content
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 48.0),
                          child: Column(
                            children: [
                              _buildHeader(context),
                              const SizedBox(height: 32),
                              _buildFormCard(context),
                              const SizedBox(height: 48),
                              _buildFooter(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Get in Touch',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBB86FC),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities.\nFeel free to reach out, and I'll get back to you as soon as possible.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Use LayoutBuilder for responsive Name/Email fields
            LayoutBuilder(
              builder: (context, constraints) {
                // Use a breakpoint to switch between Row and Column
                if (constraints.maxWidth > 550) {
                  return Row(
                    children: [
                      Expanded(
                          child: _buildTextFormField('Your Name',
                              controller: _nameController)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildTextFormField('Your Email',
                              controller: _emailController)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTextFormField('Your Name',
                          controller: _nameController),
                      const SizedBox(height: 16),
                      _buildTextFormField('Your Email',
                          controller: _emailController),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField('Your Message',
                maxLines: 5, controller: _messageController),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _sendEmail, // Call the new function here
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                foregroundColor: const Color(0xFF121212),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                shadowColor: Colors.indigo.withOpacity(0.4),
              ),
              child: const Text(
                'Send Message',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the TextFormField to accept a controller
  Widget _buildTextFormField(String label,
      {int maxLines = 1, required TextEditingController controller}) {
    return TextFormField(
      controller: controller, // Assign the controller
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: const Color(0xFFBB86FC), width: 2),
        ),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (label == 'Your Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw "Cannot launch url";
      }
    }

    return Column(
      children: [
        SizedBox(
          height: 30,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(FontAwesomeIcons.linkedin, () async {
                await _launchUrl('https://www.linkedin.com/in/htetwailwin/');
              }, 'LinkedIn'),
              const SizedBox(width: 24),
              _buildSocialIcon(FontAwesomeIcons.github, () async {
                await _launchUrl('https://github.com/htetwai18');
              }, 'Github'),
              const SizedBox(width: 24),
              _buildSocialIcon(
                  FontAwesomeIcons
                      .reddit, // Phone is available in default Material Icons
                  () async {
                await _launchUrl(
                    'https://www.reddit.com/user/OkFudge8505/'); // opens phone dialer
              }, 'Reddit'),
              const SizedBox(width: 24),
              _buildSocialIcon(
                  FontAwesomeIcons
                      .medium, // Phone is available in default Material Icons
                  () async {
                await _launchUrl(
                    'https://medium.com/@htetwai.18.lwin'); // opens phone dialer
              }, 'Medium'),
              const SizedBox(width: 24),
              _buildSocialIcon(
                  FontAwesomeIcons
                      .youtube, // Phone is available in default Material Icons
                  () async {
                await _launchUrl(
                    'https://www.youtube.com/@HtetWaiLwin-q1g'); // opens phone dialer
              }, 'Youtube'),
              const SizedBox(width: 24),
              _buildSocialIcon(
                  FontAwesomeIcons
                      .stackOverflow, // Phone is available in default Material Icons
                  () async {
                await _launchUrl(
                    'https://stackoverflow.com/users/27296718/htet-wai-lwin'); // opens phone dialer
              }, 'Stack overflow'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '© 2025 Htet Wai Lwin. Created with Flutter 3.35.4',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, Function onTap, String tip) {
    return IconButton(
      icon: Icon(icon, color: Colors.grey[400]),
      onPressed: () {
        onTap();
      },
      splashRadius: 24,
      tooltip: tip,
    );
  }
}
