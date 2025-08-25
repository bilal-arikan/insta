import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service_wrapper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await ApiServiceWrapper.searchUsers(query);

      if (result['success'] == true) {
        final List<dynamic> usersJson = result['data']['users'] ?? [];
        final List<UserModel> users = usersJson
            .map((json) => UserModel.fromJson(json))
            .toList();

        setState(() {
          _searchResults = users;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = result['message'] ?? 'Arama başarısız';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Bir hata oluştu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Kullanıcı ara...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _searchUsers,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(child: Text(_errorMessage));
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('Kullanıcı aramak için yukarıdaki arama çubuğunu kullanın'),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.username),
          subtitle: Text(user.fullName ?? ''),
          onTap: () {
            // Navigate to user profile
          },
        );
      },
    );
  }
}