import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/presentation/settings/bgg_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _usernameController = TextEditingController();
  bool _isLoading = true;
  bool _isSyncing = false;
  String? _account;
  String? _error;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadAccount);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadAccount() async {
    final account = await ref
        .read(appSettingsDaoProvider)
        .getValue(bggUsernameSettingKey);
    if (!mounted) return;
    setState(() {
      _account = account;
      _isLoading = false;
    });
  }

  Future<void> _sync() async {
    final username = (_account ?? _usernameController.text).trim();
    if (username.isEmpty) {
      setState(() => _error = 'BGG username을 입력하세요');
      return;
    }

    setState(() {
      _isSyncing = true;
      _error = null;
    });

    try {
      await ref.read(bggSyncServiceProvider).sync(username);
      if (!mounted) return;
      setState(() {
        _account = username;
        _usernameController.clear();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'BGG 전적 동기화 중 문제가 발생했습니다');
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _disconnect() async {
    await ref.read(appSettingsDaoProvider).deleteValue(bggUsernameSettingKey);
    await ref.read(gamePlayStatsDaoProvider).deleteAll();
    await ref.read(sessionDaoProvider).replaceBggSyncedSessions([]);
    ref.read(bggSyncServiceProvider).invalidateDependents();
    if (!mounted) return;
    setState(() {
      _account = null;
      _error = null;
      _usernameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiConfigured = ref
        .watch(bggCollectionSyncApiServiceProvider)
        .isConfigured;

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BggSyncSection(
            account: _account,
            controller: _usernameController,
            isLoading: _isLoading,
            isSyncing: _isSyncing,
            apiConfigured: apiConfigured,
            error: _error,
            onSync: _sync,
            onDisconnect: _disconnect,
          ),
        ],
      ),
    );
  }
}

class _BggSyncSection extends StatelessWidget {
  final String? account;
  final TextEditingController controller;
  final bool isLoading;
  final bool isSyncing;
  final bool apiConfigured;
  final String? error;
  final VoidCallback onSync;
  final VoidCallback onDisconnect;

  const _BggSyncSection({
    required this.account,
    required this.controller,
    required this.isLoading,
    required this.isSyncing,
    required this.apiConfigured,
    required this.error,
    required this.onSync,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BGG 전적 동기화',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (account == null) ...[
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'BGG username',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) =>
                          apiConfigured && !isSyncing ? onSync() : null,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: apiConfigured && !isSyncing ? onSync : null,
                        icon: isSyncing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: Text(isSyncing ? '동기화 중' : '동기화하기'),
                      ),
                    ),
                  ] else ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.account_circle_outlined),
                      title: const Text('동기화 중인 계정'),
                      subtitle: Text(account!),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: apiConfigured && !isSyncing ? onSync : null,
                        icon: isSyncing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: Text(isSyncing ? '동기화 중' : '동기화하기'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isSyncing ? null : onDisconnect,
                        icon: const Icon(Icons.link_off),
                        label: const Text('동기화 해제하기'),
                      ),
                    ),
                  ],
                  if (!apiConfigured) ...[
                    const SizedBox(height: 8),
                    Text(
                      'BGG API token이 설정되지 않았습니다.',
                      style: TextStyle(color: cs.error),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(error!, style: TextStyle(color: cs.error)),
                  ],
                ],
              ),
      ),
    );
  }
}
