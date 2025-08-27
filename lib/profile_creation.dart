import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Main widget to create donor profile
class ProfileCreationPage extends StatefulWidget {
  final String bloodType;

  const ProfileCreationPage({super.key, required this.bloodType});

  @override
  State<ProfileCreationPage> createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  // Text controllers for input fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  // Flag to check if phone number already exists
  bool _isPhoneExists = false;

  @override
  void dispose() {
    // Clean up controllers to avoid memory leaks
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Check if phone number already exists in Firestore
  Future<void> _checkPhoneNumber(String phone) async {
    if (phone.length >= 10) {
      final doc =
          await FirebaseFirestore.instance
              .collection('donors')
              .doc(phone)
              .get();
      setState(() {
        _isPhoneExists = doc.exists;
      });
    } else {
      setState(() {
        _isPhoneExists = false;
      });
    }
  }

  // Save the profile to Firestore after validation
  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();
    final bloodType = widget.bloodType;

    // Validation: Check for empty fields
    if (name.isEmpty || phone.isEmpty || location.isEmpty) {
      if (!mounted) return;
      _showMessage("Please fill all fields!");
      return;
    }

    // Validation: Check if phone already exists
    if (_isPhoneExists) {
      if (!mounted) return;
      _showMessage("Phone number is already used!");
      return;
    }

    try {
      // Save data to Firestore using phone as document ID
      await FirebaseFirestore.instance.collection('donors').doc(phone).set({
        'name': name,
        'phone': phone,
        'location': location,
        'bloodType': bloodType,
      });

      if (!mounted) return;
      _showMessage("Profile Created Successfully!");

      // Navigate back after saving
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showMessage("Error: ${e.toString()}");
    }
  }

  // Display snackbar message
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Create Donor Profile - ${widget.bloodType}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name input field
              _buildInputField(
                controller: _nameController,
                label: "Name",
                icon: Icons.person,
                size: size,
              ),

              SizedBox(height: size.height * 0.02),

              // Phone number input field (no auto country code)
              _buildInputField(
                controller: _phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                size: size,
                keyboardType: TextInputType.phone,
                errorText:
                    _isPhoneExists
                        ? "This phone number is already used!"
                        : null,
                onChanged: (val) {
                  _checkPhoneNumber(val.trim());
                },
              ),

              SizedBox(height: size.height * 0.02),

              // Location input field
              _buildInputField(
                controller: _locationController,
                label: "Location",
                icon: Icons.location_on,
                size: size,
              ),

              SizedBox(height: size.height * 0.03),

              // Save Profile button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(size.width * 0.8, size.height * 0.07),
                ),
                child: Text(
                  "Save Profile",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable function to build input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Size size,
    TextInputType? keyboardType,
    String? errorText,
    void Function()? onTap,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red),
        labelText: label,
        errorText: errorText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.05,
        ),
      ),
      onTap: onTap,
      onChanged: onChanged,
    );
  }
}
