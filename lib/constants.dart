// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';

String OFFLINE_DOWNLOADED_SONG_LIST_KEY = 'offline_downloaded_songs';
String OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY = 'offline_downloaded_ebooks';
String DOWNLOADED_TRACK_JSON = 'downloaded_track_json';
String DEFAULT_EPUB_BACKGROUND_COLOR = 'epub_background_color';
String DEFAULT_EPUB_FONT_SIZE = 'epub_font_size';
String IS_USER_LOGGED_IN = 'user_logged_in_key';
String HAS_USER_VISITED_ONBOARDING_SCREEN = 'user_visited_onboarding_screen';
String CURRENTLY_PLAYING_ALBUM_MAP = "currently_playing_album";
String PLAYLIST_CURRENT_SONG_INDEX = "playlist_curent_song_index";
String PLAYLIST_CURRENT_SONG_DURATION = "playlist_curent_song_duration";
String SHOW_BOTTOM_MUSIC_CONTROLLER = "show_bottom_music_controller";

const Color scaffoldBackground = Color(0xfffff1e5);
const Color indicatorColor = Color(0xffff8f33);

const appBarGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xffff963f),
    Color(0xffff6316),
  ],
  // stops: [0.5, 1.0],
);

List<String> wallpaperImagesList = [
  'https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/baba-bholenath-with-cow-baba-bholenath-bhakti-thumbnail%20(1).jpg?alt=media&token=f3634454-616a-48ba-a499-f306300d8c3b',
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/bhakti-lord-shiva-lord-shiva-mahadev-devotional-thumbnail%20(1).jpg?alt=media&token=c6df687b-ec09-4d24-9020-e7d973262c00",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/dhyan-me-lin-vishnu-bhagwan-vishnu-bhagwan-bhakti-thumbnail%20(1).jpg?alt=media&token=d2915c99-18b6-48f0-8783-d839f4a4f51a",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/hanuman-bhakti-bajrangi-god-gods-hanuman-jee-jay-shree-ram-lord-pray-ram-thumbnail%20(1).jpg?alt=media&token=4a77db89-d649-4b35-9af1-675f02174eb9",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/hanuman-with-lord-ram-and-sita-hanuman-lord-ram-sita-bhakti-thumbnail%20(1).jpg?alt=media&token=605216fe-3c06-4f7a-be41-c169f5498c4e",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/jay-shri-ram-golden-art-work-lord-god-bhakti-thumbnail%20(1).jpg?alt=media&token=3a6beef0-203b-462f-bcf4-39752cd24198",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/lord-krishna-statue-lord-krishna-hindu-bhakti-devotional-god-thumbnail%20(1).jpg?alt=media&token=ff13a2b8-8f78-4de4-b019-72d8c9ae3aa7",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/lord-shiva-mahakal-bhakti-thumbnail%20(1).jpg?alt=media&token=55e2ccdb-b8bb-495d-8146-f92013342b39",
  "https://firebasestorage.googleapis.com/v0/b/religiousapp-e15d2.appspot.com/o/shree-ram-lord-rama-face-god-bhakti-thumbnail%20(1).jpg?alt=media&token=0086f8b4-6585-47a0-9cf0-949bdac568c1",
];
const List<Map<String, String>> categoryImages = [
  {
    'title': 'गुरु वाणी',
    'image': 'assets/figma/guruvani_logo.png',
    "routeName": AlbumScreen.routeName,
  },
  {
    'title': 'पुस्तकें',
    'image': 'assets/figma/pustak_logo.png',
    "routeName": EbookScreen.routeName,
  },
  {
    'title': 'यात्रा',
    'image': 'assets/figma/yatra_logo.png',
    "routeName": "",
  },
  {
    'title': 'पंचांग',
    'image': 'assets/figma/panchag_logo.png',
    "routeName": "",
  },
  {
    'title': 'कार्यक्रम ',
    'image': 'assets/figma/karyakram_logo.png',
    "routeName": "",
  },
  {
    'title': 'कलेंडर',
    'image': 'assets/figma/calander_logo.png',
    "routeName": "",
  },
];
List<Map<String, dynamic>> album = [
  {
    "name": "Shree ganesha",
    "thumbnail": "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
    "artistId": "6FHrfNsgSCcjOA6giiYy",
    "albumId": "1",
    "songList": [
      {
        "trackId": "asdf1",
        "albumId": "1",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Deva Shree Ganesha"
      },
      {
        "trackId": "asdf2",
        "albumId": "1",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Jai Ganesh Jai Ganesh Deva(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Jai Ganesh Jai Ganesh Deva"
      },
      {
        "trackId": "asdf3",
        "albumId": "1",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Morya(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Morya"
      },
      {
        "trackId": "asdf4",
        "albumId": "1",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Sukh Karta Dukh Harta(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Sukh Karta Dukh Harta"
      },
    ]
  },
  {
    "name": "ram ji bhajan",
    "thumbnail":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Framji.jpg?alt=media&token=a8936039-abfc-484b-aaa0-4a01a2ea9da6",
    "songList": [
      {
        "trackId": "asdf11",
        "albumId": "2",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Deva Shree Ganesha"
      },
      {
        "trackId": "asdf22",
        "albumId": "2",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Jai Ganesh Jai Ganesh Deva(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Jai Ganesh Jai Ganesh Deva"
      },
      {
        "trackId": "asdf33",
        "albumId": "2",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Morya(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Morya"
      },
      {
        "trackId": "asdf44",
        "albumId": "2",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Sukh Karta Dukh Harta(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Sukh Karta Dukh Harta"
      },
    ]
  },
  {
    "name": "shiv ji bhajan",
    "albumId": "3",
    "thumbnail":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fshivji.jpg?alt=media&token=757fcf36-0f71-4ad1-94aa-4dca6a3ced60",
    "songList": [
      {
        "trackId": "asdf1",
        "albumId": "3",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Deva Shree Ganesha"
      },
      {
        "trackId": "asdf2",
        "albumId": "3",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Jai Ganesh Jai Ganesh Deva(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Jai Ganesh Jai Ganesh Deva"
      },
      {
        "trackId": "asdf3",
        "albumId": "3",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Morya(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Morya"
      },
      {
        "trackId": "asdf4",
        "albumId": "3",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Sukh Karta Dukh Harta(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Sukh Karta Dukh Harta"
      },
    ]
  },
  {
    "name": "khatu shyam ji katha",
    "albumId": "4",
    "thumbnail":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fkhatushyamji.jpg?alt=media&token=5b2744d4-0052-42ca-85f8-f8be9792af56",
    "songList": [
      {
        "trackId": "asdf1",
        "albumId": "4",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Deva Shree Ganesha"
      },
      {
        "trackId": "asdf2",
        "albumId": "4",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Jai Ganesh Jai Ganesh Deva(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Jai Ganesh Jai Ganesh Deva"
      },
      {
        "trackId": "asdf3",
        "albumId": "4",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Morya(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Morya"
      },
      {
        "trackId": "asdf4",
        "albumId": "4",
        "artistId": "artistId",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Sukh Karta Dukh Harta(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Sukh Karta Dukh Harta"
      },
    ]
  },
];
List<Map<String, String>> bookLIst = [
  {
    "title": "book",
    "title_hi": '',
    "description": '',
    "author": '',
    "author_id": '',
    "url":
        'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Frangbhumi.epub?alt=media&token=b3a93b80-be8a-4ab2-a7bd-79f66ad3cee0',
    "file_type": 'ebook',
    "thumbnail_url":
        'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fthubbnail%2Fbookcover11.png?alt=media&token=70b8017c-63a0-4508-9328-a1a494d6cc64',
  },
  {
    "title": "Fasimov genetic effects of radiation",
    "title_hi": '',
    "description": '',
    "author": '',
    "author_id": '',
    "file_type": 'ebook',
    "thumbnail_url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fthubbnail%2Fbookcover11.png?alt=media&token=70b8017c-63a0-4508-9328-a1a494d6cc64",
    "url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fasimov-genetic-effects-of-radiation.epub?alt=media&token=e19b400a-4500-46d0-84c7-87030470c53d"
  },
  {
    "title": 'Book 2',
    "title_hi": '',
    "description": '',
    "author": '',
    "author_id": '',
    "file_type": 'ebook',
    "thumbnail_url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fthubbnail%2Fbookcover11.png?alt=media&token=70b8017c-63a0-4508-9328-a1a494d6cc64",
    "url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fbook_2.epub?alt=media&token=2f366789-5d6f-40d9-b89f-13de7a85f0fe"
  },
  {
    "title": 'book3',
    "title_hi": '',
    "description": '',
    "author": '',
    "author_id": '',
    "file_type": 'ebook',
    "thumbnail_url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fthubbnail%2Fbookcover11.png?alt=media&token=70b8017c-63a0-4508-9328-a1a494d6cc64",
    "url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fbook_3.epub?alt=media&token=e2fbb157-9c43-44cf-8493-662a873ce90b"
  },
  {
    "title": 'New Findings on Shirdi Sai Baba',
    "title_hi": '',
    "description": '',
    "author": '',
    "author_id": '',
    "file_type": 'ebook',
    "thumbnail_url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fthubbnail%2Fbookcover11.png?alt=media&token=70b8017c-63a0-4508-9328-a1a494d6cc64",
    "url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2FNew-Findings-on-Shirdi-Sai-Baba.epub?alt=media&token=c743b351-5ec3-4b83-bbb8-e05dbb70e39e"
  },
  {
    "title": 'Pdf',
    "title_hi": '',
    "description": '',
    "author": '',
    "author_id": '',
    "file_type": 'pdf',
    "thumbnail_url":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/ebooks%2Fthubbnail%2Fbookcover11.png?alt=media&token=70b8017c-63a0-4508-9328-a1a494d6cc64",
    "url": "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf"
  },
];
List<int> ebookBackgroundColorList = [
  0xffffffff,
  0xfffffcda,
  0xff464646,
  0xff000000,
];
