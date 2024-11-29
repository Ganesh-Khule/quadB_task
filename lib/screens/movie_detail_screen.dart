import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieName;
  final String image;
  final String language;
  final String time;
  final String duration;
  final String rating;
  final String description;
  final String tag;

  const MovieDetailScreen(
      {super.key,
      required this.movieName,
      required this.image,
      required this.language,
      required this.time,
      required this.duration,
      required this.rating,
      required this.description, required this.tag});

  @override
  Widget build(BuildContext context) {
    final String des = extractingText(description);
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Detail Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: tag,
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage(image),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description :",
                    style: GoogleFonts.lato(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    des,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Watch Now"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String extractingText(String text) {
    final reg = RegExp(r'<[^>]*>', multiLine: true, dotAll: true);
    String org = text.replaceAll(reg, '');
    return org.trim().toString();
  }
}
