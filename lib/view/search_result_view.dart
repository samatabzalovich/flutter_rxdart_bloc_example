import 'package:flutter/material.dart';
import 'package:flutter_rxdart_example/bloc/search_result.dart';
import 'package:flutter_rxdart_example/models/animal.dart';
import 'package:flutter_rxdart_example/models/person.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({super.key, required this.stream});
  final Stream<SearchResult?> stream;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
      stream: stream,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final result = snapshot.data;
          if (result is SearchResultHasError) {
            return const Text('Got error');
          } else if (result is SearchResultLoading) {
            return const CircularProgressIndicator();
          } else if (result is SearchResultNoResult) {
            return const Text(
              'No results found for your search term. Try with another one!',
            );
          } else if (result is SearchResultWithResults) {
            final results = result.results;
            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final String title;
                  if (item is Animal) {
                    title = 'Animal';
                  } else if (item is Person) {
                    title = 'Person';
                  } else {
                    title = 'Unknown';
                  }
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(
                      item.toString(),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Text('Unknown state!');
          }
        }
        else {
          return const Text('Waiting');
        }
      },
    );
  }
}