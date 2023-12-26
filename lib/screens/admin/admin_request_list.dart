import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/request_list_page.dart';

import '../../widgets/filters_popup_widget.dart';

class AdminRequestList extends StatefulWidget {
  const AdminRequestList({super.key});

  @override
  State<AdminRequestList> createState() => _RequestListState();
}

class _RequestListState extends State<AdminRequestList> {
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = "";
  String _currentStatusFilter = "Pending";
  String _currentUrgencyFilter = "Low";

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _currentSearchQuery = newQuery;
    });
  }

  void _updateStatusFilter(String newStatus) {
    setState(() {
      _currentStatusFilter = newStatus;
    });
  }

  void _updateUrgencyFilter(String newUrgency) {
    setState(() {
      _currentUrgencyFilter = newUrgency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Separate column for back icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) {
                                    _updateSearchQuery(_searchController.text);
                                  },
                                  textInputAction: TextInputAction.search,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  _updateSearchQuery(_searchController.text);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterPopup(
                              onStatusFilterApplied: _updateStatusFilter,
                              onUrgencyFilterApplied: _updateUrgencyFilter,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Request Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: RequestListPage(
                  searchQuery: _currentSearchQuery,
                  statusFilter: _currentStatusFilter,
                  urgencyFilter: _currentUrgencyFilter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
