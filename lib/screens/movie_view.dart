import 'package:flutter/material.dart';
import 'package:tmdb_movie_app_ui/models/actor_model.dart';
import 'package:tmdb_movie_app_ui/models/movie_details.dart';
import 'package:tmdb_movie_app_ui/models/movie_model.dart';
import 'package:tmdb_movie_app_ui/services/api_services.dart';

class MovieView extends StatefulWidget {
  const MovieView({super.key, required this.movie});
  final MovieModel movie;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: FutureBuilder(
          future: ApiServices().getMovieDetails(movie.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var movieDetails = snapshot.data;

              if (snapshot.hasData) {
                MovieDetailsModel data = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(movie.backdropPath!))),
                        child: const SafeArea(
                          child: Stack(
                            children: [
                              BackButton(
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title!,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data.tagline!,
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(movie.posterPath!))),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    data.overview!,
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Text("Genres",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    data.genres!.length,
                                    (index) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Chip(
                                              label: Text(
                                                  data.genres![index].name!)),
                                        )),
                              ),
                            ),
                            const Divider(),
                            Text("Production Companies",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.companies!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Image.network(
                                        data.companies![index].logo!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      title: Text(data.companies![index].name!),
                                    ),
                                  );
                                }),
                            const Divider(),
                            Text("Cast",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            FutureBuilder(
                                future:
                                    ApiServices().getActorDetails(movie.id!),
                                builder: (context, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (snap.hasData) {
                                    List<ActorModel> actors = snap.data!;
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5,
                                              childAspectRatio: 0.6,
                                              crossAxisCount: 2),
                                      itemCount: snap.data!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: size.width * 0.45,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.2),
                                                      BlendMode.darken),
                                                  image: NetworkImage(
                                                      actors[index].image!))),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  right: 5,
                                                  top: 5,
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          actors[index]
                                                              .popularity!
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 18,
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                              Positioned(
                                                bottom: 5,
                                                left: 5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      actors[index].name!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      actors[index].character!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return const Text("Something went wrong");
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            }
          }),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
