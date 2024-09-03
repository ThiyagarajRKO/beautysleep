import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phillips_hue/Controller/SpotifyController.dart';
// import 'package:phillips_hue/UI/SpotifyAutomationScreen.dart';
import 'package:phillips_hue/Utilis/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart' hide Image;

class SpotifyScreenView extends StatelessWidget {
  const SpotifyScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotifyScreenState();
  }
}

class SpotifyScreenState extends StatefulWidget {
  const SpotifyScreenState({super.key});

  @override
  State<StatefulWidget> createState() => SpotifyScreenStateView();
}

class SpotifyScreenStateView extends State<SpotifyScreenState> {
  bool isLoading = false;
  SpotifyApi? spotify;
  String? currentDeviceId = "";
  String? currentPlaylistId = "";
  bool isPlaying = false;
  PlaybackState? currentlyPlaying = PlaybackState();
  Future<List<dynamic>>? playlistsFuture; // Future variable

  final SpotifyController spotifyController = SpotifyController();

  @override
  void initState() {
    super.initState();
    if (spotify != null && currentDeviceId != "") {
      playlistsFuture = spotifyController.getPlaylists(spotify!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: spotify != null
            ? AppBar(
                title: const Text('Spotify Control'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.devices),
                    onPressed: () {
                      _showBottomModal(context);
                    },
                  ),
                ],
              )
            : null,
        body: Center(
          child: spotify == null
              ? isLoading
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : SizedBox(
                      width: 150.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            SpotifyApi? authenticatedSpotify =
                                await spotifyController
                                    .authenticateWithSpotify();

                            currentlyPlaying = await spotifyController
                                .currentlyPlayingTrack(authenticatedSpotify!);

                            setState(() {
                              spotify = authenticatedSpotify;
                              isPlaying =
                                  currentlyPlaying!.item == null ? false : true;
                              playlistsFuture = spotifyController
                                  .getPlaylists(spotify!); // Update future
                            });

                            _showBottomModal(context);
                          } catch (err) {
                            if (kDebugMode) {
                              print(err);
                            }
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.door_front_door),
                            SizedBox(width: 10),
                            Text(
                              "Sign In",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: renderPlaylist(context),
                      ),
                    ),
                    renderPlayStatus(context),
                  ],
                ),
        ),
        bottomNavigationBar: spotify == null || currentDeviceId == ""
            ? null
            : BottomAppBar(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 10),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: isLoading
                          ? null
                          : () async {
                              try {
                                if (currentDeviceId == "") {
                                  Fluttertoast.showToast(
                                    msg: "please choose the device first!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: AppTheme.appBlack,
                                    textColor: AppTheme.primaryColor,
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                currentlyPlaying = await spotifyController
                                    .previousTrack(spotify!, currentDeviceId);

                                setState(() {
                                  isPlaying = currentlyPlaying!.isPlaying!;
                                });
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    ),
                    const SizedBox(width: 30),
                    IconButton(
                      iconSize: 30,
                      icon: isLoading
                          ? const SizedBox(
                              width:
                                  20, // Width of the CircularProgressIndicator
                              height:
                                  20, // Height of the CircularProgressIndicator
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    3.0, // Optional: Adjust the thickness of the spinner
                              ),
                            )
                          : Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (currentDeviceId == "") {
                                Fluttertoast.showToast(
                                  msg: "please choose the device first!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: AppTheme.appBlack,
                                  textColor: AppTheme.primaryColor,
                                );
                                return;
                              }

                              PlaybackState? currentStatus;

                              if (!isPlaying) {
                                currentStatus = await spotifyController
                                    .resumeTrack(spotify!);
                                setState(() {
                                  isPlaying = currentStatus!.isPlaying!;
                                  currentlyPlaying = currentStatus;
                                });
                                return;
                              }

                              currentStatus =
                                  await spotifyController.pauseTrack(spotify!);
                              setState(() {
                                currentlyPlaying = currentStatus;
                                isPlaying = currentStatus!.isPlaying!;
                              });
                            },
                    ),
                    const SizedBox(width: 30),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.skip_next),
                      onPressed: isLoading
                          ? null
                          : () async {
                              try {
                                setState(() {
                                  isLoading = true;
                                });

                                if (currentDeviceId == "") {
                                  Fluttertoast.showToast(
                                    msg: "please choose the device first!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: AppTheme.appBlack,
                                    textColor: AppTheme.primaryColor,
                                  );
                                  return;
                                }

                                currentlyPlaying = await spotifyController
                                    .nextTrack(spotify!, currentDeviceId);

                                setState(() {
                                  isPlaying = currentlyPlaying!.isPlaying!;
                                });
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget renderPlaylist(BuildContext context) {
    if (spotify == null || currentDeviceId == "") {
      if (currentDeviceId == "") {
        return const Center(
            child: Text(
          'Please choose a device',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ));
      }
      return const Center(
          child: Text(
        'Spotify is not initialized',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ));
    }

    return FutureBuilder<List<dynamic>>(
      future: playlistsFuture, // Use the cached future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No playlists found'));
        }

        return _buildPlaylistGrid(snapshot.data!);
      },
    );
  }

  Widget _buildPlaylistGrid(List<dynamic> playlists) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // Maximum width of each item
        childAspectRatio: 0.8, // Aspect ratio for items
        mainAxisSpacing: 20, // Space between rows
        crossAxisSpacing: 5, // Space between columns
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = jsonDecode(playlists[index]);
        bool isSelected = currentPlaylistId == playlist['id'];

        return InkWell(
          onTap: () async {
            try {
              setState(() {
                currentPlaylistId = playlist['id'];
                isLoading = true;
              });

              currentlyPlaying = await spotifyController.playPlaylist(
                  spotify!, playlist['id'], currentDeviceId);

              setState(() {
                isPlaying = currentlyPlaying!.item == null ? false : true;
              });
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Card(
            color: isSelected ? Colors.yellow.shade100 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Softer rounded corners
              side: BorderSide(
                color: isSelected
                    ? Colors.yellow.shade100
                    : Colors.white, // Highlight on selection
                width: 5.0,
              ),
            ),
            elevation: 5, // Slightly higher elevation for a shadow effect
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(
                                12)), // Rounded corners for image
                        child: Image.network(
                          playlist['images'][0]['url'],
                          fit: BoxFit.cover, // Cover image for a better look
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.5), // Semi-transparent overlay
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 50,
                              color: Colors.white
                                  .withOpacity(0.8), // Semi-transparent icon
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Text(
                        playlist['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                      Text(
                        "Tracks : ${playlist['tracks']['total']}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2, // Limit to two lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget renderPlayStatus(BuildContext context) {
    return Column(children: [
      Visibility(
          visible: false,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_mode,
                        size: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Schedule",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
              ))),
      spotify != null && currentDeviceId != "" && currentlyPlaying?.item != null
          ? SizedBox(
              height: 98.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    )
                  ],
                ),
                padding: const EdgeInsets.only(
                    top: 18, bottom: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        child: currentlyPlaying!.item!.album!.images![0].url !=
                                null
                            ? Image.network(
                                currentlyPlaying!.item!.album!.images![0].url!)
                            : null,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentlyPlaying!.item!.name ?? 'Untitled',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(
                            currentlyPlaying!.item!.album!.name ?? 'Untitled',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            currentlyPlaying!.item!.artists![0].name ??
                                'Untitled',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'No tracks found!',
                style: TextStyle(color: Colors.black),
              ),
            )
    ]);
  }

  void _showBottomModal(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FutureBuilder<List<String>>(
          future: spotifyController.devices(spotify!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No devices found'));
            }

            final devices = snapshot.data!;

            return Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.only(top: 18, bottom: 10),
              child: Column(
                children: [
                  Text(
                    'Available Devices (${devices.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        var device = jsonDecode(devices[index]);
                        return ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text(
                            device['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });

                              // SharedPreferences localStorage =
                              //     await SharedPreferences.getInstance();

                              // await localStorage.setString(
                              //     "current_device_id", device['id']!);
                              // await localStorage.setString(
                              //     "current_device_name", device['name']!);

                              Navigator.pop(context);

                              PlaybackState? currentState;

                              if (currentDeviceId != "" && isPlaying) {
                                currentState = await spotifyController
                                    .transferPlayback(spotify!, device['id']);
                              } else {
                                currentState = await spotifyController
                                    .currentlyPlayingTrack(spotify!);
                              }

                              // if (currentState!.item == null) {
                              //   Fluttertoast.showToast(
                              //     msg:
                              //         "Please check the selected device status",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.BOTTOM,
                              //     backgroundColor: AppTheme.appBlack,
                              //     textColor: AppTheme.primaryColor,
                              //   );
                              //   return;
                              // }

                              setState(() {
                                currentlyPlaying = currentState;
                                currentDeviceId = device['id']!;
                                isPlaying = currentlyPlaying!.isPlaying == null
                                    ? false
                                    : currentlyPlaying!.isPlaying!;
                              });

                              Fluttertoast.showToast(
                                msg: "Selected ${device['name']} device",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: AppTheme.appBlack,
                                textColor: AppTheme.primaryColor,
                              );
                            } catch (err) {
                              print(err);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
