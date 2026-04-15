import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/theme/app_theme.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/judge_history.dart';
import 'package:bgmate_flutter/presentation/rule_judge/judge_history_notifier.dart';
import 'package:bgmate_flutter/presentation/rule_judge/rule_judge_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleJudgeScreen extends ConsumerStatefulWidget {
  const RuleJudgeScreen({super.key});

  @override
  ConsumerState<RuleJudgeScreen> createState() => _RuleJudgeScreenState();
}

class _RuleJudgeScreenState extends ConsumerState<RuleJudgeScreen> {
  final _gameNameController = TextEditingController();
  final _disputeController = TextEditingController();
  List<BoardGame> _games = [];

  @override
  void initState() {
    super.initState();
    _gameNameController.addListener(_onInputChanged);
    _disputeController.addListener(_onInputChanged);
    _loadGames();
  }

  void _onInputChanged() => setState(() {});

  Future<void> _loadGames() async {
    final games = await ref.read(gameRepositoryProvider).getCollection();
    if (mounted) setState(() => _games = games);
  }

  @override
  void dispose() {
    _gameNameController.dispose();
    _disputeController.dispose();
    super.dispose();
  }

  void _showGamePicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 컬렉션에서 선택',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '판정을 받을 게임을 골라 주세요.',
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _games.length,
                itemBuilder: (_, i) {
                  final game = _games[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      color:
                          Theme.of(ctx).colorScheme.surfaceContainerHighest,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          _gameNameController.text = game.name;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            game.name,
                            style: Theme.of(ctx).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDetail(BuildContext context, JudgeHistory item) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.gameName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '질문',
                style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryText(ctx),
                ),
              ),
              const SizedBox(height: 4),
              Text(item.question, style: Theme.of(ctx).textTheme.bodyMedium),
              const Divider(height: 24),
              Text(
                '판정',
                style: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                  color: AppTheme.primaryText(ctx),
                ),
              ),
              const SizedBox(height: 4),
              MarkdownBody(
                data: item.answer,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(ctx))
                    .copyWith(p: Theme.of(ctx).textTheme.bodyMedium),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final judgeState = ref.watch(ruleJudgeProvider);
    final historyState = ref.watch(judgeHistoryProvider);

    final isLoading = judgeState.isLoading;
    final streamingText = judgeState.value?.join('') ?? '';
    final isComplete = judgeState is AsyncData && streamingText.isNotEmpty;
    final errorMessage = _buildErrorMessage(judgeState.error);
    final history = historyState.value ?? [];

    final canJudge =
        !isLoading &&
        _gameNameController.text.trim().isNotEmpty &&
        _disputeController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI 규칙 판정관',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '게임 이름을 직접 입력하거나, 내 컬렉션에서 선택해서 바로 규칙 판정을 요청할 수 있어요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _gameNameController,
                  decoration: const InputDecoration(
                    labelText: '게임 이름',
                    hintText: '예: 카탄, 아그리콜라',
                    helperText: '직접 입력하거나 아래 버튼에서 내 컬렉션 게임을 선택하세요.',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed:
                      !isLoading && _games.isNotEmpty ? _showGamePicker : null,
                  child: Text(
                    _games.isEmpty ? '내 컬렉션에 게임이 없습니다' : '내 컬렉션에서 선택',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _disputeController,
                  decoration: const InputDecoration(
                    labelText: '분쟁 상황',
                    hintText: '어떤 상황인지 구체적으로 입력하세요.',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 4,
                  maxLines: 6,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: canJudge
                      ? () => ref
                            .read(ruleJudgeProvider.notifier)
                            .judge(
                              _gameNameController.text.trim(),
                              _disputeController.text.trim(),
                            )
                      : null,
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('판정 중...'),
                          ],
                        )
                      : const Text('판정 요청'),
                ),
                if (streamingText.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MarkdownBody(
                            data: streamingText,
                            styleSheet: MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              p: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          if (isComplete) ...[
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () =>
                                  ref.read(ruleJudgeProvider.notifier).reset(),
                              child: const Text('다시 질문하기'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                if (history.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    '이전 판정 기록',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...history.map((item) => _HistoryCard(
                    item: item,
                    onTap: () => _showHistoryDetail(context, item),
                  )),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }

  String? _buildErrorMessage(Object? error) {
    if (error is RuleJudgeTemporaryUnavailableException) {
      return '요청이 많아 규칙 판정 서버가 잠시 불안정해요. 잠시 후 다시 시도해 주세요.';
    }
    if (error == null) return null;
    return '규칙 판정을 불러오는 중 문제가 발생했어요. 잠시 후 다시 시도해 주세요.';
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.onTap});

  final JudgeHistory item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = item.askedAt;
    final dateLabel =
        '${date.month}.${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.gameName,
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.question,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.answer,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
