// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  NewsModel({
    this.data,
  });

  List<Datum>? data;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.url,
    this.title,
    this.description,
    this.thumbnail,
    this.createdAt,
  });

  String? url;
  String? title;
  String? description;
  String? thumbnail;
  String? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        url: json["url"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "createdAt": createdAt,
      };
}
