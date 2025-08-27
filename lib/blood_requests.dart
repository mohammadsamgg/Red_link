import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequestPage extends StatefulWidget {
  const BloodRequestPage({super.key});

  @override
  State<BloodRequestPage> createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();

  String? _bloodType;
  final _types = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  Future<void> _submit() async {
    if (_name.text.isEmpty ||
        _phone.text.isEmpty ||
        _location.text.isEmpty ||
        _bloodType == null) {
      _showMsg("Please fill all fields!");
      return;
    }

    final phone = _phone.text.trim();

    await FirebaseFirestore.instance
        .collection('blood_requests')
        .doc(phone)
        .set({
          'id': phone,
          'name': _name.text,
          'phone': phone,
          'location': _location.text,
          'bloodType': _bloodType,
          'timestamp': FieldValue.serverTimestamp(),
        });

    _showMsg("Blood request submitted successfully!");

    _name.clear();
    _phone.clear();
    _location.clear();
    setState(() => _bloodType = null);
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _inputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? type,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _dropdown() => DropdownButtonFormField<String>(
    value: _bloodType,
    items:
        _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
    onChanged: (val) => setState(() => _bloodType = val),
    decoration: const InputDecoration(
      labelText: "Blood Type",
      prefixIcon: Icon(Icons.bloodtype, color: Colors.red),
      labelStyle: TextStyle(fontWeight: FontWeight.w800),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Request Blood",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _inputField(_name, "Your Name", Icons.person),
            const SizedBox(height: 10),
            _inputField(
              _phone,
              "Phone Number",
              Icons.phone,
              type: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            _inputField(_location, "Location", Icons.location_on),
            const SizedBox(height: 15),
            _dropdown(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  "Submit Request",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Available Donors:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(child: DonorList(bloodType: _bloodType)),
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
      return const Center(
        child: Text(
          "Select a blood type to view donors",
          style: TextStyle(fontWeight: FontWeight.w800),
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
          return const Center(
            child: Text(
              "No donors available for this blood type",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          );
        }

        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final donor = snapshot.data!.docs[i].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                title: Text(
                  donor['name'],
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  "${donor['phone']} • ${donor['location']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.bloodtype,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
