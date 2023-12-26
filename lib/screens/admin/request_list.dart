import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/filters_widget.dart';
import 'package:mym_raktaveer_frontend/widgets/request_list_page.dart';

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = "";

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _currentSearchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        return const FilterPopup();
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
            ),
          ),
        ],
      ),
    );
  }
}
