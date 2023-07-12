import 'dart:async';
import 'dart:io';

import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/Properbuz/properbuz_comments_model.dart';
import 'package:bizbultest/models/Properbuz/properbuz_feeds_model.dart';
import 'package:bizbultest/models/Properbuz/url_metadata_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Properbuz/api/properbuz_feeds_api.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/view/Properbuz/detailed_feed_view.dart';
import 'package:bizbultest/view/Properbuz/edit_post_view.dart';
import 'package:bizbultest/widgets/Properbuz/utils/custom_bottom_sheets.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../Language/appLocalization.dart';
import 'comments_controller.dart';

class ProperbuzFeedController extends GetxController {
  final String? from;
  ProperbuzFeedController({Key? key, this.from});
  List<String> postTypes = ["image", "video", "multiple", "youtube", "bebuzee"];
  var page = 1.obs;
  var savedPostPage = 1.obs;
  RxInt selectIndex = 0.obs;
  var focusNode = FocusNode();
  var userPostPage = 1.obs;
  RxList<dynamic> tags = [].obs;
  var feeds = <ProperbuzFeedsModel>[].obs;
  var savedPosts = <ProperbuzFeedsModel>[].obs;
  var userPosts = <ProperbuzFeedsModel>[].obs;
  var singlePostList = <ProperbuzFeedsModel>[].obs;
  var videoFile = File("").obs;
  late Rx<VideoPlayerController> videoPlayerController;
  late FlickManager flickManager;
  var directUsersList = <DirectMessageUserListModel>[].obs;
  var mainDirectUsersList = <DirectMessageUserListModel>[].obs;
  var urlMetadata = UrlMetadataModel().obs;
  var isVideoPlaying = false.obs;
  var isPosting = false.obs;
  var isUpdating = false.obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RefreshController refreshControllerTags =
      RefreshController(initialRefresh: false);
  RefreshController refreshControllerSaved =
      RefreshController(initialRefresh: false);
  RefreshController refreshControllerUserPosts =
      RefreshController(initialRefresh: false);
  TextEditingController postController = TextEditingController();
  TextEditingController editPostController = TextEditingController();
  TextEditingController keywordController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController userSearchController = TextEditingController();
  TextEditingController directMessageController = TextEditingController();
  var comment = "".obs;
  ScrollController scrollController = ScrollController();
  var isEdit = false.obs;
  var isCommentEdit = false.obs;
  var isReply = false.obs;
  var isLoading = false.obs;
  var isCommenting = false.obs;
  var tagPage = 1.obs;
  var tagFeeds = <ProperbuzFeedsModel>[].obs;
  var selectedTag = "".obs;
  var selectedSort = "".obs;
  var isOneUserSelected = false.obs;
  var images = <File>[].obs;
  var testInt = 0.obs;
  var hasLink = false.obs;
  var postText = "".obs;
  var editPostText = "".obs;
  var url = "".obs;

