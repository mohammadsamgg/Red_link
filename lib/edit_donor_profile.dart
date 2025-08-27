import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

// Main widget for editing a donor profile
class EditDonorProfile extends StatefulWidget {
  const EditDonorProfile({super.key});

  @override
  State<EditDonorProfile> createState() => _EditDonorProfileState();
}

class _EditDonorProfileState extends State<EditDonorProfile> {
  // TextEditingControllers to handle input for name, phone, and location
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  // Variables to store donor ID and selected blood group
  String? _donorId, _bloodGroup;

  // Booleans to show loading and error state
  bool _loading = false;

  // List of all blood types to use in dropdown
  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  /// Method to search for a donor by phone number and blood type
  Future<void> _search() async {
    // Ensure both phone and blood group are entered
    if (_bloodGroup != null && _phoneController.text.trim().isNotEmpty) {
      setState(() => _loading = true); // Show loading indicator

      try {
        // Query Firestore collection 'donors'
        final result =
            await FirebaseFirestore.instance
                .collection('donors')
                .where('bloodType', isEqualTo: _bloodGroup)
                .where('phone', isEqualTo: _phoneController.text.trim())
                .get();

        // If a donor is found, populate the text fields with data
        if (result.docs.isNotEmpty) {
          final d = result.docs.first;
          setState(() {
            _donorId = d.id;
            _nameController.text = d['name'];
            _phoneController.text = d['phone'];
            _bloodGroup = d['bloodType'];
            _locationController.text = d['location'];
          });
        } else {
          _showMsg('No donor found with given info');
        }
      } catch (e) {
        _showMsg('Error: $e');
      } finally {
        setState(() => _loading = false); // Stop loading
      }
    } else {
      _showMsg('Please enter phone and select blood group');
    }
  }

  /// Method to update donor information in Firestore
  Future<void> _update() async {
    if (_donorId != null) {
      setState(() => _loading = true);

      try {
        await FirebaseFirestore.instance
            .collection('donors')
            .doc(_donorId)
            .update({
              'name': _nameController.text.trim(),
              'phone': _phoneController.text.trim(),
              'bloodType': _bloodGroup,
              'location': _locationController.text.trim(),
            });
        _showMsg('Donor profile updated!');
      } catch (e) {
        _showMsg('Error: $e');
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  /// Method to delete donor information from Firestore
  Future<void> _delete() async {
    if (_donorId != null) {
      setState(() => _loading = true);

      try {
        await FirebaseFirestore.instance
            .collection('donors')
            .doc(_donorId)
            .delete();
        _showMsg('Donor deleted!');
        setState(() {
          _donorId = null;
          _nameController.clear();
          _phoneController.clear();
          _locationController.clear();
          _bloodGroup = null;
        });
      } catch (e) {
        _showMsg('Error: $e');
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  /// Show a snackbar message on screen
  void _showMsg(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  /// Reusable button style generator
  ButtonStyle _btnStyle([Color color = Colors.red]) => ElevatedButton.styleFrom(
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
  );

  /// Reusable TextField builder
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Size size,
    TextInputType? keyboardType,
    bool isPhone = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red),
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size.width * 0.045,
        ),
      ),
      inputFormatters:
          isPhone
              ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ]
              : null,
    );
  }

  /// Blood group dropdown widget
  Widget _buildDropdown(Size size) => DropdownButtonFormField<String>(
    value: _bloodGroup,
    items:
        bloodTypes
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
    onChanged: (val) => setState(() => _bloodGroup = val),
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.bloodtype, color: Colors.red),
      labelText: 'Blood Type',
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size.width * 0.045,
      ),
    ),
  );

  /// Main widget build method
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Edit Donor Profile',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator()) // Loader
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Lottie animation for visual interest
                    Lottie.asset('assets/magni_glass.json', height: 120),
                    const SizedBox(height: 20),

                    // Blood group dropdown and phone input
                    _buildDropdown(size),
                    const SizedBox(height: 10),
                    _buildInputField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      size: size,
                      keyboardType: TextInputType.phone,
                      isPhone: true,
                    ),
                    const SizedBox(height: 20),

                    // Search button
                    ElevatedButton(
                      onPressed: _search,
                      style: _btnStyle(),
                      child: const Text(
                        'Search Donor',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // If donor found, show update/delete options
                    if (_donorId != null) ...[
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _nameController,
                        label: "Name",
                        icon: Icons.person,
                        size: size,
                      ),
                      const SizedBox(height: 10),
                      _buildDropdown(size),
                      const SizedBox(height: 10),
                      _buildInputField(
                        controller: _phoneController,
                        label: "Phone Number",
                        icon: Icons.phone,
                        size: size,
                        keyboardType: TextInputType.phone,
                        isPhone: true,
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        controller: _locationController,
                        label: "Location",
                        icon: Icons.location_on,
                        size: size,
                      ),
                      const SizedBox(height: 20),

                      // Update button
                      ElevatedButton(
                        onPressed: _update,
                        style: _btnStyle(Colors.red),
                        child: const Text(
                          'Update Donor',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Delete button
                      ElevatedButton(
                        onPressed: _delete,
                        style: _btnStyle(Colors.black),
                        child: const Text(
                          'Delete Donor',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ], // If donor found, show update/delete options
                  ], // children
                ),
              ),
    );
  }
}
