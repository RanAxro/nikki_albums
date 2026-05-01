// assets/shader/refactored.frag
// 按enum顺序重构，每个步骤封装为独立函数

#ifdef GL_ES
  precision mediump float;
#else
  precision highp float;
#endif

#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
uniform vec2 offset;
uniform vec2 size;
uniform sampler2D image;

// 调色顺序参考 Darktable - Display-referred
// 基础调节参数
uniform float u_temperature;
uniform float u_tint;
uniform float u_lightSense;
uniform float u_exposure;
uniform float u_brightness;
uniform float u_contrast;
uniform float u_highlights;
uniform float u_shadows;
uniform float u_whites;
uniform float u_blacks;
uniform float u_vibrance;
uniform float u_saturation;
uniform float u_hslHue;
uniform float u_hslSaturation;
uniform float u_hslLightness;
uniform float u_cyanRed;
uniform float u_magentaGreen;
uniform float u_yellowBlue;
uniform float u_clarity;
uniform float u_fade;

// 工具函数
float lum(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }
float toZT(float x) { return x + 1.0; }
float toZO(float x) { return (x + 1.0) * 0.5; }
float toExp(float x) { return x * 3.0; }
float toBlur(float x) { return x * x * 10.0; }

// 1. temperature - 色温调节
vec3 applyTemperature(vec3 c, float t) {
  vec3 warm = vec3(1.1, 1.0, 0.8);
  vec3 cool = vec3(0.8, 0.9, 1.1);
  vec3 tint = mix(cool, warm, t * 0.5 + 0.5);
  return clamp(c * tint, 0.0, 1.0);
}

// 2. tint - 色调调节（绿-洋红轴）
vec3 applyTint(vec3 c, float t) {
  c.g *= 1.0 - t * 0.1;
  c.r *= 1.0 + t * 0.05;
  c.b *= 1.0 + t * 0.08;
  return clamp(c, 0.0, 1.0);
}

// 3. lightSense - 光感调节
vec3 applyLightSense(vec3 c, float s) {
  float l = lum(c);
  float lift = 0.1 * s;
  c = max(c - lift, 0.0) / (1.0 - lift);
  c = mix(c, pow(c, vec3(0.8)), smoothstep(0.7, 1.0, l) * (s - 1.0) * 0.5);
  return clamp(c, 0.0, 1.0);
}

// 4. exposure - 曝光调节
vec3 applyExposure(vec3 c, float e) {
  return clamp(c * exp2(e), 0.0, 1.0);
}

// 5. brightness - 亮度调节
vec3 applyBrightness(vec3 c, float b) {
  return clamp(c + b, 0.0, 1.0);
}

// 6. contrast - 对比度调节
vec3 applyContrast(vec3 c, float cst) {
  c = clamp(c, 0.0, 1.0);
  return clamp((c - 0.5) * cst + 0.5, 0.0, 1.0);
}

// 7. highlights - 高光调节
vec3 applyHighlights(vec3 c, float h) {
  float l = lum(c);
  float hiMask = smoothstep(0.6, 0.95, l);
  return clamp(mix(c, c * (1.0 + h * 0.5), hiMask), 0.0, 1.0);
}

// 8. shadows - 阴影调节
vec3 applyShadows(vec3 c, float s) {
  float l = lum(c);
  float shMask = 1.0 - smoothstep(0.05, 0.4, l);
  return clamp(mix(c, c + s * 0.2, shMask), 0.0, 1.0);
}

// 9. whites - 白场调节
vec3 applyWhites(vec3 c, float w) {
  float white = 1.0 / max(1.0 - w * 0.5, 0.001);
  return clamp(c * white, 0.0, 1.0);
}

// 10. blacks - 黑场调节
vec3 applyBlacks(vec3 c, float b) {
  float black = b * 0.5;
  return clamp((c - black) / (1.0 - black), 0.0, 1.0);
}

// 11. vibrance - 自然饱和度
vec3 applyVibrance(vec3 c, float v) {
  float l = lum(c);
  float sat = distance(c, vec3(l));
  vec3 skin = normalize(vec3(0.8, 0.6, 0.4));
  float skinSim = dot(normalize(max(c, 0.001)), skin);
  float skinMask = smoothstep(0.7, 1.0, skinSim);
  float lowSatMask = 1.0 - smoothstep(0.0, 0.2, sat);
  float adj = (v - 1.0) * mix(1.0, 0.3, skinMask) * mix(0.3, 1.0, lowSatMask);
  return clamp(mix(vec3(l), c, 1.0 + adj), 0.0, 1.0);
}

// 12. saturation - 饱和度调节
vec3 applySaturation(vec3 c, float s) {
  float l = lum(c);
  return clamp(mix(vec3(l), c, s), 0.0, 1.0);
}

// HSL转换辅助函数
vec3 rgb2hsl(vec3 c) {
  float maxC = max(max(c.r, c.g), c.b);
  float minC = min(min(c.r, c.g), c.b);
  float d = maxC - minC;
  float l = (maxC + minC) * 0.5;
  float s = d < 0.0001 ? 0.0 : d / (1.0 - abs(2.0 * l - 1.0));
  float h = 0.0;
  if (d > 0.0001) {
    if (maxC == c.r) h = mod((c.g - c.b) / d, 6.0);
    else if (maxC == c.g) h = (c.b - c.r) / d + 2.0;
    else h = (c.r - c.g) / d + 4.0;
    h /= 6.0;
  }
  return vec3(h, s, l);
}

