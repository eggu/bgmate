import 'package:bgmate_flutter/data/service/collection_sync_service.dart';
import 'package:bgmate_flutter/di/account_provider.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/bgg_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('BGG 계정 관리')),
      body: accountAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (account) => account == null
            ? _UnlinkedView(onLink: (username) => _linkAccount(context, ref, username))
            : _LinkedView(
                account: account,
                onSync: () => _syncCollection(context, ref, account.username),
                onUnlink: () => _confirmUnlink(context, ref),
              ),
      ),
    );
  }

  Future<void> _linkAccount(BuildContext context, WidgetRef ref, String username) async {
    await ref.read(accountProvider.notifier).linkAccount(username);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$username 계정이 연동되었습니다.')),
      );
    }
  }

  Future<void> _syncCollection(BuildContext context, WidgetRef ref, String username) async {
    final result = await ref.read(collectionSyncProvider.notifier).sync(username);
    if (context.mounted && result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '동기화 완료: ${result.added}개 추가, ${result.updated}개 업데이트',
          ),
        ),
      );
    }
  }

  void _confirmUnlink(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('BGG 계정 연동 해제'),
        content: const Text('연동을 해제하면 자동 동기화가 중단됩니다.\n컬렉션 데이터를 어떻게 할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ref.read(accountProvider.notifier).unlinkAccount();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계정 연동이 해제되었습니다. 컬렉션은 유지됩니다.')),
                );
              }
            },
            child: const Text('컬렉션 유지'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _unlinkAndClearSynced(context, ref);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('동기화 게임 삭제'),
          ),
        ],
      ),
    );
  }

  Future<void> _unlinkAndClearSynced(BuildContext context, WidgetRef ref) async {
    await ref.read(gameRepositoryProvider).removeSyncedGames();
    await ref.read(accountProvider.notifier).unlinkAccount();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계정 연동이 해제되었습니다. 동기화 게임이 삭제됩니다.')),
      );
    }
  }
}

class _UnlinkedView extends StatefulWidget {
  final Future<void> Function(String username) onLink;

  const _UnlinkedView({required this.onLink});

  @override
  State<_UnlinkedView> createState() => _UnlinkedViewState();
}

class _UnlinkedViewState extends State<_UnlinkedView> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final username = _controller.text.trim();
    if (username.isEmpty) return;
    setState(() => _isLoading = true);
    await widget.onLink(username);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Icon(Icons.link_off, size: 48, color: cs.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            'BGG 계정을 연동하면\n컬렉션을 자동으로 동기화할 수 있습니다.',
            style: tt.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'BGG 사용자 이름',
              hintText: 'BoardGameGeek username',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('계정 연동하기'),
          ),
        ],
      ),
    );
  }
}

class _LinkedView extends ConsumerWidget {
  final BggAccount account;
  final VoidCallback onSync;
  final VoidCallback onUnlink;

  const _LinkedView({
    required this.account,
    required this.onSync,
    required this.onUnlink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(collectionSyncProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSyncing = syncState is AsyncLoading;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.link, color: cs.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.username,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          account.lastSyncedAt != null
                              ? '마지막 동기화: ${_formatDate(account.lastSyncedAt!)}'
                              : '아직 동기화하지 않았습니다.',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isSyncing) ...[
            _SyncProgressIndicator(
              step: syncState.isLoading
                  ? null
                  : (syncState as AsyncData<SyncStep?>).value,
            ),
            const SizedBox(height: 16),
          ],
          FilledButton.icon(
            onPressed: isSyncing ? null : onSync,
            icon: const Icon(Icons.sync, size: 18),
            label: const Text('지금 동기화'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: isSyncing ? null : onUnlink,
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.error,
              side: BorderSide(color: cs.error),
            ),
            child: const Text('연동 해제하기'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final y = dt.year;
    final mo = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$y.$mo.$d $h:$mi';
  }
}

class _SyncProgressIndicator extends StatelessWidget {
  final SyncStep? step;

  const _SyncProgressIndicator({this.step});

  @override
  Widget build(BuildContext context) {
    final label = switch (step) {
      SyncStep.fetchingCollection => 'BGG에서 컬렉션 가져오는 중...',
      SyncStep.savingToDb => 'DB에 저장하는 중...',
      SyncStep.done => '완료',
      null => '동기화 준비 중...',
    };

    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
