import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swap/presentations/components/user_avatar.dart';

import '../../helpers/pump_app.dart';

void main() {
  Finder inAvatar(Finder matching) {
    return find.descendant(of: find.byType(UserAvatar), matching: matching);
  }

  testWidgets('画像がなければシルエットを出す', (tester) async {
    await tester.pumpApp(const UserAvatar());

    expect(inAvatar(find.byType(CustomPaint)), findsOneWidget);
    expect(inAvatar(find.byType(CachedNetworkImage)), findsNothing);
  });

  testWidgets('URL があれば、その画像を出す', (tester) async {
    await tester.pumpApp(
      const UserAvatar(imageUrl: 'https://example.com/avatar.jpg'),
    );

    final image = tester.widget<CachedNetworkImage>(
      inAvatar(find.byType(CachedNetworkImage)),
    );
    expect(image.imageUrl, 'https://example.com/avatar.jpg');
  });

  testWidgets('選んだばかりの画像は URL より優先して出す', (tester) async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    await tester.pumpApp(
      UserAvatar(imageUrl: 'https://example.com/avatar.jpg', imageBytes: bytes),
    );

    final image = tester.widget<Image>(inAvatar(find.byType(Image)));
    expect((image.image as MemoryImage).bytes, bytes);
    expect(inAvatar(find.byType(CachedNetworkImage)), findsNothing);
  });
}
