import 'package:foodrecipe/api/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      print(await KakaoSdk.origin);
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          print(e);
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<String?> getUserName() async {
    try {
      // 사용자 닉네임 가져오기
      User user = await UserApi.instance.me();
      return user.kakaoAccount?.profile?.nickname;
    } catch (error) {
      print('카카오 사용자 정보 가져오기 에러: $error');
      return null;
    }
  }
}