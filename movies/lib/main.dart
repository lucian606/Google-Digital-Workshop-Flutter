import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Movies(),
    );
  }
}

class Movies extends StatefulWidget {
  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final List<Movie> movies = <Movie>[];
  List<Movie> filteredMovies = <Movie>[];
  List<String> strings = <String>[];
  double ratingFilter = 0;
  String ratingTxt = "";
  int dropdownValue = 1;
  int dropdownAscending = 1;
  final numController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    Response response = await get('https://yts.mx/api/v2/list_movies.json');
    Map<String, dynamic> moviesJson = jsonDecode(response.body);
    Map<String, dynamic> listString = moviesJson["data"];
    final int totalMovies = listString["movie_count"];
    List<dynamic> movieJsonList = listString["movies"];
    int current_page = 1;
    int movies_added = 0;
    while (movies_added < totalMovies) {
      response = await get(
          'https://yts.mx/api/v2/list_movies.json?page=$current_page');
      moviesJson = jsonDecode(response.body);
      listString = moviesJson["data"];
      movieJsonList = listString["movies"];
      for (dynamic movieJson in movieJsonList) {
        setState(() {
          Movie movie = Movie.fromJson(movieJson);
          movies.add(movie);
          movies_added++;
        });
      }
      current_page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Movies')),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text("Show all movies"),
                onPressed: () {
                  setState(() {
                    filteredMovies = List.from(movies);
                    filteredMovies = filteredMovies.toSet().toList();
                  });
                },
              )),
          Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text("Show minimum rating"),
                  onPressed: () {
                    setState(() {
                      filteredMovies = List.from(movies);
                      filteredMovies = filteredMovies.toSet().toList();
                      filteredMovies = filteredMovies
                          .where((element) => element.rating >= ratingFilter)
                          .toList();
                    });
                  },
                )),
            Slider(
              min: 0,
              max: 10,
              value: ratingFilter,
              onChanged: (value) {
                setState(() {
                  ratingFilter = value;
                });
              },
            ),
            Text(ratingFilter.toStringAsFixed(1)),
          ]),
          Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ElevatedButton(
                  child: Text("Sort movies by"),
                  onPressed: () {
                    setState(() {
                      switch (dropdownValue) {
                        case 1:
                          {
                            filteredMovies
                                .sort((a, b) => a.title.compareTo(b.title));
                          }
                          break;
                        case 2:
                          {
                            filteredMovies
                                .sort((a, b) => a.year.compareTo(b.year));
                          }
                          break;
                        case 3:
                          {
                            filteredMovies
                                .sort((a, b) => a.rating.compareTo(b.rating));
                          }
                          break;
                      }

                      if (dropdownAscending == 2) {
                        filteredMovies = filteredMovies.reversed.toList();
                      }
                    });
                  },
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: DropdownButton(
                  value: dropdownValue,
                  items: [
                    DropdownMenuItem(
                      child: Text('By title'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('By release year'),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text('By rating'),
                      value: 3,
                    ),
                  ],
                  onChanged: (int newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                )),
            DropdownButton(
              value: dropdownAscending,
              items: [
                DropdownMenuItem(
                  child: Text('Ascending'),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text('Descending'),
                  value: 2,
                ),
              ],
              onChanged: (int newValue) {
                setState(() {
                  dropdownAscending = newValue;
                });
              },
            ),
          ]),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: filteredMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Expanded( child: InkWell(
                        onTap: () {
                          String descriptionTitle =
                              filteredMovies[index].title +
                                  ' - ' +
                                  filteredMovies[index].year.toString();
                          String description =
                              "Genres: " + filteredMovies[index].genresString();
                          description += '\n\n' + filteredMovies[index].summary;
                          AlertDialog alert = new AlertDialog(
                            title: Text(descriptionTitle),
                            content: Text(description),
                            actions: [
                              TextButton(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                          showDialog<AlertDialog>(context: context, builder: (BuildContext context) {
                            return alert;
                          });
                        },
                        child: Image.network(filteredMovies[index].imageLink,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                          return Text('Image not found');
                        }),
                      )),
                      Text(
                        filteredMovies[index].title +
                            '\n(' +
                            filteredMovies[index].year.toString() +
                            ')\n' +
                            filteredMovies[index].rating.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ]));
  }
}

class Movie {
  final String title;
  final int year;
  final double rating;
  final String imageLink;
  final List<dynamic> genres;
  final String summary;

  Movie(this.title, this.year, this.rating, this.imageLink, this.genres,
      this.summary);

  Movie.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        year = json['year'],
        rating = json['rating'].toDouble(),
        imageLink = json['medium_cover_image'],
        genres = json['genres'],
        summary = json['summary'];

  String genresString() {
    String res = "";
    for (dynamic genre in genres) {
      res += genre + ", ";
    }
    return res = res.substring(0, res.length - 2);
  }

  @override
  String toString() {
    return 'Movie{title: $title, year: $year, rating: $rating}';
  }
}
