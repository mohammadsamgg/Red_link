import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequestPage extends StatefulWidget {
  const BloodRequestPage({super.key});

  @override
  State<BloodRequestPage> createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedBloodType;

  final List<String> _bloodTypes = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];

  void _submitRequest() async {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _selectedBloodType != null) {
      await FirebaseFirestore.instance.collection('blood_requests').add({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'location': _locationController.text,
        'bloodType': _selectedBloodType,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Blood request submitted successfully!")),
      );

      _nameController.clear();
      _phoneController.clear();
      _locationController.clear();
      setState(() {
        _selectedBloodType = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Blood",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Your Name",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              items:
                  _bloodTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodType = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Blood Type",
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text(
                "Submit Request",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Available Donors:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(child: DonorList(bloodType: _selectedBloodType)),
          ],
        ),
      ),
    );
  }
}

class DonorList extends StatelessWidget {
  final String? bloodType;
  const DonorList({super.key, this.bloodType});

  @override
  Widget build(BuildContext context) {
    if (bloodType == null) {
      return Center(
        child: Text(
          "Select a blood type to view donors",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('donors')
              .where('bloodType', isEqualTo: bloodType)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No donors available for this blood type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          );
        }

        var donors = snapshot.data!.docs;

        return ListView.builder(
          itemCount: donors.length,
          itemBuilder: (context, index) {
            var donor = donors[index].data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                title: Text(
                  donor['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${donor['phone']} • ${donor['location']}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                trailing: Icon(Icons.bloodtype, color: Colors.red),
              ),
            );
          },
        );
      },
    );
  }
}
