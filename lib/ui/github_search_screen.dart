import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'github_search_viewmodel.dart';

class GithubSearchScreen extends StatelessWidget {
  const GithubSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GithubSearchViewmodel(),
      child: const _GithubSearchScreen(),
    );
  }
}

class _GithubSearchScreen extends StatelessWidget {
  const _GithubSearchScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GithubSearchViewmodel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.isLoading) {
        SmartDialog.showLoading();
      } else {
        SmartDialog.dismiss();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('GitHub Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: viewModel.onSearchChanged,
              decoration: InputDecoration(
                labelText: '検索',
                border: OutlineInputBorder(),
                isDense: true, // これも高さを詰める効果あり
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0), // ← 余白調整
              ),
            ),
          ),
          if (viewModel.isLoading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.repos.length,
              itemBuilder: (context, index) {
                final repo = viewModel.repos[index];
                return ListTile(
                  title: Text(repo.name),
                  subtitle: Text(repo.language ?? 'No Language'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