  void scrollToTop() async {
    await Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    });
  }

  void getTagFeeds(String tag) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading.value = true;
      tagFeeds.clear();
      tagPage.value = 1;
      var feedsData = await ProperbuzFeedsAPI.getTagsFeeds(
          page.value, tag, selectedSort.value, keywordController.text);
      tagFeeds.value = feedsData;
      isLoading.value = false;
    });
  }

  void getSavedFeeds() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading.value = true;
      savedPosts.clear();
      savedPostPage.value = 1;
      var feedsData =
          await ProperbuzFeedsAPI.getSavedPosts(savedPostPage.value);
      savedPosts.assignAll(feedsData);
      isLoading.value = false;
    });
  }

  List<ProperbuzFeedsModel> getFeedsList(int val) {
    if (val == 1) {
      return feeds;
    } else if (val == 2) {
      return tagFeeds;
    } else if (val == 3) {
      return savedPosts;
    } else if (val == 4) {
      return userPosts;
    } else {
      return singlePostList;
    }
  }

  var editIndex = 0.obs;

  void uploadPost(int index, int val, BuildContext context) {
    if (isEdit.value) {
    } else {
      // uploadNewPost();
      if (File(videoFile.value.path).existsSync()) {
        print("video");
        uploadVideoPost(context);
      } else if (images.isEmpty) {
        uploadTextPost();
      } else {
        uploadImagePost(context);
      }
    }
  }

  void uploadImagePost(BuildContext context) async {
    isPosting.value = true;
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(new FocusNode());
    await ProperbuzFeedsAPI.uploadImagePostTest(postController.text, images);
    //  ProperbuzFeedsAPI.uploadImagePost(postController.text, images);
    isPosting.value = false;
    getFeeds();
    postController.clear();
    images.clear();
  }

  void uploadVideoPost(BuildContext context) async {
    isPosting.value = true;
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(new FocusNode());
    await ProperbuzFeedsAPI.uploadVideoPost(
        postController.text, videoFile.value.path);
    isPosting.value = false;
    getFeeds();
    postController.clear();
    videoFile.value = File("");
  }

  void uploadTextPost() async {
    print("upload text post");
    isPosting.value = true;
    await ProperbuzFeedsAPI.uploadTextPost(
        postController.text, hasLink.value, url.value);
    isPosting.value = false;
    if (hasLink.value) {
      hasLink.value = false;
      urlMetadata.value = UrlMetadataModel();
    }
    getFeeds();
    postController.clear();
  }

  void uploadNewPost() async {
    print('upload new post');
    isPosting.value = true;
    try {
      // await ProperbuzFeedsAPI.newPostFeeds(postController.text, images.value);
      await ProperbuzFeedsAPI.newPostTest(postController.text, images.value);
    } catch (e) {
      print("exception=$e");
    }
    isPosting.value = false;
    getFeeds();
    postController.clear();
  }

  List<String> countries = [
    "Afghanistan",
    "India",
    "United Kingdom",
    "Spain",
    "San Marino",
    "United Kingdom",
    "Australia",
    "Nigeria",
    "Argentina",
    "France",
    "World"
  ];

  @override
  void onInit() {
    debounce(postText, (_) {
      checkLink();
    }, time: Duration(milliseconds: 300));
    getTags();
    getFeeds();
    getUserDirectList();
    super.onInit();
  }

  void getTags() async {
    var tagsData = await ProperbuzFeedsAPI.getTagsList();
    tags.assignAll(tagsData);
  }

  Future<void> getFeeds() async {
    // feeds.value = [];
    page.value = 1;
    var feedsData = await ProperbuzFeedsAPI.getFeeds(page.value);
    feeds.value = (feedsData);
  }

  void getUserPosts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading.value = true;
      userPosts.clear();
      userPostPage.value = 1;
      var feedsData = await ProperbuzFeedsAPI.getUserPosts(userPostPage.value);
      userPosts.assignAll(feedsData);
      isLoading.value = false;
    });
  }

  void likeUnlike(int index, int val) {
    getFeedsList(val)[index].liked!.value =
        !getFeedsList(val)[index].liked!.value;
    ProperbuzFeedsAPI.likeUnlike(getFeedsList(val)[index].postId!)
        .then((value) {
      getFeedsList(val)[index].totalLike!.value = value;
    });
  }

  void saveUnsavePost(int index, int val) {
    Get.back();
    getFeedsList(val)[index].saved!.value =
        !getFeedsList(val)[index].saved!.value;
    Get.showSnackbar(
        properbuzSnackBar(saveMessage(getFeedsList(val)[index].saved!.value)));
    ProperbuzFeedsAPI.saveUnsave(getFeedsList(val)[index].postId!);
  }

  void deletePost(int index, int val, bool goBack, BuildContext context) {
    String postID = getFeedsList(val)[index].postId!;
    getFeedsList(val).removeAt(index);
    Get.back();
    if (goBack) {
      Timer(Duration(milliseconds: 500), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
        });
      });
    }
    Get.showSnackbar(properbuzSnackBar("Post deleted successfully"));
    ProperbuzFeedsAPI.deletePost(postID);
  }

  void updatePost(int val, int index, BuildContext context) async {
    isUpdating.value = true;
    String desc = await ProperbuzFeedsAPI.editPost(
        getFeedsList(val)[index].postId!, editPostController.text);
    getFeedsList(val)[index].description!.value = desc;
    isUpdating.value = false;
    getFeedsList(val)[index].description!.value = editPostController.text;
    // editPostController.clear();
    Navigator.pop(context, true);
  }

  void deletePopup(int index, int val, bool goBack, BuildContext context) {
    Get.back();
    Get.bottomSheet(
        CustomYesNoSheet(
          header: AppLocalizations.of("Confirm your action"),
          title:
              AppLocalizations.of("Are you sure you want to delete this post?"),
          yesButton: AppLocalizations.of("Delete"),
          noButton: AppLocalizations.of("Cancel"),
          onNo: () => Get.back(),
          onYes: () => deletePost(index, val, goBack, context),
        ),
        backgroundColor: Colors.white);
  }

  void unfollowPopup(int index, int val, bool goBack, BuildContext context) {
    Get.back();
    Get.bottomSheet(
        CustomYesNoSheet(
          header: AppLocalizations.of("Confirm your action"),
          title: AppLocalizations.of("Are you sure you want to unfollow") +
              " ${getFeedsList(val)[index].memberName}?",
          yesButton: AppLocalizations.of("Unfollow"),
          noButton: AppLocalizations.of("Cancel"),
          onNo: () => Get.back(),
          onYes: () {
            Get.back();
            Get.showSnackbar(properbuzSnackBar(
                AppLocalizations.of("Unfollowed") +
                    " ${getFeedsList(val)[index].memberName}"));
            if (goBack) {
              Timer(Duration(milliseconds: 500), () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
              });
            }
            print(getFeedsList(val)[index].memberId);
            ProperbuzFeedsAPI.unfollowUser(getFeedsList(val)[index].memberId!)
                .then((value) {
              getFeeds();
            });
          },
        ),
        backgroundColor: Colors.white);
  }

  Future<void> onTapEdit(int index, int val, BuildContext context) async {
    Get.back();
    editPostController.text = getFeedsList(val)[index].description!.value;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPostView(
                  index: index,
                  val: val,
                )));
  }

  String saveString(bool val) {
    if (val) {
      return AppLocalizations.of("Unsave this item from your saved list");
    } else {
      return AppLocalizations.of("Save this item for later");
    }
  }

  String saveMessage(bool val) {
    if (!val) {
      return AppLocalizations.of("Post unsaved from your list");
    } else {
      return AppLocalizations.of("Post saved to your list");
    }
  }

  IconData saveIcon(bool val) {
    if (val) {
      return CupertinoIcons.bookmark_fill;
    } else {
      return CupertinoIcons.bookmark;
    }
  }

  String likesString(int index, int val) {
    switch (getFeedsList(val)[index].totalLike!.value) {
      case 1:
        return AppLocalizations.of("Like");
        break;

      default:
        return AppLocalizations.of("Likes");
        break;
    }
  }

  String commentString(int index, int val) {
    switch (getFeedsList(val)[index].totalComment!.value) {
      case 1:
        return AppLocalizations.of("Comment");
        break;

      default:
        return AppLocalizations.of("Comments");
        break;
    }
  }

  void loadMoreData() async {
    page.value++;
    var feedData = await ProperbuzFeedsAPI.getFeeds(page.value);
    if (feedData != null) {
      feeds.addAll(feedData);
      refreshController.loadComplete();
    } else {
      refreshController.loadComplete();
    }
  }

  void refreshData() async {
    page.value = 1;
    var feedData = await ProperbuzFeedsAPI.getFeeds(page.value);
    if (feedData != null) {
      feeds.value = (feedData);
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshCompleted();
    }
  }

  void loadMoreDataTags(String tag) async {
    tagPage.value++;
    var feedData = await ProperbuzFeedsAPI.getTagsFeeds(
        tagPage.value, tag, "", keywordController.text);
    if (feedData != null) {
      tagFeeds.addAll(feedData);
      refreshControllerTags.loadComplete();
    } else {
      refreshControllerTags.loadComplete();
    }
    print("---------len-- ${tagFeeds.length}");
  }

  void refreshDataTags(String tag) async {
    tagPage.value = 1;
    var feedData = await ProperbuzFeedsAPI.getTagsFeeds(
        tagPage.value, tag, "", keywordController.text);
    if (feedData != null) {
      tagFeeds.assignAll(feedData);
      refreshControllerTags.refreshCompleted();
    } else {
      refreshControllerTags.refreshCompleted();
    }
  }

  void loadMoreDataSaved() async {
    savedPostPage.value++;
    var feedData = await ProperbuzFeedsAPI.getSavedPosts(savedPostPage.value);
    if (feedData != null) {
      savedPosts.addAll(feedData);
      refreshControllerSaved.loadComplete();
    } else {
      refreshControllerSaved.loadComplete();
    }
  }

  void refreshDataSaved() async {
    savedPostPage.value = 1;
    var feedData = await ProperbuzFeedsAPI.getSavedPosts(savedPostPage.value);
    if (feedData != null) {
      savedPosts.assignAll(feedData);
      refreshControllerSaved.refreshCompleted();
    } else {
      refreshControllerSaved.refreshCompleted();
    }
  }

  void refreshDataAlert() async {
    savedPostPage.value = 1;
    var feedData = await ProperbuzFeedsAPI.getSavedPosts(savedPostPage.value);
    if (feedData != null) {
      savedPosts.assignAll(feedData);
      refreshControllerSaved.refreshCompleted();
    } else {
      refreshControllerSaved.refreshCompleted();
    }
  }

  void loadMoreDataUserPosts() async {
    userPostPage.value++;
    var feedData = await ProperbuzFeedsAPI.getUserPosts(userPostPage.value);
    if (feedData != null) {
      userPosts.addAll(feedData);
      refreshControllerUserPosts.loadComplete();
    } else {
      refreshControllerUserPosts.loadComplete();
    }
  }

  void refreshDataUserPosts() async {
    userPostPage.value = 1;
    var feedData = await ProperbuzFeedsAPI.getUserPosts(userPostPage.value);
    if (feedData != null) {
      userPosts.assignAll(feedData);
      refreshControllerUserPosts.refreshCompleted();
    } else {
      refreshControllerUserPosts.refreshCompleted();
    }
  }

  void openYouTube(int index) async {
    String url = feeds[index].video!.videoUrl!;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String imagesString() {
    switch (images.length) {
      case 1:
        return AppLocalizations.of("Photo");
        break;
      default:
        return AppLocalizations.of("Photos");
        break;
    }
  }

  void pickImages() async {
    List<XFile> allFiles = await ImagePicker().pickMultiImage();
    allFiles.forEach((element) {
      images.add(File(element.path));
    });
  }

  void pickVideo() async {
    XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    videoFile.value = File(video!.path);
    flickManager = new FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.file(videoFile.value),
    );
  }

  void deleteImage(int index) {
    images.removeAt(index);
  }

  void navigateToComment(
      bool navigate, int index, int val, BuildContext context) async {
    if (navigate) {
      CommentsController commentsController = Get.put(CommentsController());
      commentsController.getUsers(getFeedsList(val)[index].postId!);
      commentsController.getComments(getFeedsList(val)[index].postId!);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedFeedView(
                    feedIndex: index,
                    val: val,
                  )));
    } else {
      await SystemChannels.textInput.invokeMethod('TextInput.show');
      FocusScope.of(context).nextFocus();
    }
  }

  void getUserDirectList() {
    print("getting list");
    DirectApiCalls.getDirectUserList().then((users) {
      directUsersList.assignAll(users.users);
      mainDirectUsersList.assignAll(users.users);
    });
  }

  void searchUsers(String name) {
    directUsersList.value = mainDirectUsersList
        .where((element) =>
            element.name.toString().toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  void selectUnSelectUser(int index) {
    directUsersList[index].selected!.value =
        !directUsersList[index].selected!.value;
    for (var element in directUsersList) {
      if (element.selected!.value) {
        isOneUserSelected.value = false;
        break;
      } else {
        isOneUserSelected.value = true;
      }
    }
    print(isOneUserSelected.value);
  }

  void unSelectAllUsers() {
    directUsersList.forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });
    isOneUserSelected.value = false;
  }

  void sendPostToDirect(String postID, BuildContext context) {
    List<String> members = [];
    directUsersList.forEach((element) {
      if (element.selected!.value) {
        members.add(element.fromuserid!);
      }
    });
    ProperbuzFeedsAPI.sendDirectMessage(
        postID, members.join(","), directMessageController.text);
    Navigator.pop(context);
    Timer(Duration(milliseconds: 500), () {
      unSelectAllUsers();
    });
  }

  void postComment(BuildContext context, val, index) async {
    if (comment.value.isNotEmpty) {
      isCommenting.value = true;
      String commentText = commentController.text;
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(new FocusNode());
      commentController.clear();
      comment.value = "";
      CommentsController controller = Get.put(CommentsController());
      if (isCommentEdit.value) {
        if (controller.isSubComment.value) {
          String comment = await ProperbuzFeedsAPI.editSubComment(
              controller.selectedSubCommentID.value, commentText);
          controller
              .commentsList[controller.selectedCommentIndex.value]
              .subComments![controller.selectedSubCommentIndex.value]
              .comment!
              .value = comment;
          isCommenting.value = false;
          isCommentEdit.value = false;
        } else {
          String comment = await ProperbuzFeedsAPI.editComment(
              controller.selectedCommentID.value, commentText);
          controller.commentsList[controller.selectedCommentIndex.value]
              .comment!.value = comment;
          isCommenting.value = false;
          isCommentEdit.value = false;
        }
      } else if (isReply.value) {
        SubComment subComment = await ProperbuzFeedsAPI.replyToComment(
            controller.selectedPostID.value,
            controller.selectedCommentID.value,
            commentText);

        print(controller.selectedCommentIndex.value.toString() + " value");
        controller
            .commentsList[controller.selectedCommentIndex.value].subComments!
            .insert(0, subComment);
        controller.commentsList[controller.selectedCommentIndex.value]
            .hasSubComments!.value = true;
        controller.commentsList[controller.selectedCommentIndex.value].replies!
            .value++;
        print(controller.commentsList[controller.selectedCommentIndex.value]
            .subComments![0].comment!.value);
        isCommenting.value = false;
        isReply.value = false;
      } else {
        int comments = await ProperbuzFeedsAPI.postComment(
            getFeedsList(val)[index].postId!, commentText);
        getFeedsList(val)[index].totalComment!.value = comments;
        isCommenting.value = false;
        controller.getComments(getFeedsList(val)[index].postId!);
      }
    } else {}
  }

  void openEmail(String email) async {
    final url = Uri.encodeFull('mailto:$email?subject=&body=');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sharePost(int index, int value) async {
    ProperbuzFeedsModel feed = ProperbuzFeedsModel();
    feed = getFeedsList(value)[index];
    Uri uri = await DeepLinks.createPropberbuzPostDeepLink(
        feed.memberId!,
        "properbuz_feed",
        feed.memberProfile!,
        feed.description!.value,
        feed.shortcode!,
        feed.postId!);
    Share.share(
      '${uri.toString()}',
    );
  }

  void checkLink() async {
    if (postText.value.toLowerCase().contains("https") && !hasLink.value) {
      //print("has link");
      var metadata = await ProperbuzFeedsAPI.getURLMetadata(url.value);
      urlMetadata.value = metadata;
      hasLink.value = true;
    } else {
      hasLink.value = false;
      //print("no link");
    }
  }
}
