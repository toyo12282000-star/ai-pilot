import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ai_pilot/features/advisor/data/dto/advisor_api_response_dto.dart';
import 'package:ai_pilot/features/advisor/domain/entities/advisor_api_response.dart';
import 'package:ai_pilot/features/advisor/domain/exceptions/advisor_api_exception.dart';
import 'package:ai_pilot/features/advisor/domain/repositories/advisor_api_repository.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow.dart';

typedef AdvisorFunctionInvoker = Future<FunctionResponse> Function(
  Map<String, dynamic> body,
);

/// [AdvisorApiRepository] の Supabase Edge Function 実装。
///
/// `supabase/functions/advisor` を呼び出す。
/// 将来 Edge Function 内で OpenAI Responses API に差し替える。
class SupabaseAdvisorApiRepository implements AdvisorApiRepository {
  SupabaseAdvisorApiRepository({
    this._client,
    this._invokeAdvisor,
  });

  final SupabaseClient? _client;
  final AdvisorFunctionInvoker? _invokeAdvisor;

  static const _functionName = 'advisor';

  @override
  Future<AdvisorApiResponse> suggest({
    required String query,
    required List<Workflow> workflows,
  }) async {
    try {
      final response = await _invoke(body: {
        'query': query,
        'workflows': workflows.map(_workflowToJson).toList(),
      });

      return _parseResponse(response);
    } on AdvisorApiException {
      rethrow;
    } on FunctionException catch (error) {
      throw _mapFunctionException(error);
    } on FormatException catch (error) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.invalidResponse,
        message: 'Advisor の応答形式が不正です',
        cause: error,
      );
    } on SocketException catch (error) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.network,
        message: 'Advisor に接続できませんでした',
        cause: error,
      );
    } on IOException catch (error) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.network,
        message: 'Advisor に接続できませんでした',
        cause: error,
      );
    } catch (error) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.unknown,
        message: 'Advisor の呼び出しに失敗しました',
        cause: error,
      );
    }
  }

  Future<FunctionResponse> _invoke({required Map<String, dynamic> body}) {
    final invokeAdvisor = _invokeAdvisor;
    if (invokeAdvisor != null) {
      return invokeAdvisor(body);
    }
    final client = _client ?? Supabase.instance.client;
    return client.functions.invoke(_functionName, body: body);
  }

  AdvisorApiResponse _parseResponse(FunctionResponse response) {
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.invalidResponse,
        message: 'Advisor の応答形式が不正です',
      );
    }

    if (data.containsKey('error')) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.invalidResponse,
        message: data['error']?.toString() ?? 'Advisor の応答にエラーが含まれています',
      );
    }

    try {
      return AdvisorApiResponseDto.fromJson(data).toEntity();
    } on FormatException catch (error) {
      throw AdvisorApiException(
        code: AdvisorApiFailureCode.invalidResponse,
        message: 'Advisor の応答形式が不正です',
        cause: error,
      );
    }
  }

  AdvisorApiException _mapFunctionException(FunctionException error) {
    final status = error.status;
    final details = error.details?.toString() ?? '';

    if (status == HttpStatus.notFound ||
        details.contains('Function not found') ||
        details.contains('Requested function was not found')) {
      return AdvisorApiException(
        code: AdvisorApiFailureCode.notDeployed,
        message: 'Advisor Edge Function がデプロイされていません',
        cause: error,
      );
    }

    if (status == HttpStatus.badGateway ||
        status == HttpStatus.serviceUnavailable ||
        status == HttpStatus.gatewayTimeout) {
      return AdvisorApiException(
        code: AdvisorApiFailureCode.network,
        message: 'Advisor Edge Function に接続できませんでした',
        cause: error,
      );
    }

    return AdvisorApiException(
      code: AdvisorApiFailureCode.unknown,
      message: 'Advisor Edge Function の呼び出しに失敗しました',
      cause: error,
    );
  }

  Map<String, dynamic> _workflowToJson(Workflow workflow) {
    return {
      'id': workflow.id,
      'title': workflow.title,
      'description': workflow.description,
      'tags': workflow.tags,
      'categoryId': workflow.categoryId,
    };
  }
}
