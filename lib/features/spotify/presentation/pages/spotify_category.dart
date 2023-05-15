import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/services/api_access.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/mini_playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/category.dart'
    as spotify_category;

import 'components/playlist_card.dart';

// TODO: fetch and populate playlist info and allow for click-through to detail

class SpotifyCategory extends StatefulWidget {
  const SpotifyCategory({Key? key, required this.categoryId}) : super(key: key);
  final String categoryId;

  @override
  State<SpotifyCategory> createState() => _SpotifyCategoryState();
}

class _SpotifyCategoryState extends State<SpotifyCategory>
    with AutomaticKeepAliveClientMixin {
  final APIClient _apiClient = APIClient();
  bool _fetching = false;
  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();
  List<MiniPlaylist> _playlists = [
    MiniPlaylist(id: 'id', name: 'Loading...', imgUrl: 'https://i.scdn.co/image/ab67706f00000003740df3771d19c09eebf4ed78')
  ];
  spotify_category.Category _category = spotify_category.Category(
      name: 'Loading...',
      imgUrl: 'https://t.scdn.co/images/b505b01bbe0e490cbe43b07f16212892.jpeg');

  ///Use the _apiClient to retrieve the objects for the UI elements
  void _getPlaylists() async {
    if (kDebugMode) print(widget.categoryId);
    //trigger loading animation
    setState(() {
      _fetching = true;
    });
    spotify_category.Category? tmpCat =
        await _apiClient.getCategory(widget.categoryId);
    setState(() {
      _category = tmpCat!;
    });
    List<MiniPlaylist> tmpPlaylist =
        await _apiClient.getMiniPlaylists(widget.categoryId);
    setState(() {
      _playlists = tmpPlaylist;
      _fetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.about),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.blue,
                AppColors.cyan,
                AppColors.green,
              ],
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _fetching,
        progressIndicator: SpinKitWaveSpinner(
          color: const Spotify.green().color,
        ),
        child: Scrollbar(
          controller: _controllerOne,
          child: SingleChildScrollView(
            controller: _controllerOne,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Spotify.black().color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14)),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Image.network(
                                    _category.imgUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _category.name,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: const Flutter.white().color,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Playlists',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: const Flutter.white().color,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                           _getSimpleGrid()
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  GridView _getSimpleGrid(){
    return GridView.builder(
        controller: _controllerOne,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          childAspectRatio: 0.8,

        ),
        itemCount: _playlists.length,
        itemBuilder: (BuildContext context, int index){
          return PlaylistCard(playlist: _playlists[index]);
        }
    );
  }


}
