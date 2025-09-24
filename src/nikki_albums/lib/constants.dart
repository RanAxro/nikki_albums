//软件版本
const version = "0.1";

const agreement = '''
MIT License（MIT 许可证）

Copyright (c) [2025] [RanAxro]  
版权所有 (c) [2025] [RanAxro]

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

特此授予任何获得本软件及其相关文档文件（以下简称“本软件”）副本的人，  
不受限制地处理本软件的权利，包括但不限于使用、复制、修改、合并、发布、  
分发、再授权和/或出售本软件副本的权利，以及允许获得本软件的人这样做，  
但须满足以下条件：

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

上述版权声明和本许可声明应包含在本软件的所有副本或实质部分中。

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
SOFTWARE.

本软件按“原样”提供，**不提供任何明示或暗示的担保**，包括但不限于对  
适销性、特定用途适用性和非侵权性的担保。在任何情况下，作者或版权  
持有人不对因本软件或本软件的使用或其他交易而产生的任何索赔、损害  
或其他责任承担责任，无论是合同行为、侵权行为还是其他行为。

''';


const hint = '''
  本软件当前版本为测试版本，其功能、性能及稳定性等尚未达到最终发布标准，不代表该软件的最终品质.更多功能仍在开发中
''';


//windows通过注册表信息定位无限暖暖的根目录
// \[version] 为启动器目录
// \InfinityNikki 为游戏目录
const INRegistryPaths = [
  //(hive, keyPath, valueName, addition) 从注册表 hive\keyPath 拿到valueName的合法值, 加上addition就是游戏根目录
  //hive对照表
  //HKEY_CLASSES_ROOT =	0x80000000
  //HKEY_CURRENT_USER	0x80000001
  //HKEY_LOCAL_MACHINE	0x80000002
  //HKEY_USERS	0x80000003
  //HKEY_PERFORMANCE_DATA	0x80000004
  //HKEY_CURRENT_CONFIG	0x80000005
  ("paper", 0x80000002, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher", "DisplayIcon", r""),
  // 官网版本 值为?\InfinityNikki Launcher\launcher.exe, X6Game在?\InfinityNikki Launcher\InfinityNikki\X6Game
  ("paper", 0x80000002, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikki Launcher", "UninstallString", r""),
  // 官网版本 值为?\InfinityNikki Launcher\uninst.exe, X6Game在?\InfinityNikki Launcher\InfinityNikki\X6Game
  ("taptap", 0x80000002, r"SOFTWARE\TapTap\Games\247283", "InstallPath", r"\InfinityNikki Launcher"),
  // TapTap版本 值为?\TapTap\PC Games\InfinityNikki, X6Game在?TapTap\PC Games\InfinityNikki\InfinityNikki Launcher\InfinityNikki\X6Game
  ("bilibili", 0x80000002, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\InfinityNikkiBili Launcher", "InstallPath", r""),
  // bilibili版本 值为?\InfinityNikkiBili Launcher, X6Game在?InfinityNikkiBili Launcher\InfinityNikki\X6Game
  ("steam", 0x80000002, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 3164330", "InstallLocation", r"")
  // steam版本 值为?\steam\steamapps\common\Infinity Nikki, X6Game在?\steam\steamapps\common\Infinity Nikki\InfinityNikki\X6Game

  //epic

  //inc
];
//Android通过包名定位游戏
const INAndroidPackage = "com.papegames.infinitynikki";

const INLauncherDir = r"$root$\$launcherVersion$";
const INGameDir = r"$root$\InfinityNikki";

const INLauncherEXE = r"$root$\$launcherVersion$\xstarter.exe";
const INGameEXE = r"$root$\InfinityNikki";

//InfinityNikki各文件夹所在的位置
const Map<String, Map<String, String>> INFolderPaths = {
  "Windows": {
    "ScreenShot": r"$root$\InfinityNikki\X6Game\ScreenShot",  //
    "CustomAvatar": r"$root$\InfinityNikki\X6Game\Saved\CustomAvatar\$uid$",
    "CustomCard": r"$root$\InfinityNikki\X6Game\Saved\CustomCard\$uid$",
    "DIY": r"$root$\InfinityNikki\X6Game\Saved\DIY\$uid$",
    "GamePlayPhotos": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$",
    "ClockInPhoto": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$\ClockInPhoto",
    "CloudPhotos": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos",
    "MagazinePhotos": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$\MagazinePhotos",
    "CloudPhotos_LowQuality": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$\CloudPhotos_LowQuality",
    "NikkiPhotos_HighQuality": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_HighQuality",
    "NikkiPhotos_LowQuality": r"$root$\InfinityNikki\X6Game\Saved\GamePlayPhotos\$uid$\NikkiPhotos_LowQuality"
  },
  "Android": {
    //Android的ScreenShot保存在截图文件夹, 文件名格式为 Screenshot_yyyy-MM-dd-HH-mm-ss-fff_com.papegames.infinitynikki.jpg
    "ScreenShot": r"storage/emulated/0/DCIM/Screenshots",
    "CustomAvatar": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$",
    "CustomCard": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$",
    "DIY": r"$root$/files/UnrealGame/X6Game/Saved/DIY/$uid$",
    "GamePlayPhotos": r"$root$/files/UnrealGame/X6Game/Saved/GamePlayPhotos/$uid$",
    "ClockInPhoto": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/ClockInPhoto",
    "CloudPhotos": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/CloudPhotos",
    "CloudPhotos_LowQuality": r"f$root$/iles/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/CloudPhotos_LowQuality",
    "NikkiPhotos_HighQuality": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/NikkiPhotos_HighQuality",
    "NikkiPhotos_LowQuality": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/NikkiPhotos_LowQuality"
  }
};

//备份文件各文件夹所在的位置
const Map<String, Map<String, String>> backupFolderPaths = {
  "Windows": {
    "ScreenShot": r"$root$\$version$\ScreenShot",  //
    "CustomAvatar": r"$root$\$version$\$uid$\CustomAvatar",
    "CustomCard": r"$root$\$version$\$uid$\CustomCard",
    "DIY": r"$root$\$version$\$uid$\DIY",
    "ClockInPhoto": r"$root$\$version$\$uid$\ClockInPhoto",
    "CloudPhotos": r"$root$\$version$\$uid$\CloudPhotos",
    "MagazinePhotos": r"$root$\$version$\$uid$\MagazinePhotos",
    "CloudPhotos_LowQuality": r"$root$\$version$\$uid$\CloudPhotos_LowQuality",
    "NikkiPhotos": r"$root$\$version$\$uid$\NikkiPhotos",
  },
  "Android": {
    //Android的ScreenShot保存在截图文件夹, 文件名格式为 Screenshot_yyyy-MM-dd-HH-mm-ss-fff_com.papegames.infinitynikki.jpg
    "ScreenShot": r"storage/emulated/0/DCIM/Screenshots",
    "CustomAvatar": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$",
    "CustomCard": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$",
    "DIY": r"$root$/files/UnrealGame/X6Game/Saved/DIY/$uid$",
    "GamePlayPhotos": r"$root$/files/UnrealGame/X6Game/Saved/GamePlayPhotos/$uid$",
    "ClockInPhoto": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/ClockInPhoto",
    "CloudPhotos": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/CloudPhotos",
    "CloudPhotos_LowQuality": r"f$root$/iles/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/CloudPhotos_LowQuality",
    "NikkiPhotos_HighQuality": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/NikkiPhotos_HighQuality",
    "NikkiPhotos_LowQuality": r"$root$/files/UnrealGame/X6Game/X6Game/Saved/GamePlayPhotos/$uid$/NikkiPhotos_LowQuality"
  }
};


const defaultWindowsScreenSize = (1920, 1080);
const defaultAndroidScreenSize = (1080, 2400);

const defaultMainColor = 0xFF333333;
const defaultViceColor = 0xFF444444;
const defaultBackColor = 0xFF222222;
const defaultHighLightColor = 0xFF666666;
const defaultAntiColor = 0xFFEEEEEE;
const defaultWarningColor = 0xFFFF0000;
const defaultCorrectColor = 0xFF00FF00;

const double topBarHeight = 45;
const double sideBarWidth = 50;

const Map<String, dynamic> defaultConfig = {
  "version": 2,
  "isAgreeAgreement": false,  //是否同意软件使用协议
  "qq": "",
  "url": "",
  "selectedAccount": null,  //用户最后一次选择的account
  "customAccount": [],  //用户自定义account [{"source":"title","rootPath":"rootPath"}, ...]
  "contentStartupPage": 1,  //content启动页
  "backupFolderPath": null,  //备份文件夹
  "camera": "https://github.com/ChanIok/SpinningMomo",
  "paper_tool": "https://myl.nuanpaper.com/home",
  "cdkeyProvider": [],  //cdkey提供商 [{"name": "url}, ...]
  "cdkey": {"大喵者暖暖伙伴也": [null, "2026-07-24 23:59:59"], "与百万星光作伴共赴未来": [null, "2026-07-14 23:59:59"], "infinitynikki1205": [null, null], "与暖暖繁星织梦": [null, null], "Nikki1205": [null, null], "WXNN666": [null, null],},  //cdkey {"cdkeyName": ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss"], ...}
  "videoBilibiliVideos": ["BV1rMaPzLEQW", "BV1sCaPzHEoo", "BV1LdaFzoEuT", "BV1GMhhzTENw", "BV14JhJzFEvy", "BV1y182zAEpu", "BV1mAGEzjERv", "BV1EuMMzZEea", "BV1poGXzMEYm", "BV1hnovYvE7v", "BV15qGCzcExA", "BV1J6G7zAE4V", "BV1kfPVeyE8m", "BV1srfJYXExj", "BV1Ec9xY2EfV", "BV1ahfHYMEW3", "BV1Dw6gYXErg", "BV1ktidYZEgh", "BV1UyXXYMEhR", "BV1gzG8zHESt", "BV1ANr9YvEmo", "BV1zu98YoE4Z"],  //video中的bilibili视频
  "wikiList": [{"source": "biligame wiki", "url": "https://wiki.biligame.com/wxnn/%E9%A6%96%E9%A1%B5"}, {"source": "gamekee wiki", "url": "https://www.gamekee.com/infinitynikki/"}, {"source": "fandom wiki", "url": "https://infinity-nikki.fandom.com/zh/wiki/%E6%97%A0%E9%99%90%E6%9A%96%E6%9A%96Wiki"}, {"source": "暖暖共鸣录", "url": "https://gongeo.us/zh"}],  //wiki {"source": "", "url": ""}
};
const apiUrl = r"https://api.github.com/repos/ranaxro/nikki_albums/contents/api.json";


const api = {
  "version0": "0.1",
  "version1": null,
  "isWarning": false,
  "warningTitle": "",
  "warningMessage": "",
  "qq": "1062670402",
  "url": "",
  "camera": "https://github.com/ChanIok/SpinningMomo",
  "paper_tool": "https://myl.nuanpaper.com/home",
  "videoBilibiliVideos": ["BV1rMaPzLEQW", "BV1sCaPzHEoo", "BV1LdaFzoEuT", "BV1GMhhzTENw", "BV14JhJzFEvy", "BV1y182zAEpu", "BV1mAGEzjERv", "BV1EuMMzZEea", "BV1poGXzMEYm", "BV1hnovYvE7v", "BV15qGCzcExA", "BV1J6G7zAE4V", "BV1kfPVeyE8m", "BV1srfJYXExj", "BV1Ec9xY2EfV", "BV1ahfHYMEW3", "BV1Dw6gYXErg", "BV1ktidYZEgh", "BV1UyXXYMEhR", "BV1gzG8zHESt", "BV1ANr9YvEmo", "BV1zu98YoE4Z"],
  "cdkey": {"大喵者暖暖伙伴也": [null, "2026-07-24 23:59:59"], "与百万星光作伴共赴未来": [null, "2026-07-14 23:59:59"], "infinitynikki1205": [null, null], "与暖暖繁星织梦": [null, null], "Nikki1205": [null, null], "WXNN666": [null, null]},
  "wikiList": [{"source": "biligame wiki", "url": "https://wiki.biligame.com/wxnn/%E9%A6%96%E9%A1%B5"}, {"source": "gamekee wiki", "url": "https://www.gamekee.com/infinitynikki/"}, {"source": "fandom wiki", "url": "https://infinity-nikki.fandom.com/zh/wiki/%E6%97%A0%E9%99%90%E6%9A%96%E6%9A%96Wiki"}, {"source": "暖暖照相馆", "url": "https://nikkigallery.vip/"}, {"source": "Infinity Nikki Assistant", "url": "https://nuan5.pro"}, {"source": "暖暖共鸣录", "url": "https://gongeo.us/zh"}]
};