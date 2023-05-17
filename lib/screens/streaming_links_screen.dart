import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tv_app/model/channel.dart';
import 'package:tv_app/model/streming_link.dart';
import 'package:tv_app/network.dart';
import 'package:tv_app/screens/video_player_screen.dart';

class StreamingLinksScreen extends StatefulWidget {
  const StreamingLinksScreen({Key? key}) : super(key: key);

  @override
  _StreamingLinksScreenState createState() => _StreamingLinksScreenState();
}

class _StreamingLinksScreenState extends State<StreamingLinksScreen> {
  List<dynamic> _channels = [];
  List<Map<String, dynamic>> _countries = [];

  // final Map<String, List<dynamic>> _channelsByCategory = {};


  @override
  void initState() {
    super.initState();
    fetchChannels();
    fetchCountries();
  }

  Future<void> fetchChannels() async {
    final response = await http.get(
        Uri.parse('https://iptv-org.github.io/api/channels.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> filteredChannels = [];

      for (var channel in data) {
        final String name = channel['name'];
        final String country = channel['country'];
        final String id = channel['id'];
        // final List<String> categories = List<String>.from(channel['categories']);

        if (name != null && name.isNotEmpty &&
            country != null && country.isNotEmpty &&
            id != null && id.isNotEmpty)
          // categories.isNotEmpty)
            {
          final Map<String, dynamic> parsedChannel = {
            'name': name,
            'country': country,
            'id': id,
            // 'network': network,
            // 'categories': categories,
          };
          filteredChannels.add(parsedChannel);
        }
      }

      setState(() {
        _channels = filteredChannels;
      });
      print('Channels fetched: ${_channels.length}');
    } else {
      throw Exception('Failed to fetch channels');
    }
  }


  Future<void> fetchCountries() async {
    final response = await http.get(
        Uri.parse('https://iptv-org.github.io/api/countries.json'));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<Map<String, dynamic>> countries = [];

      for (var country in json) {
        final Map<String, dynamic> parsedCountry = {
          'name': country['name'],
          'code': country['code'],
          'languages': List<String>.from(country['languages']),
          'flag': country['flag'],
        };
        countries.add(parsedCountry);
      }

      setState(() {
        _countries = countries;
      });
      print('Countries fetched: ${_countries.length}');
    } else {
      throw Exception('Failed to fetch countries');
    }
  }


  List<dynamic>? _getChannelsByCountry(String country) {
    final countryCode = _countries
        .firstWhere(
          (c) => c['name'].toLowerCase() == country.toLowerCase(),
      orElse: () => {'code': ''},
    )['code'];

    if (countryCode == null) {
      print('none');
      return null;
    }

    final channels = _channels
        .where((channel) => channel['country'] == countryCode)
        .toList();
    if (channels.isEmpty) {
      print('none');
      return null;
    }

    print('sortfecth');
    return channels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming Links'),
      ),
      body: _channels.isNotEmpty && _countries.isNotEmpty
          ? ListView.builder(
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final country = _countries[index]['name'];
          final channels = _getChannelsByCountry(country);
          return ExpansionTile(
            title: Text(country),
            children: [
              if (channels != null)
                for (final channel in channels)
                  ListTile(
                    title: Text(channel['name']),
                    onTap: () async {
                      final streamingLink = await fetchStreamingLink(channel['id']);
                      if (streamingLink != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              url: streamingLink,
                              channel: channel['name'],
                            ),
                          ),
                        );
                      }
                    },



                  )
            ],
          );
        },
      )
          : const Center(

        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<String?> fetchStreamingLink(String channelName) async {
    try {
      final response = await http.get(
        Uri.parse('https://iptv-org.github.io/api/streams.json'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final streamingLink = data.firstWhere((stream) => stream['channel'] == channelName);
        return streamingLink['url'];
      } else {
        throw Exception('Failed to fetch streaming link');
      }
    } on SocketException catch (e) {
      // Channel's streaming link is not found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Channel Under Maintenance'),
          content: Text('The channel you selected is currently under maintenance.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    return null;
  }




}
