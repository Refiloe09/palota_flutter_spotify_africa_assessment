import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/artist.dart';
import '../../models/track.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({Key? key,required this.track}) : super(key: key);
  final Track track;

  //To be used to place comma separated artist list
  String _getArtistNames() {
    String names = '';
    for(Artist artist in track.artists!){
      names += artist.name;
      //append a comma if there is still more names
      if(artist != track.artists!.last) names += ', ';
    }
    if(names.isEmpty) names = 'Unknown Artist(s)';
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  track.imgUrl,
                  width: track.imgWidth,
                  height: track.imgHeight,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,10,0,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     ConstrainedBox(
                       constraints: BoxConstraints(maxWidth: 230),
                       child: Text(
                          track.name.trim(),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Flutter.white().color,
                          ),
                        ),
                     ),
                    const SizedBox(height: 5,),
                     ConstrainedBox(
                       constraints: BoxConstraints(maxWidth: 230),
                       child: Text(
                          _getArtistNames(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: const Flutter.white().color,
                          ),
                        ),
                     ),

                  ],
                ),
              ),
            ],
          ),
           Text(
                track.duration,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: const Flutter.white().color,
              ),
            ),

        ],
      ),

    );
  }
}
