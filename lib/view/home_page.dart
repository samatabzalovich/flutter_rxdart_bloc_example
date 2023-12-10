import 'package:flutter/material.dart';
import 'package:flutter_rxdart_example/bloc/api.dart';
import 'package:flutter_rxdart_example/bloc/search_bloc.dart';
import 'package:flutter_rxdart_example/view/search_result_view.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(Api());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your search term here...',
              ),
              onChanged: _bloc.search.add,
            ),
            const SizedBox(
              height: 10,
            ),
            SearchResultView(
              stream: _bloc.results,
            ),
          ],
        ),
      ),
    );
  }
}