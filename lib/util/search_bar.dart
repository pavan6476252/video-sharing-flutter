import 'package:flutter/material.dart';
import 'package:task/views/videos/search_screen.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            CircleAvatar(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoSearchScreen(),));
                    }, icon: Icon(Icons.search_outlined))),
            // PopupMenuButton<String>(
            //   itemBuilder: (BuildContext context) {
            //     return [
            //       const PopupMenuItem<String>(
            //         value: 'filter1',
            //         child: Text('Filter 1'),
            //       ),
            //       const PopupMenuItem<String>(
            //         value: 'filter2',
            //         child: Text('Filter 2'),
            //       ),
            //       const PopupMenuItem<String>(
            //         value: 'filter3',
            //         child: Text('Filter 3'),
            //       ),
            //     ];
            //   },
            //   onSelected: (String value) {},
            //   child: const CircleAvatar(child: Icon(Icons.filter_list)),
            // ),
          ],
        ),
      ),
    );
  }
}