vec3 hsl2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
  return c.z + c.y * (rgb - 0.5) * (1.0 - abs(2.0 * c.z - 1.0));
}

// 13. hslHue - HSL色相调节
vec3 applyHslHue(vec3 c, float hue) {
  vec3 hsl = rgb2hsl(c);
  hsl.x = fract(hsl.x + hue * 0.5 + 1.0);
  return clamp(hsl2rgb(hsl), 0.0, 1.0);
}

// 14. hslSaturation - HSL饱和度调节
vec3 applyHslSaturation(vec3 c, float sat) {
  vec3 hsl = rgb2hsl(c);
  hsl.y = clamp(hsl.y * (1.0 + sat), 0.0, 1.0);
  return clamp(hsl2rgb(hsl), 0.0, 1.0);
}

// 15. hslLightness - HSL明度调节
vec3 applyHslLightness(vec3 c, float light) {
  vec3 hsl = rgb2hsl(c);
  hsl.z = clamp(hsl.z * (1.0 + light * 0.5), 0.0, 1.0);
  return clamp(hsl2rgb(hsl), 0.0, 1.0);
}

// 16. cyanRed - 青红平衡
vec3 applyCyanRed(vec3 c, float val) {
  c.r += val * 0.1;
  c.g += val * 0.05;
  c.b -= val * 0.1;
  return clamp(c, 0.0, 1.0);
}

// 17. 修正：+val 应该增加绿色（减少洋红）
vec3 applyMagentaGreen(vec3 c, float val) {
  c.r -= val * 0.08;  // 减少红色
  c.g += val * 0.1;   // 增加绿色
  c.b -= val * 0.08;  // 减少蓝色
  return clamp(c, 0.0, 1.0);
}

// 18. 修正：+val 应该增加蓝色（减少黄）
vec3 applyYellowBlue(vec3 c, float val) {
  c.r -= val * 0.05;  // 减少红色
  c.g -= val * 0.05;  // 减少绿色
  c.b += val * 0.15;  // 增加蓝色
  return clamp(c, 0.0, 1.0);
}

// 19. clarity - 清晰度调节
vec3 applyClarity(vec3 c, float clarity, vec2 uv, vec2 sz) {
  vec3 blur = vec3(0.0);
  float total = 0.0;
  for(int x = -1; x <= 1; x++) {
    for(int y = -1; y <= 1; y++) {
      vec2 off = vec2(float(x), float(y)) / sz * 2.0;
      float w = 1.0 / (1.0 + float(x*x + y*y));
      blur += texture(image, uv + off).rgb * w;
      total += w;
    }
  }
  blur /= total;
  vec3 detail = c - blur;
  return clamp(c + detail * clarity * 1.5, 0.0, 1.0);
}

// 20. fade - 褪色效果
vec3 applyFade(vec3 c, float f) {
  c = c * (1.0 - f * 0.3) + f * 0.15;
  c = pow(c, vec3(1.0 - f * 0.3));
  c.r += f * 0.05;
  c.b -= f * 0.02;
  return clamp(c, 0.0, 1.0);
}

// 主函数 - 按enum顺序调用各处理步骤
void main() {
  vec2 uv = (FlutterFragCoord().xy - offset) / size;
  vec3 c = texture(image, uv).rgb;

  // 参数转换
  float temperature = u_temperature;
  float tint = u_tint;
  float lightSense = toZT(u_lightSense);
  float exposure = toExp(u_exposure);
  float brightness = u_brightness * 0.5;
  float contrast = toZT(u_contrast);
  float highlights = u_highlights;
  float shadows = u_shadows;
  float whites = u_whites;
  float blacks = u_blacks;
  float vibrance = toZT(u_vibrance);
  float saturation = toZT(u_saturation);
  float hslHue = u_hslHue;
  float hslSaturation = u_hslSaturation;
  float hslLightness = u_hslLightness;
  float cyanRed = u_cyanRed;
  float magentaGreen = u_magentaGreen;
  float yellowBlue = u_yellowBlue;
  float clarity = u_clarity;
  float fade = toZO(u_fade);

  // 按enum顺序处理
  c = applyTemperature(c, temperature);
  c = applyTint(c, tint);
  c = applyLightSense(c, lightSense);
  c = applyExposure(c, exposure);
  c = applyBrightness(c, brightness);
  c = applyContrast(c, contrast);
  c = applyHighlights(c, highlights);
  c = applyShadows(c, shadows);
  c = applyWhites(c, whites);
  c = applyBlacks(c, blacks);
  c = applyVibrance(c, vibrance);
  c = applySaturation(c, saturation);
  c = applyHslHue(c, hslHue);
  c = applyHslSaturation(c, hslSaturation);
  c = applyHslLightness(c, hslLightness);
  c = applyCyanRed(c, cyanRed);
  c = applyMagentaGreen(c, magentaGreen);
  c = applyYellowBlue(c, yellowBlue);

  if (abs(clarity) > 0.01) {
    c = applyClarity(c, clarity, uv, size);
  }

  c = applyFade(c, fade);

  fragColor = vec4(clamp(c, 0.0, 1.0), 1.0);
}