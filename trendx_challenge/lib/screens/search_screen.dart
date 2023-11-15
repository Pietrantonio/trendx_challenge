import 'package:flutter/material.dart';
import 'package:trendx_challenge/api/api.dart';
import 'package:trendx_challenge/colors.dart';
import 'package:trendx_challenge/models/movie.dart';
import 'package:trendx_challenge/screens/details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _search(String query) async {
    if (query.isEmpty) return;

    final results = await Api().searchMovies(query);

    results?.sort((a, b) {
      final releaseDateComparison = a.releaseDate.compareTo(b.releaseDate);
      if (releaseDateComparison != 0) {
        return releaseDateComparison;
      } else {
        return a.title.compareTo(b.title);
      }
    });

    setState(() {
      _searchResults = results!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do filme',
                labelStyle: const TextStyle(color: Colours.ratingColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colours.ratingColor,
                  ),
                ),
              ),
              cursorColor: Colours.ratingColor,
              onChanged: (value) => _search(value),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return GestureDetector(
                  child: ListTile(
                    title: Text('${movie.title} (${movie.releaseDate})'),
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
