
import "package:flutter/widgets.dart";


enum ClothPropLevel{
  SSS(true),
  SS(true),
  S(true),
  A(false),
  B(false),
  C(false),
  D(false);

  final bool hasBack;

  const ClothPropLevel(this.hasBack);
}


const Color clothPropInfoBackground = Color(0xFFAD9D94);
const TextStyle clothPropTextStyle = TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold);

class ClothPropText extends StatelessWidget{
  final ImageProvider<Object> propBackground;
  final String propText;
  final String? propScore;
  final ClothPropLevel? propLevel;
  final double height;

  const ClothPropText({
    super.key,
    required this.propBackground,
    required this.propText,
    this.propScore,
    this.propLevel,
    this.height = 26,
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: propBackground,
                height: height,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                  return SizedBox(
                    width: 86 / 26 * height,
                    height: height,
                    child: ColoredBox(
                      color: clothPropInfoBackground,
                      child: child,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object e, StackTrace? s){
                  return SizedBox(
                    width: 86,
                    height: height,
                    child: ColoredBox(
                      color: clothPropInfoBackground,
                    ),
                  );
                },
              ),

              Text(propText, style: clothPropTextStyle),
            ],
          ),

          if(propScore != null)
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0.5 * height),
                    bottomRight: Radius.circular(0.5 * height),
                  ),
                  child: SizedBox(
                    height: height,
                    child: ColoredBox(
                      color: clothPropInfoBackground,
                      child: Row(
                        children: [
                          SizedBox(
                            width: propLevel == null ? 6 : 76 / 28 *  height,
                          ),

                          SizedBox(
                            width: 40,
                            child: Text(propScore!, style: clothPropTextStyle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if(propLevel?.hasBack == true)
                  Image.asset(
                    "assets/icon/infinity_nikki/cloth_prop_level_back.png",
                    height: height,
                  ),

                if(propLevel != null)
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Transform.scale(scale: 2).transform,
                    child: Image.asset(
                      "assets/icon/infinity_nikki/cloth_prop_level_${propLevel!.name.toLowerCase()}.png",
                      height: height,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}