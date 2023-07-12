import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinks {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  static Future<Uri> createStoryDeepLink(String memberID, String purpose,
      String imageUrl, String description, String username) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "Story from $username",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link: Uri.parse("https://bebuzee.com/$purpose/$memberID/$username"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      // iosParameters: IOSParameters(
      //   bundleId: 'com.bebuzee',
      // ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    ;
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createProfileDeepLink(String memberID, String purpose,
      String imageUrl, String description, String username) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$username on Bebuzee: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link: Uri.parse("https://bebuzee.com/$purpose/$memberID/$username"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    ;
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createPostDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$username on Bebuzee: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();

    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    ;
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createPropberbuzPostDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$username on Bebuzee Properbuz: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    ;
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createBlogbuzzPostDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$description",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createShortbuzDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    print("dynamic link called");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$description: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    ;
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createVideoDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$username on Bebuzee: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    ;
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createHighlightDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID,
      String index) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "Highlight of $username on Bebuzee: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link: Uri.parse(
          "https://bebuzee.com/$purpose/$memberID/$username/$postID/$index"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createBlogDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$description ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createChannelDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String postID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$username's Channel on Bebuzee: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link:
          Uri.parse("https://bebuzee.com/$purpose/$memberID/$username/$postID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }

  static Future<Uri> createPlaylistDeepLink(
      String memberID,
      String purpose,
      String imageUrl,
      String description,
      String username,
      String playlistName,
      String playlistID) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
        description: description,
        imageUrl: Uri.parse(imageUrl),
        title: "$username's Playlist on Bebuzee: ",
      ),
      uriPrefix: 'https://bebuzee.page.link',
      link: Uri.parse(
          "https://bebuzee.com/$purpose/$memberID/$username/$playlistName/$playlistID"),
      androidParameters: AndroidParameters(
        packageName: 'com.bebuzee',
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.bebuzee',
      ),
    );

    // await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await dynamicLinks.buildShortLink(parameters);
    final Uri shortLink = shortDynamicLink.shortUrl;
    return shortLink;
  }
}
