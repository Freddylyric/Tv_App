// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'model/streming_link.dart';
//
// Future<List<StreamingLink>> fetchStreamingLinks() async {
//   final response = await http.get(Uri.parse('https://iptv-org.github.io/api/streams.json'));
//   print(response.body);
//
//   if (response.statusCode == 200) {
//     final List<dynamic> json = jsonDecode(response.body);
//     final List<StreamingLink> streamingLinks = [];
//     final Map<String, dynamic> channels = {};
//
//     // First, fetch the channels and create a map of channel names to channel data
//     final channelsResponse = await http.get(Uri.parse('https://iptv-org.github.io/api/channels.json'));
//
//     if (channelsResponse.statusCode == 200) {
//       final List<dynamic> channelsJson = jsonDecode(channelsResponse.body);
//
//       for (var channel in channelsJson) {
//         if (channel['name'] != null) {
//           channels[channel['name']] = channel;
//         }
//       }
//     } else {
//       throw Exception('Failed to fetch channels');
//     }
//
//     // Next, create streaming links objects and add them to the list
//     for (var item in json) {
//       if (item['channel'] != null && item['url'] != null) {
//         final String channelName = item['channel'];
//
//         if (channels.containsKey(channelName)) {
//           final StreamingLink streamingLink = StreamingLink.fromJson(item);
//           streamingLink.channel = channels[channelName];
//           streamingLinks.add(streamingLink);
//         }
//       }
//     }
//
//     return streamingLinks;
//   } else {
//     throw Exception('Failed to fetch streaming links');
//   }
// }
