import 'package:flutter/material.dart';
import 'package:flutter_brand_palettes/flutter_brand_palettes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/common_functions.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/models/mini_playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/pages/components/playlist_card2.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/presentation/pages/components/track_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../colors.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../services/api_access.dart';
import 'components/artist_card.dart';
import 'components/playlist_card.dart';

class SpotifyPlaylist extends StatefulWidget {
  const SpotifyPlaylist({Key? key, required this.playlist}) : super(key: key);
  final MiniPlaylist playlist;

  @override
  State<SpotifyPlaylist> createState() => _SpotifyPlaylistState();
}

class _SpotifyPlaylistState extends State<SpotifyPlaylist> with AutomaticKeepAliveClientMixin{

  final APIClient _apiClient = APIClient();
  bool _fetching = false;
  bool _search = false;
  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();
  final TextEditingController editingController = TextEditingController();
  List<Track> _tracks = [];

  Playlist _playlist = Playlist(
      id: '37i9dQZF1DX6036iaZ2MYP',
      name: 'Loading',
      description: 'Loading',
      imgUrl: 'https://i.scdn.co/image/ab67706f00000003740df3771d19c09eebf4ed78',
      owner: 'Loading',
      followers: 0
  );

  ///Use the _apiClient to retrieve the objects for the UI elements
  void _getPlaylist() async{
    //trigger loading animation
    setState(() {
      _fetching = true;
    });
    Playlist? tmpCat = await _apiClient.getPlaylist(widget.playlist.id);
    setState(() {
      _playlist = tmpCat!;
      _cleanFeaturedArtists();
      _tracks = _playlist.tracks!;
      _fetching = false;
    });

  }

  ///used as temporary place holder while we fetch the tracks and artists
  void _setEmptyLists(){
    List<Track> ts = [];
    List<Artist> as = [];
    _playlist.setTracks = ts;
    _playlist.setFeaturedArtists = as;
  }

  /// Some artists do not have an image to render, in this case we want to remove such.
  /// There is no default image to render as network image so we need to clean the UI
  void _cleanFeaturedArtists(){
    setState(() {
      _playlist.featuredArtists!.removeWhere((element) => element.imgUrl.isEmpty);
    });
  }

  ///bonus
  void filterSearchResults(String query){
    setState(() {
      _tracks = _playlist.tracks!.where((track) => track.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _setEmptyLists();
    _getPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: const Flutter.white().color,
            ),
            title: !_search ? null : _searchTextField(),
            actions: !_search
                ? [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _search = true;
                    });
                  })
            ]
                : [
              IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _search = false;
                      _tracks = _playlist.tracks!;
                    });
                  }
              )
            ],
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
                    children:[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //playlist art
                               PlaylistCard2(playlist: widget.playlist),
                              const SizedBox(height: 8,),
                              //playlist description
                              Text(
                                stripHTML(stripUrl(_playlist.description)),
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Flutter.white().color,
                                ),
                              ),
                              const SizedBox(height: 8,),
                              //followers
                              Padding(
                               padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: const Spotify.black().color,
                                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${formatThousands(_playlist.followers)} Followers',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Flutter.white().color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              //horizontal gradient line
                              Container(
                                height: 3,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                              const SizedBox(height: 8,),
                              //track tiles
                              ListView.builder(
                                shrinkWrap: true,
                                  controller: _controllerOne,
                                  itemCount: _tracks.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return TrackCard(track: _tracks[index]);
                                  }
                              ),
                              const SizedBox(height: 12,),
                              Padding(
                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/2),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: const Spotify.black().color,
                                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Featured Artists',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Flutter.white().color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              // ArtistCard(artist: _playlist.featuredArtists![0]),
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    reverse: false,
                                    scrollDirection: Axis.horizontal,
                                    controller: _controllerTwo,
                                    itemCount: _playlist.featuredArtists!.length,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index){
                                      return ArtistCard(artist: _playlist.featuredArtists![index]);
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]
                ),
              ),
            ),
          ),
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _searchTextField() {
    return TextField(
      onChanged: (value){
        filterSearchResults(value);
      },
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: const Flutter.white().color,
      style: TextStyle(
        color: const Flutter.white().color,
        fontSize: 16,
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration( //Style of TextField
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle( //Style of hintText
          color: const Flutter.white().color,
          fontSize: 16,
        ),
      ),
    );
  }
}

