import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';

class Progressheader extends StatefulWidget {
  ValueChanged<String> onSearchChanged;
  VoidCallback onFilterTap;
  TextEditingController searchController;
  Progressheader({
    super.key,
    required this.searchController,
    required this.onFilterTap,
    required this.onSearchChanged,
  });

  @override
  State<Progressheader> createState() => _Progressheader();
}

class _Progressheader extends State<Progressheader> {
  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "Cari Candidate",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  onChanged: widget.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search candidates...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: widget.onFilterTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
