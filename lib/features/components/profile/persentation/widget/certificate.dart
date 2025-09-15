import 'package:flutter/material.dart';

class Certificate extends StatefulWidget {
  const Certificate({ super.key });

  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  void _addCertificate() {
    // Logic to add a new certificate
    print("Add Certificate button pressed");
  }

  void _viewCertificateDetails(int index) {
    // Logic to view certificate details
    print("View details for Certificate $index");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Certifications",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _addCertificate,
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Icon/text color
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: Icon(Icons.add),
                label: Text("Add"),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...List.generate(
            3,
            (i) => Column(
              children: [
                CertificateCard(
                  title: "Certificate ${i + 1}",
                  description: "Description for Certificate ${i + 1}",
                  onPressed: () => _viewCertificateDetails(i + 1),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 20,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const CertificateCard({
    required this.title,
    required this.description,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
