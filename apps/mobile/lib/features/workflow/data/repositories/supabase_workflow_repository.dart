import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/workflow/data/dto/json_helpers.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_dto.dart';
import 'package:ai_pilot/features/workflow/data/dto/workflow_step_dto.dart';
import 'package:ai_pilot/features/workflow/data/mappers/workflow_mapper.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';
import 'package:ai_pilot/features/workflow/domain/repositories/workflow_repository.dart';

/// [WorkflowRepository] の Supabase 実装。
class SupabaseWorkflowRepository implements WorkflowRepository {
  SupabaseWorkflowRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Workflow>> fetchWorkflows() async {
    return _fetchWorkflowsWithSteps();
  }

  @override
  Future<List<Workflow>> fetchWorkflowsByCategory(String categoryId) async {
    return _fetchWorkflowsWithSteps(
      workflowQuery: _client.from('workflows').select().eq('category_id', categoryId),
    );
  }

  @override
  Future<Workflow?> fetchWorkflowById(String id) async {
    final workflowResponse = await _client
        .from('workflows')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (workflowResponse == null) {
      return null;
    }

    final stepsResponse = await _client
        .from('workflow_steps')
        .select()
        .eq('workflow_id', id)
        .order('step_order', ascending: true);

    final workflow = WorkflowDto.fromJson(workflowResponse);
    final steps = (stepsResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowStepDto.fromJson)
        .toList();

    return WorkflowMapper.assembleOne(workflow, steps);
  }

  @override
  Future<List<Workflow>> searchWorkflows(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return fetchWorkflows();
    }

    final pattern = '%${escapeIlikePattern(normalizedQuery)}%';
    final titleDescriptionResponse = await _client
        .from('workflows')
        .select()
        .or('title.ilike.$pattern,description.ilike.$pattern')
        .order('created_at', ascending: true);

    final titleDescriptionWorkflows = (titleDescriptionResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowDto.fromJson)
        .toList();

    final allWorkflowsResponse =
        await _client.from('workflows').select().order('created_at', ascending: true);
    final allWorkflowDtos = (allWorkflowsResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowDto.fromJson)
        .toList();

    final loweredQuery = normalizedQuery.toLowerCase();
    final tagMatchedWorkflows = allWorkflowDtos.where((workflow) {
      return workflow.tags.any(
        (tag) => tag.toLowerCase().contains(loweredQuery),
      );
    });

    final mergedWorkflows = <String, WorkflowDto>{
      for (final workflow in titleDescriptionWorkflows) workflow.id: workflow,
      for (final workflow in tagMatchedWorkflows) workflow.id: workflow,
    };

    if (mergedWorkflows.isEmpty) {
      return [];
    }

    final workflowIds = mergedWorkflows.keys.toList();
    final stepsResponse = await _client
        .from('workflow_steps')
        .select()
        .inFilter('workflow_id', workflowIds)
        .order('step_order', ascending: true);

    final steps = (stepsResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowStepDto.fromJson)
        .toList();

    final orderedWorkflows = mergedWorkflows.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return WorkflowMapper.assembleMany(orderedWorkflows, steps);
  }

  Future<List<Workflow>> _fetchWorkflowsWithSteps({
    dynamic workflowQuery,
  }) async {
    final query = workflowQuery ?? _client.from('workflows').select();
    final workflowsResponse =
        await query.order('created_at', ascending: true);

    final workflows = (workflowsResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowDto.fromJson)
        .toList();

    if (workflows.isEmpty) {
      return [];
    }

    final workflowIds = workflows.map((workflow) => workflow.id).toList();
    final stepsResponse = await _client
        .from('workflow_steps')
        .select()
        .inFilter('workflow_id', workflowIds)
        .order('step_order', ascending: true);

    final steps = (stepsResponse as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(WorkflowStepDto.fromJson)
        .toList();

    return WorkflowMapper.assembleMany(workflows, steps);
  }
}
