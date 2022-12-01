import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:platterwave/constant/post_type.dart';
import 'package:platterwave/model/vblog/post_model.dart';

class DynamicLink{


 static Future<String?> createLink(Post post)async{
    try{
      String url = "https://platterwiseapp.page.link";
      final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse('$url/${post.postId}'),
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
          title: post.contentPost,
          imageUrl: post.contentType==PostType.image?
                 Uri.parse(post.contentUrl)
              :post.contentType==PostType.text?
          Uri.parse("https://www.howardluksmd.com/wp-content/uploads/2021/10/featured-image-placeholder-728x404.jpg")
          : Uri.parse(post.contentType),
        ),
      );

      final dynamicLink = await dynamicLinkParams.buildShortLink();
      //print(dynamicLink.shortUrl);
      return dynamicLink.shortUrl.toString();
    }catch(e){
      print(e);
     //
    }
    return null;

  }
}