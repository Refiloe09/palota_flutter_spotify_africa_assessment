import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/mini_playlist.dart';
import 'package:google_fonts/google_fonts.dart';


class PlaylistCard2 extends StatelessWidget {
  const PlaylistCard2({Key? key, required this.playlist}) : super(key: key);
  final MiniPlaylist playlist;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Flex(
                  direction: Axis.vertical,
                  children:[
                    Flexible(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: Image.network(
                          playlist.imgUrl,
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),]
              ),
            ),

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
    );

  }
}
