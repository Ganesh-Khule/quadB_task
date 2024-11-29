import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quadb_tech/classes/constants_variable.dart';
import 'package:quadb_tech/classes/list_item_class.dart';
import 'package:quadb_tech/classes/theme_provider_class.dart';
import 'package:http/http.dart' as http;
import 'package:quadb_tech/screens/movie_detail_screen.dart';
import 'package:quadb_tech/screens/scearch_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ListItem>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<ListItem>> fetchData() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return await getAllData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to load data. Please try again later."),
      ));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: ""
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            SwitchListTile(
              selected: false,
              title: const Text("Dark Mode"),
              value: Provider.of<ThemeProvider>(context, listen: true)
                  .isSelectedData,
              onChanged: (_) {
                Provider.of<ThemeProvider>(context, listen: false).isClicked();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search, size: 30),
          ),
        ],
      ),
      body: FutureBuilder<List<ListItem>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerLoading();
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return CustomItemTile(
                movieName: snapshot.data![index].movieName,
                image: snapshot.data![index].image,
                description: snapshot.data![index].description,
                language: snapshot.data![index].language,
                time: snapshot.data![index].time,
                duration: snapshot.data![index].length.toString(),
                rating: snapshot.data![index].rating,
              );
            },
          );
        },
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const LoadinContainers();
        },
      ),
    );
  }
}

class LoadinContainers extends StatelessWidget {
  const LoadinContainers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 150,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShimmerBox(200),
                  _buildShimmerBox(100),
                  _buildShimmerBox(100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerBox(100),
                      _buildShimmerBox(100),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width) {
    return Container(
      width: width,
      height: 20,
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(10)),
    );
  }
}

Future<List<ListItem>> getAllData() async {
  try {
    final response = await http.get(Uri.parse(fetchApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        return jsonData.map<ListItem>((showData) {
          final show = showData["show"];
          final image = show["image"]?["medium"] ?? defaultImage;
          final language = show["language"] ?? "Nothing";
          final time = show["premiered"] ?? "Nothing";
          final rating = show["rating"]?["average"]?.toString() ?? "0";
          final length = show["runtime"]?.toString() ?? "0";
          final description = show["summary"] ?? "Nothing";

          return ListItem(
            movieName: show["name"],
            image: image,
            language: language,
            time: time,
            description: description,
            rating: rating,
            length: int.tryParse(length) ?? 0,
          );
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    rethrow;
  }
}

class CustomItemTile extends StatelessWidget {
  final String movieName;
  final String image;
  final String language;
  final String time;
  final String duration;
  final String rating;
  final String description;

  const CustomItemTile({
    super.key,
    required this.movieName,
    required this.image,
    required this.language,
    required this.time,
    required this.duration,
    required this.rating,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(
              movieName: movieName,
              image: image,
              language: language,
              tag: "movie-${movieName.replaceAll(" ", "_")}",
              time: time,
              duration: duration,
              rating: rating,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 150,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Hero(
                tag: "movie-${movieName.replaceAll(" ", "_")}",
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(image)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      movieName,
                      style: GoogleFonts.lato(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Language : $language",
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Time : $time",
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Duration : $duration mins",
                          style: GoogleFonts.lato(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              "Rating : $rating",
                              style: GoogleFonts.lato(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
