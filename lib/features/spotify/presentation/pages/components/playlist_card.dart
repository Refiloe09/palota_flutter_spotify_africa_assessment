import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/mini_playlist.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../routes.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({Key? key, required this.playlist}) : super(key: key);
  final MiniPlaylist playlist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(AppRoutes.spotifyPlaylist,arguments: playlist);
      },
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: 380,
                child: Flex(
                  direction: Axis.vertical,
                  children:[
                    Flexible(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Image.network(
                        playlist.imgUrl,
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),]
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                playlist.name,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
