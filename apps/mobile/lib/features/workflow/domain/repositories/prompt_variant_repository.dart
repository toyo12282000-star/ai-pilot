import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';

/// [PromptVariant] の読み取り Repository。
abstract class PromptVariantRepository {
  Future<List<PromptVariant>> fetchPromptVariantsByStepId(String workflowStepId);
}
