// ignore_for_file: non_constant_identifier_names

import 'package:temple_app/modals/album_model.dart';

String OFFLINE_DOWNLOADED_SONG_KEY = 'offline_downloaded_songs';
List<String> wallpaperImagesList = [
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/hanuman-with-lord-ram-and-sita-hanuman-lord-ram-sita-bhakti-thumbnail.jpg?alt=media&token=9154a6f0-d6bc-4ece-9e89-37d4c6ee4982',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/hanuman-bhakti-bajrangi-god-gods-hanuman-jee-jay-shree-ram-lord-pray-ram-thumbnail.jpg?alt=media&token=848120e1-cc50-4bee-b041-afb7398c0faf',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/dhyan-me-lin-vishnu-bhagwan-vishnu-bhagwan-bhakti-thumbnail.jpg?alt=media&token=6159fb68-ca9b-4fa7-96d8-966c059bf3ad',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhakti-lord-shiva-lord-shiva-mahadev-devotional-thumbnail.jpg?alt=media&token=4425dfec-e52d-4a9a-ab81-580eaae41b74',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/baba-bholenath-with-cow-baba-bholenath-bhakti-thumbnail.jpg?alt=media&token=88eb4b99-365e-41fe-b89a-3d20a16b7df0',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/jay-shri-ram-golden-art-work-lord-god-bhakti-thumbnail.jpg?alt=media&token=47109b88-401f-4317-85c3-1fc498254ee8',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/lord-krishna-statue-lord-krishna-hindu-bhakti-devotional-god-thumbnail.jpg?alt=media&token=d91e0d72-c9a2-49ed-8991-31bf794b8e9a',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/lord-shiva-mahakal-bhakti-thumbnail.jpg?alt=media&token=cb6d0a5a-b301-49de-b4ff-083d1d4741fd',
  'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/shree-ram-lord-rama-face-god-bhakti-thumbnail.jpg?alt=media&token=577e9817-772f-4dd1-b1f5-ebc710ed10bf'
];

List<Map<String, dynamic>> album = [
  {
    "name": "Shree ganesha",
    "thumbnail": "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
    "songList": [
      {
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Deva Shree Ganesha"
      },
      {
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Jai Ganesh Jai Ganesh Deva(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Jai Ganesh Jai Ganesh Deva"
      },
      {
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Morya(PagalWorld.com.se).mp3",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg",
        "songName": "Morya"
      },
      {
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
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
    ]
  },
  {
    "name": "shiv ji bhajan",
    "thumbnail":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fshivji.jpg?alt=media&token=757fcf36-0f71-4ad1-94aa-4dca6a3ced60",
    "songList": [
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
    ]
  },
  {
    "name": "khatu shyam ji katha",
    "thumbnail":
        "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fkhatushyamji.jpg?alt=media&token=5b2744d4-0052-42ca-85f8-f8be9792af56",
    "songList": [
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "songUrl":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/bhajans%2Fvideoplayback.weba?alt=media&token=f979535d-bbf5-4560-ae7f-dde5780de3a7",
        "songThumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
    ]
  },
];
