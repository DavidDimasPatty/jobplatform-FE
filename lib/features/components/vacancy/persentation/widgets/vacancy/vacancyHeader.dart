import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Vacancyheader extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final TextEditingController searchController;

  Vacancyheader({
    super.key,
    required this.searchController,
    required this.onFilterTap,
    required this.onSearchChanged,
  });

  @override
  State<Vacancyheader> createState() => _Vacancyheader();
}

class _Vacancyheader extends State<Vacancyheader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "Cari Candidate".tr(),
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
                    hintText: "Search candidates...".tr(),
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
