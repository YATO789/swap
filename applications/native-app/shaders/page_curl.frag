#version 460 core

// ページを、縦の折れ目から右側を筒に巻き付けるように丸めて描く。
//
// 折れ目より左は平らな表。折れ目から半径 uRadius の筒に沿って巻き上がり、
// 半周したところから先は裏返って、折れ目の左へ平らに重なる。
// 丸まって空いたところには、下のページに落ちる影だけを描く。

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
// 折れ目の x。ページの幅のときは丸まっておらず、-uRadius でめくれきる。
uniform float uFold;
uniform float uRadius;
// 裏の紙の色。
uniform vec4 uPaper;
// 下のページに落とす影の濃さ。
uniform float uShadow;
uniform sampler2D uImage;

out vec4 fragColor;

const float PI = 3.14159265;

vec4 front(float x, float y, float light) {
  vec4 color = texture(uImage, vec2(x, y) / uSize);
  return vec4(color.rgb * light, color.a);
}

// 裏は紙の色に、表の中身が左右反転でうっすら透ける。
vec4 back(float x, float y, float light) {
  vec4 color = texture(uImage, vec2(x, y) / uSize);
  return vec4(mix(uPaper.rgb, color.rgb, 0.12) * light, 1.0);
}

// 筒の右端から離れるほど薄くなる影。
vec4 shadow(float x) {
  float edge = min(uFold + uRadius, uSize.x);
  float alpha = 0.22 * uShadow * (1.0 - smoothstep(0.0, uRadius, x - edge));
  return vec4(0.0, 0.0, 0.0, alpha);
}

void main() {
  vec2 p = FlutterFragCoord().xy;
  float width = uSize.x;
  float d = p.x - uFold;

  if (d < 0.0) {
    // 折れ目より左。半周して裏返った部分が上に重なっていれば、それを描く。
    float backX = uFold + PI * uRadius - d;
    if (backX <= width) {
      fragColor = back(backX, p.y, 0.97);
    } else {
      // 裏返った部分のふちのすぐ外には、表に薄い影を落とす。
      float flapEdge = 2.0 * uFold - width + PI * uRadius;
      float edgeShade = 1.0 - 0.12 * (1.0 - smoothstep(0.0, uRadius * 0.5, flapEdge - p.x));
      bool hasFlap = uFold + PI * uRadius < width;
      fragColor = front(p.x, p.y, hasFlap ? edgeShade : 1.0);
    }
    return;
  }

  if (d < uRadius) {
    // 筒の上。手前に来る上半分（裏）を先に、なければ下半分（表）を描く。
    float theta = asin(d / uRadius);
    float upperX = uFold + uRadius * (PI - theta);
    float lowerX = uFold + uRadius * theta;
    float t = d / uRadius;
    if (upperX <= width) {
      fragColor = back(upperX, p.y, 0.82 + 0.15 * (1.0 - t));
    } else if (lowerX <= width) {
      // 筒の外側へ回り込むほど暗く、折れ目の少し右に光が当たる。
      float light = 1.0 - 0.35 * t * t + 0.06 * sin(t * PI);
      fragColor = front(lowerX, p.y, light);
    } else {
      fragColor = shadow(p.x);
    }
    return;
  }

  fragColor = shadow(p.x);
}
