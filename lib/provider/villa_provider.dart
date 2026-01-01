import 'package:flutter/material.dart';
import '../api/api_service.dart';

class VillaProvider extends ChangeNotifier {
  bool isLoading = false;

  Map<String, dynamic>? userData;
  List businessUnits = [];

  List claimedVillas = [];
  List buProperties = [];

  Map<String, dynamic>? propertyDetail;

  // - LOGIN api -
  Future<void> login(String username, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await ApiService.post('login.json', {
        'username': username,
        'password': password,
      });

      userData = res['data'];
      businessUnits = userData?['business_units'] ?? [];

      // ✅ Set token for future APIs
      ApiService.token = res['data']['auth_token'];
      print('TOKEN SET: ${ApiService.token}');

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // - CLAIMED VILLAS api-
  Future<void> getClaimedVillas() async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await ApiService.post(
        'getClaimedVilla.json',
        {
          'latitude': '26.8373949',
          'longitude': '80.933275',
        },

      );

      claimedVillas = res['data']?['villa'] ?? [];
    } catch (e) {
      print('CLAIMED VILLAS ERROR: $e');
      claimedVillas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // - VILLA DETAIL api-
  Future<void> getPropertyDetail(String villaId) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await ApiService.post(
        'getPropertyDetail.json',
        {
          'villa_id': villaId,
        },

      );

      propertyDetail = res['data'];
      print('Villa Detail: $propertyDetail');

    } catch (e) {
      print('PROPERTY DETAIL ERROR: $e');
      propertyDetail = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // - BU PROPERTIES -
  Future<void> getBuPropertiesByVilla(int buId) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await ApiService.post(
        'getBuPropertyNew.json',
        {
          'latitude': '26.8373949',
          'longitude': '80.933275',
          'business_unit_id': buId,
        },

      );

      if (res['status'] == 'success' && res['data'] != null) {
        buProperties = res['data'];
      } else {
        buProperties = [];
        print('BU Properties API returned fail: ${res['message']}');
      }

      print('BU Properties: $buProperties');

    } catch (e) {
      print('BU PROPERTIES ERROR: $e');
      buProperties = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
