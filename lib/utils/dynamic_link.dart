import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink{


 static Future<String?> createLink(String id)async{
    try{
      String url = "https://platterwiseapp.page.link";
      final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('$url/$id'),
        uriPrefix: url,
        androidParameters:  AndroidParameters(
            packageName: "com.platterwise.net",
            minimumVersion: 0,
        ),
        iosParameters:  IosParameters(
            bundleId: "com.platterwise.net",
          minimumVersion: '0',
        ),
        googleAnalyticsParameters:  GoogleAnalyticsParameters(
          source: "twitter",
          medium: "social",
          campaign: "example-promo",
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "Post from platterwise",
          imageUrl: Uri.parse("https://www.howardluksmd.com/wp-content/uploads/2021/10/featured-image-placeholder-728x404.jpg"),
        ),
      );

      final dynamicLink = await dynamicLinkParams.buildShortLink();
      print(dynamicLink.shortUrl);
      return dynamicLink.shortUrl.toString();
    }catch(e){
      print(e);
     //
    }
    return null;

  }
}