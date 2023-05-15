import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../routes.dart';
import '../../models/artist.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({Key? key, required this.artist}) : super(key: key);
  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: Flex(
                    direction: Axis.vertical,
                    children:[
                      Flexible(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          child: Image.network(
                            artist.imgUrl,
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),]
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                artist.name,
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
