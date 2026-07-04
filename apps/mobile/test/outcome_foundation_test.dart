import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_pilot/features/workflow/data/dto/ai_tool_alternative_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/prompt_variant_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_outcome_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_step_tool_option_dto.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_ai_tool_alternative_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_outcome_seed_data.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_prompt_variant_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_outcome_repository.dart';
import 'package:ai_pilot/features/workflow/data/repositories/mock_workflow_step_tool_option_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';
import 'package:ai_pilot/features/workflow/presentation/providers/outcome_providers.dart';

void main() {
  group('WorkflowOutcome entity', () {
    test('holds outcome metadata', () {
      final outcome = WorkflowOutcome(
        id: 'id-1',
        workflowId: 'wf-1',
        title: '60秒のYouTubeショート動画',
        outcomeType: OutcomeType.video,
        createdAt: _ts,
        updatedAt: _ts,
      );

      expect(outcome.outcomeType, OutcomeType.video);
      expect(outcome.title, contains('YouTube'));
    });
  });

  group('DTO parsing', () {
    test('WorkflowOutcomeDto parses sns_post outcome type', () {
      final dto = WorkflowOutcomeDto.fromJson({
        'id': 'out-1',
        'workflow_id': 'wf-1',
        'title': 'Instagram投稿',
        'outcome_type': 'sns_post',
        'target_users': ['初心者'],
        'use_cases': ['SNS'],
        'sort_order': 0,
        'created_at': '2026-01-15T00:00:00Z',
        'updated_at': '2026-01-15T00:00:00Z',
      });

      expect(dto.toEntity().outcomeType, OutcomeType.snsPost);
    });

    test('PromptVariantDto parses high_quality variant type', () {
      final dto = PromptVariantDto.fromJson({
        'id': 'pv-1',
        'workflow_step_id': 'step-1',
        'title': '高品質',
        'variant_type': 'high_quality',
        'content': 'prompt body',
        'variables': ['theme'],
        'sort_order': 1,
        'created_at': '2026-01-15T00:00:00Z',
        'updated_at': '2026-01-15T00:00:00Z',
      });

      expect(dto.toEntity().variantType, PromptVariantType.highQuality);
    });

    test('WorkflowStepToolOptionDto parses recommended flag', () {
      final dto = WorkflowStepToolOptionDto.fromJson({
        'id': 'opt-1',
        'workflow_step_id': 'step-1',
        'ai_tool_id': 'tool-1',
        'is_recommended': true,
        'difficulty': 'easy',
        'sort_order': 0,
        'created_at': '2026-01-15T00:00:00Z',
        'updated_at': '2026-01-15T00:00:00Z',
      });

      expect(dto.toEntity().isRecommended, isTrue);
      expect(dto.toEntity().difficulty?.name, 'easy');
    });

    test('AIToolAlternativeDto parses composite key row', () {
      final dto = AIToolAlternativeDto.fromJson({
        'ai_tool_id': 'tool_chatgpt',
        'alternative_ai_tool_id': 'tool_claude',
        'reason': '長文向け',
        'sort_order': 0,
      });

      expect(dto.toEntity().alternativeAiToolId, 'tool_claude');
    });
  });

  group('Mock repositories', () {
    test('Sprint 12.3 seed counts meet quality targets', () {
      expect(mockWorkflowOutcomes, hasLength(3));
      expect(mockWorkflowStepToolOptions.length, greaterThanOrEqualTo(30));
      expect(mockPromptVariants.length, greaterThanOrEqualTo(40));
      expect(mockAIToolAlternatives.length, greaterThanOrEqualTo(20));
    });

    test('fetchOutcomesByWorkflowId returns youtube outcome', () async {
      final repository = MockWorkflowOutcomeRepository();
      final outcomes = await repository.fetchOutcomesByWorkflowId(
        'wf_youtube_short',
      );

      expect(outcomes, isNotEmpty);
      expect(outcomes.first.outcomeType, OutcomeType.video);
    });

    test('fetchToolOptionsByStepId returns at least three options', () async {
      final repository = MockWorkflowStepToolOptionRepository();
      final options = await repository.fetchToolOptionsByStepId('step_short_2');

      expect(options.length, greaterThanOrEqualTo(3));
      expect(options.any((option) => option.isRecommended), isTrue);
    });

    test('fetchPromptVariantsByStepId returns five variants for short step 1', () async {
      final repository = MockPromptVariantRepository();
      final variants = await repository.fetchPromptVariantsByStepId(
        'step_short_2',
      );

      expect(variants.length, 5);
      expect(
        variants.map((variant) => variant.variantType),
        contains(PromptVariantType.beginner),
      );
    });

    test('fetchAlternativesByToolId returns alternatives', () async {
      final repository = MockAIToolAlternativeRepository();
      final alternatives = await repository.fetchAlternativesByToolId(
        'tool_chatgpt',
      );

      expect(alternatives, isNotEmpty);
    });
  });

  group('Outcome providers smoke', () {
    test('workflowOutcomesProvider resolves mock data', () async {
      final container = ProviderContainer(
        overrides: [
          workflowOutcomeRepositoryProvider.overrideWithValue(
            MockWorkflowOutcomeRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final outcomes = await container.read(
        workflowOutcomesProvider('wf_youtube_short').future,
      );

      expect(outcomes.first.title, mockWorkflowOutcomes.first.title);
    });

    test('promptVariantsProvider resolves mock data', () async {
      final container = ProviderContainer(
        overrides: [
          promptVariantRepositoryProvider.overrideWithValue(
            MockPromptVariantRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final variants = await container.read(
        promptVariantsProvider('step_short_2').future,
      );

      expect(variants, hasLength(5));
    });
  });
}

final _ts = DateTime(2026, 1, 15);
