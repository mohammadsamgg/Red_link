import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditDonorProfile extends StatefulWidget {
  final String donorId;

  const EditDonorProfile({Key? key, required this.donorId}) : super(key: key);

  @override
  _EditDonorProfileState createState() => _EditDonorProfileState();
}

class _EditDonorProfileState extends State<EditDonorProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  bool _isLoading = false; // Loading state for UI
  bool _hasError = false; // Error state

  @override
  void initState() {
    super.initState();
    _loadDonorData();
  }

  // Load donor data when the page is loaded
  void _loadDonorData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      DocumentSnapshot donor =
          await FirebaseFirestore.instance
              .collection('donors')
              .doc(widget.donorId)
              .get();

      if (donor.exists) {
        setState(() {
          _nameController.text = donor['name'];
          _bloodGroupController.text = donor['bloodGroup'];
          _contactController.text = donor['contact'];
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading donor data: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update donor data in Firestore
  void _updateDonor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      try {
        await FirebaseFirestore.instance
            .collection('donors')
            .doc(widget.donorId)
            .update({
              'name': _nameController.text,
              'bloodGroup': _bloodGroupController.text,
              'contact': _contactController.text,
            });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Donor profile updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _hasError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating donor profile: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Delete donor profile from Firestore
  void _deleteDonor() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await FirebaseFirestore.instance
          .collection('donors')
          .doc(widget.donorId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donor profile deleted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting donor profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Donor Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loading indicator
                : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      TextFormField(
                        controller: _bloodGroupController,
                        decoration: InputDecoration(labelText: 'Blood Group'),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter blood group'
                                    : null,
                      ),
                      TextFormField(
                        controller: _contactController,
                        decoration: InputDecoration(labelText: 'Contact'),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Please enter contact number'
                                    : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateDonor,
                        child: Text('Update Donor'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _deleteDonor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete Donor'),
                      ),
                      if (_hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'An error occurred. Please try again.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }
}
