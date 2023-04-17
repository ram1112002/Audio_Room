import 'package:audio_call/HomePage.dart';
import 'package:audio_call/constants.dart';
import 'package:audio_call/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/src/components/message/in_room_live_commenting_view_item.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'dart:math' as math;

class AudioPage extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final LayoutMode layoutMode;
  String? email = FirebaseAuth.instance.currentUser?.email;

  AudioPage({Key? key, required this.roomID,this.layoutMode = LayoutMode.defaultLayout, this.isHost = false}) : super(key: key);
  final String localUserID = math.Random().nextInt(10000).toString();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: 943209581, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: "0bafccbcd2cf0493cfd78761474b6ec62a6421aacff3c078b17810085674aa27", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: localUserID,
        userName: 'user_'+ email!.substring(0,5),
        roomID: roomID,
        config: (isHost
            ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
          ..takeSeatIndexWhenJoining = isHost ? getHostSeatIndex() : -1
          ..background = Container(color: Colors.purple.shade100,)
          ..hostSeatIndexes = getLockSeatIndex()
          ..layoutConfig = getLayoutConfig()
          ..seatConfig = getSeatConfig()
          ..inRoomMessageViewConfig = getMessageViewConfig()

          ..onUserCountOrPropertyChanged = (List<ZegoUIKitUser> users) {
            debugPrint(
                'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}');
          }
          ..onSeatClosed = () {
            debugPrint('on seat closed');
          }
          ..onSeatsOpened = () {
            debugPrint('on seat opened');
          }
          ..onSeatsChanged = (
              Map<int, ZegoUIKitUser> takenSeats,
              List<int> untakenSeats,
              ) {
            debugPrint(
                'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats');
          }
          ..onSeatTakingRequested = (ZegoUIKitUser audience) {
            debugPrint(
                'on seat taking requested, audience:${audience.toString()}');
          }
          ..onSeatTakingRequestCanceled = (ZegoUIKitUser audience) {
            debugPrint(
                'on seat taking request canceled, audience:${audience.toString()}');
          }
          ..onInviteAudienceToTakeSeatFailed = () {
            debugPrint('on invite audience to take seat failed');
          }
          ..onSeatTakingInviteRejected = () {
            debugPrint('on seat taking invite rejected');
          }
          ..onSeatTakingRequestFailed = () {
            debugPrint('on seat taking request failed');
          }
          ..onSeatTakingRequestRejected = () {
            debugPrint('on seat taking request rejected');
          }
          ..onHostSeatTakingInviteSent = () {
            debugPrint('on host seat taking invite sent');
          }
          ..onLeaveLiveAudioRoom = (){
          navigatorKey.currentState!.popUntil((route) => route.isFirst);

          }
      ),
    );
  }
  ZegoLiveAudioRoomSeatConfig getSeatConfig() {
    if (layoutMode == LayoutMode.hostTopCenter) {
      return ZegoLiveAudioRoomSeatConfig(
        backgroundBuilder: (
            BuildContext context,
            Size size,
            ZegoUIKitUser? user,
            Map<String, dynamic> extraInfo,
            ) {
          return Container(color: Colors.black);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
      avatarBuilder: avatarBuilder,
    );
  }

  ZegoInRoomMessageViewConfig getMessageViewConfig() {
    return ZegoInRoomMessageViewConfig(itemBuilder: (
        BuildContext context,
        ZegoInRoomMessage message,
        Map<String, dynamic> extraInfo,
        ) {
      /// how to use itemBuilder to custom message view
      return Stack(
        children: [
          ZegoInRoomLiveCommentingViewItem(
            user: message.user,
            message: message.message,
          ),

          /// add a red point
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              width: 10,
              height: 10,
            ),
          ),
        ],
      );
    });
  }

  Widget avatarBuilder(
      BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map<String, dynamic> extraInfo,
      ) {
    return CircleAvatar(
      maxRadius: size.width,
      backgroundImage: Image.asset(
          "assets/avatars/avatar_${((int.tryParse(user?.id ?? "") ?? 0) % 6).toString()}.png")
          .image,
    );
  }

  int getHostSeatIndex() {
    if (layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  List<int> getLockSeatIndex() {
    if (layoutMode == LayoutMode.hostCenter) {
      return [4];
    }

    return [0];
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
    final config = ZegoLiveAudioRoomLayoutConfig();
    switch (layoutMode) {
      case LayoutMode.defaultLayout:
        break;
      case LayoutMode.full:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.hostTopCenter:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
          ),
        ];
        break;
      case LayoutMode.hostCenter:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.fourPeoples:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
    }
    return config;
  }

  void showDemoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Menu $index',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

