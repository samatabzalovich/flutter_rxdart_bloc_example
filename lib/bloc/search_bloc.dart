import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_rxdart_example/bloc/api.dart';
import 'package:flutter_rxdart_example/bloc/search_result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;
  void dispose() {
    search.close();
  }

  factory SearchBloc(Api api) {
    final textChanges = BehaviorSubject<String>();
    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((searchTerm) {
      if (searchTerm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(milliseconds: 1000))
            .map((event) => event.isEmpty
                ? const SearchResultNoResult()
                : SearchResultWithResults(event))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
      }
    });
    return SearchBloc._(
      search: textChanges.sink,
      results: results,
    );
  }
  const SearchBloc._({
    required this.search,
    required this.results,
  });
}
