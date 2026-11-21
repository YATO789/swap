// アプリ全体で使う決まった値。

/// 日記の写真を選ぶときに縮める、長い辺の大きさ（px）。
/// 詳細の全画面表示で、iPhone の画面いっぱいに出してもぼやけない大きさ。
const double diaryPhotoMaxSide = 1440;

/// 日記の写真を選ぶときの JPEG の画質（0〜100）。1枚 200〜400KB ほどになる見込み。
/// PNG（スクリーンショットなど）には効かない。
const int diaryPhotoQuality = 80;

/// アイコンの画像を選ぶときに縮める、長い辺の大きさ（px）。
const double avatarImageMaxSide = 256;

/// アイコンの画像を選ぶときの JPEG の画質（0〜100）。
const int avatarImageQuality = 75;
