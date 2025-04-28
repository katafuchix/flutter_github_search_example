import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../model/repo.dart';


class GithubSearchViewmodel extends ChangeNotifier {
  final Dio _dio = Dio();
  final List<Repo> _repos = [];
  Timer? _debounce;

  List<Repo> get repos => _repos;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.length > 2) {
        _searchGithub(query);
      }
    });
  }

  void _searchGithub(String query) async {
    _isLoading = true;
    notifyListeners();

    final url = 'https://api.github.com/search/repositories?q=$query';
    try {
      final response = await _dio.get(url);
      final List<dynamic> items = response.data['items'];
      _repos
        ..clear()
        ..addAll(items.map((json) => Repo.fromJson(json)).toList());
    } catch (e) {
      _repos.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
