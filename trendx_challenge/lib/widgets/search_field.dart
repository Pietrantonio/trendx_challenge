import 'package:flutter/material.dart';
import 'package:trendx_challenge/api/api.dart';
import 'package:trendx_challenge/models/movie.dart';
import 'package:trendx_challenge/screens/details_screen.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<Movie> _searchResults = [];

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = await Api().searchMovies(query);
    setState(() {
      _searchResults = results ?? [];
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    final results = await Api().searchMovies(query);

    // Sort the results by release date first (ascending order).
    results?.sort((a, b) {
      final releaseDateComparison = a.releaseDate.compareTo(b.releaseDate);
      if (releaseDateComparison != 0) {
        return releaseDateComparison; // Sort by release date.
      } else {
        return a.title.compareTo(
            b.title); // If release dates are the same, sort by title.
      }
    });

    // Update the state with the sorted results.
    setState(() {
      _searchResults = results!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          TextField(
            controller: widget._searchController,
            decoration: const InputDecoration(labelText: 'Search for movies'),
            onChanged: (value) => _performSearch(value),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return GestureDetector(
                  child: ListTile(
                    title: Text('${movie.title} ${(movie.releaseDate)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(movie: movie),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
