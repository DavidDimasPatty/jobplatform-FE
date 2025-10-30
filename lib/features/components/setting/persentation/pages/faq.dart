import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FAQ extends StatefulWidget {
  FAQ({Key? key}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQ> {
  int? expandedIndex;

  final List<Map<String, dynamic>> faqs = [
    {
      'question': 'What services are offered by this IT solution company?',
      'answer': '''
• Cybersecurity Services: Vulnerability Assessment & Pentesting and network security.
• Software Development: Web and mobile application development.
• IT Consulting & Managed Services: Planning, implementation, and maintenance of IT infrastructure.
• Data Analytics & AI Solutions: Business Intelligence, Machine Learning, and Big Data.
''',
    },
    {
      'question': 'How do we ensure the security of customer data?',
      'answer':
          'We implement encryption, regular audits, and strict access control policies to ensure your data remains protected at all times.',
    },
    {
      'question':
          'Can our IT security services be integrated with existing systems?',
      'answer':
          'Yes, our solutions are designed to be modular and easily integrate with your current business infrastructure.',
    },
    {
      'question': 'How long does it take to implement the service?',
      'answer':
          'Implementation time varies depending on project scope, typically ranging from 2 to 8 weeks.',
    },
    {
      'question': 'How do you get started with our services?',
      'answer':
          'Simply contact our team through the “Contact Us” page, and we’ll schedule a consultation to understand your needs.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ResponsiveRowColumn(
            layout: ResponsiveBreakpoints.of(context).isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(
                child: Column(
                  children: [
                    Text(
                      'FREQUENT ASKED QUESTIONS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),

                    ...List.generate(faqs.length, (index) {
                      final faq = faqs[index];
                      final isExpanded = expandedIndex == index;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expandedIndex = isExpanded ? null : index;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    faq['question'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.blueAccent,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),
                          Container(
                            height: 1,
                            color: Colors.blueAccent.withOpacity(0.2),
                          ),

                          if (isExpanded) ...[
                            SizedBox(height: 8),
                            Text(
                              faq['answer'],
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],

                          SizedBox(height: 20),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
