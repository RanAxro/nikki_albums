import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 网络类型枚举
enum NetworkType { wifi, mobile, ethernet, unknown }

class NetworkIPHelper {
  /// 获取 WiFi IP
  static Future<String?> getWifiIP() async {
    return _getIPByType(NetworkType.wifi);
  }

  /// 获取移动数据 IP
  static Future<String?> getMobileIP() async {
    return _getIPByType(NetworkType.mobile);
  }

  /// 获取以太网 IP
  static Future<String?> getEthernetIP() async {
    return _getIPByType(NetworkType.ethernet);
  }

  /// 获取所有网络 IP 信息
  static Future<Map<NetworkType, String?>> getAllIPs() async {
    return {
      NetworkType.wifi: await getWifiIP(),
      NetworkType.mobile: await getMobileIP(),
      NetworkType.ethernet: await getEthernetIP(),
    };
  }

  /// 核心方法：根据网络类型获取 IP
  static Future<String?> _getIPByType(NetworkType type) async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        includeLinkLocal: false,
        type: InternetAddressType.IPv4,
      );

      for (var interface in interfaces) {
        final name = interface.name.toLowerCase();

        bool isMatch = false;

        switch (type) {
          case NetworkType.wifi:
            isMatch = _isWifiInterface(name);
            break;
          case NetworkType.mobile:
            isMatch = _isMobileInterface(name);
            break;
          case NetworkType.ethernet:
            isMatch = _isEthernetInterface(name);
            break;
          default:
            isMatch = false;
        }

        if (isMatch && interface.addresses.isNotEmpty) {
          for (var addr in interface.addresses) {
            final ip = addr.address;
            if (!_isPrivateIP(ip)) {
              return ip;
            }
          }
          return interface.addresses.first.address;
        }
      }

      return null;
    } catch (e) {
      print('获取 $type IP 失败: $e');
      return null;
    }
  }

  /// 判断是否为 WiFi 接口
  static bool _isWifiInterface(String name) {
    return name.contains('wlan') ||
        name.contains('wifi') ||
        name == 'en0' ||
        name == 'p2p0' ||
        name.startsWith('wlp');
  }

  /// 判断是否为移动数据接口
  static bool _isMobileInterface(String name) {
    return name.contains('rmnet') ||
        name.contains('ccmni') ||
        name.contains('pdp_ip') ||
        name == 'ppp0' ||
        name.startsWith('rev_rmnet') ||
        name.startsWith('v4-rmnet');
  }

  /// 判断是否为以太网接口
  static bool _isEthernetInterface(String name) {
    return name == 'eth0' ||
        name.startsWith('eth') ||
        name == 'en1' ||
        name.startsWith('enp') ||
        name.startsWith('ens') ||
        name.contains('ethernet');
  }

  /// 判断是否为私有 IP
  static bool _isPrivateIP(String ip) {
    if (ip.startsWith('10.') ||
        ip.startsWith('192.168.') ||
        ip.startsWith('169.254.')) return true;

    if (ip.startsWith('172.')) {
      final secondOctet = int.tryParse(ip.split('.')[1]) ?? 0;
      if (secondOctet >= 16 && secondOctet <= 31) return true;
    }

    return false;
  }

  /// 获取当前活跃网络的 IP（修复版）
  static Future<String?> getActiveNetworkIP() async {
    try {
      // 新版本返回 List<ConnectivityResult>
      final List<ConnectivityResult> results =
      await Connectivity().checkConnectivity();

      // 检查列表中是否包含特定网络类型（按优先级）
      if (results.contains(ConnectivityResult.ethernet)) {
        return getEthernetIP();
      }
      if (results.contains(ConnectivityResult.wifi)) {
        return getWifiIP();
      }
      if (results.contains(ConnectivityResult.mobile)) {
        return getMobileIP();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// 获取所有活跃网络的 IP 列表
  static Future<Map<NetworkType, String?>> getActiveNetworksIP() async {
    try {
      final List<ConnectivityResult> results =
      await Connectivity().checkConnectivity();

      final Map<NetworkType, String?> activeIPs = {};

      for (var result in results) {
        switch (result) {
          case ConnectivityResult.wifi:
            activeIPs[NetworkType.wifi] = await getWifiIP();
            break;
          case ConnectivityResult.mobile:
            activeIPs[NetworkType.mobile] = await getMobileIP();
            break;
          case ConnectivityResult.ethernet:
            activeIPs[NetworkType.ethernet] = await getEthernetIP();
            break;
          default:
            break;
        }
      }

      return activeIPs;
    } catch (e) {
      return {};
    }
  }
}