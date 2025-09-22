import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:intl/intl.dart';

class Certificate extends StatefulWidget {
  final List<CertificateMV> dataCertificates;
  final Function(int page) onTabSelected;
  Certificate({
    super.key,
    required this.dataCertificates,
    required this.onTabSelected,
  });

  @override
  _CertificateState createState() =>
      _CertificateState(dataCertificates, this.onTabSelected);
}

class _CertificateState extends State<Certificate> {
  final List<CertificateMV> dataCertificates;
  final Function(int page) onTabSelected;

  _CertificateState(this.dataCertificates, this.onTabSelected);

  void _viewCertificateAdd() {
    onTabSelected(10); // Navigate to add page
  }

  void _viewCertificateEdits(CertificateMV certificate) {
    onTabSelected(11); // Navigate to edit page
  }

  @override
  Widget build(BuildContext context) {
    int idx = 1;

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Certifications",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _viewCertificateAdd,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Icon/text color
                ),
                icon: Icon(Icons.add),
                label: Text("Add"),
              ),
            ],
          ),
          SizedBox(height: 20),
          for (var cert in dataCertificates) ...[
            CertificateCard(
              idx: idx++,
              title: cert.nama!,
              description: cert.publisher!,
              dateRange: (cert.expiredDate == null)
                  ? "${DateFormat('MMM yyyy').format(cert.publishDate ?? DateTime.now())} - Present"
                  : "${DateFormat('MMM yyyy').format(cert.publishDate ?? DateTime.now())} - ${DateFormat('MMM yyyy').format(cert.expiredDate ?? DateTime.now())}",
              onPressed: () => _viewCertificateEdits(cert),
            ),
            SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final int idx;
  final String title;
  final String description;
  final String dateRange;
  final VoidCallback onPressed;

  const CertificateCard({
    required this.idx,
    required this.title,
    required this.description,
    required this.dateRange,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  idx.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            Flexible(
              flex: 2,
              child: Text(
                softWrap: true,
                textAlign: TextAlign.center,
                dateRange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
