class KoreanParticleUtil {
  String addParticle(String word) {
    final lastChar = word.codeUnits.last;
    var hasJongSung = (lastChar - 44032) % 28 > 0;
    return hasJongSung ? '이' : '가';
  }
}
