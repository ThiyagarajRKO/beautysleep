import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phillips_hue/Utilis/AppUtility.dart';
import 'package:phillips_hue/Utilis/theme.dart';
import 'package:phillips_hue/api_config/ApiUrl.dart';
import 'package:spotify/spotify.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _scopes = [
  AuthorizationScope.playlist.modifyPrivate,
  AuthorizationScope.playlist.modifyPublic,
  AuthorizationScope.library.read,
  AuthorizationScope.library.modify,
  AuthorizationScope.connect.readPlaybackState,
  AuthorizationScope.connect.modifyPlaybackState,
  AuthorizationScope.listen.readRecentlyPlayed,
  AuthorizationScope.follow.read,
  AuthorizationScope.user.readEmail,
];

class SpotifyController {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Uuid _uuid = const Uuid();

  Future<String> _getDeviceId() async {
    String deviceId;
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await _deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!;
    } else {
      deviceId = 'unsupported_platform';
    }

    print('deviceId: $deviceId');
    return deviceId;
  }

  Future<String> saveDeviceId() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    String deviceId = await _getDeviceId();
    String uuid = _uuid.v4();
    String uniqueDeviceId = '$deviceId-$uuid';

    print("uniqueDeviceId: $uniqueDeviceId");

    await localStorage.setString('deviceId', uniqueDeviceId);

    return uniqueDeviceId;
  }

  Future<String?> getDeviceId() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      String? deviceId = localStorage.getString('deviceId');

      if (deviceId == null) {
        deviceId = await saveDeviceId();
        print('-----------------------------------------$deviceId');
      }

      return deviceId;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }

      return null;
    }
  }

  Future<List<String>> devices(SpotifyApi spotify) async {
    try {
      Iterable<Device> devices = await spotify.player.devices();
      if (devices.isEmpty) {
        if (kDebugMode) {
          print('No devices currently playing.');
        }
        return [];
      }

      if (kDebugMode) {
        print('Listing ${devices.length} available devices:');
        print(devices
            .map((device) => {
                  'name': device.name,
                  'id': device.id,
                })
            .join(', '));
      }

      // return devices
      //     .map((device) => {'name': device.name, id: device.id})
      //     .toList();

      // Ensure that each name is non-null
      return devices
          .map((device) => jsonEncode({'name': device.name, 'id': device.id}))
          .toList();
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }
      return []; // Return an empty iterable in case of an error
    }
  }

  Future<List<String>> getPlaylists(SpotifyApi spotify) async {
    try {
      Iterable<PlaylistSimple> playlists = await spotify.playlists.me.all(10);
      if (playlists.isEmpty) {
        if (kDebugMode) {
          print('No playlist available!');
        }
        return [];
      }

      if (kDebugMode) {
        print('Listing ${playlists.length} available platlist:');
        print(playlists);
      }

      // return devices
      //     .map((device) => {'name': device.name, id: device.id})
      //     .toList();

      // Ensure that each name is non-null
      return playlists.map((playlist) => jsonEncode(playlist)).toList();
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }
      return []; // Return an empty iterable in case of an error
    }
  }

  Future<PlaybackState> currentlyPlayingTrack(SpotifyApi spotify) async {
    try {
      PlaybackState? currentlyPlaying = await spotify.player.currentlyPlaying();

      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentlyPlaying; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }

      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      return PlaybackState(); // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> transferPlayback(
      SpotifyApi spotify, String deviceId) async {
    try {
      await spotify.player.transfer(deviceId, true, true);

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);

      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }

      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      return PlaybackState(); // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> resumeTrack(SpotifyApi spotify) async {
    try {
      await spotify.player.resume();

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);

      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }

      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      return PlaybackState(); // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> pauseTrack(SpotifyApi spotify) async {
    try {
      await spotify.player.pause();

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);

      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }

      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      return PlaybackState(); // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> previousTrack(
      SpotifyApi spotify, String? deviceId) async {
    try {
      await spotify.player
          .previous(deviceId: deviceId, retrievePlaybackState: true);

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);

      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }

      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      return PlaybackState(); // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> nextTrack(SpotifyApi spotify, String? deviceId) async {
    try {
      await spotify.player
          .next(deviceId: deviceId, retrievePlaybackState: true);

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);
      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }

      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      return PlaybackState(); // Replace with a valid default constructor or instance
    }
  }

  Future<Pages<Track>?> getPlaylistTracks(
      SpotifyApi spotify, String? playlistId) async {
    try {
      Pages<Track> track = spotify.playlists.getTracksByPlaylistId(playlistId);

      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return track; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }
      return null;
      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      // return []; // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> playTracks(SpotifyApi spotify, String? trackId) async {
    try {
      await spotify.player.startWithTracks(['spotify:track:$trackId']);

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);
      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }
      return null;
      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      // return []; // Replace with a valid default constructor or instance
    }
  }

  Future<PlaybackState?> playPlaylist(
      SpotifyApi spotify, String? playslistId, String? deviceId) async {
    try {
      await spotify.player.startWithContext('spotify:playlist:$playslistId',
          deviceId: deviceId, retrievePlaybackState: true);

      spotify.player.repeat(RepeatState.context,
          deviceId: deviceId, retrievePlaybackState: true);

      PlaybackState? currentStatus = await currentlyPlayingTrack(spotify);
      // If `currentlyPlaying` is null, return a default `PlaybackState` object.
      return currentStatus; // Replace with a valid default constructor or instance
    } catch (err) {
      if (kDebugMode) {
        print('Error: $err');
      }
      return null;
      // You need to handle the case when an error occurs
      // Optionally, you can return a default value or throw an exception
      // return []; // Replace with a valid default constructor or instance
    }
  }

  Future<User> getUser(SpotifyApi spotify) async {
    try {
      User user = await spotify.me.get();

      return user;
    } catch (e) {
      return User(); // Return null in case of failure
    }
  }

  Future<SpotifyApi?> authenticateWithSpotify() async {
    try {
      StreamSubscription<String?>? linksStream;

      // Step 2: Create Spotify API credentials and grant
      var credentials = SpotifyApiCredentials(
          AppUtility.spotifyClientId, AppUtility.spotifyClientSecret);
      var grant = SpotifyApi.authorizationCodeGrant(credentials);
      const redirectUri = 'philips://auth';

      // Step 3: Generate authorization URL
      // var authURI = grant.getAuthorizationUrl(Uri.parse(redirectUri),
      //     scopes: _scopes, state: deviceId);

      final authUri = grant.getAuthorizationUrl(
        Uri.parse(redirectUri),
        scopes: _scopes,
      );

      // final initialLink = await getInitialLink();
      // print('Initial link: $initialLink');
      final responseUriCompleter = Completer<String>();

      linksStream = linkStream.listen((String? link) {
        if (link != null && link.startsWith(redirectUri)) {
          responseUriCompleter.complete(link);
        }
      });

      // Step 4: Launch the authorization URL in the browser
      if (!await launchUrl(authUri)) {
        throw Exception('Could not launch $authUri');
      }

      String responseUri = await responseUriCompleter.future;

      if (responseUri.contains('error')) {
        return null;
      }

      SpotifyApi spotify = SpotifyApi.fromAuthCodeGrant(grant, responseUri);
      await linksStream.cancel();

      // SpotifyApiCredentials spotifyApiCredentials =
      //     await spotify.getCredentials();

      // User user = await spotify.me.get();

      // await updateAccessToken(deviceId!, spotifyApiCredentials.accessToken,
      //     spotifyApiCredentials.refreshToken, user.email);

      // if (kDebugMode) {
      //   print("Device ID : $deviceId");
      //   print("Access Token : ${spotifyApiCredentials.accessToken}");
      //   print("Refresh Token : ${spotifyApiCredentials.refreshToken}");
      //   print("User Email : ${user.email}");
      // }

      // await localStorage.setString(
      //     'accessToken', spotifyApiCredentials.accessToken!);

      return spotify;
    } catch (e) {
      // Step 7: Handle errors
      if (kDebugMode) {
        print('Authorization failed: $e');
      }
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.appBlack,
        textColor: AppTheme.primaryColor,
      );
      return null; // Return null in case of failure
    }
  }
}
