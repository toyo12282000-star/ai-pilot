import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ai_pilot/shared/config/advisor_config.dart';

void main() {
  test('useEdgeFunction is false when dotenv is not initialized', () {
    expect(AdvisorConfig.useEdgeFunction, isFalse);
  });

  test('useEdgeFunction is false when env is false', () {
    dotenv.testLoad(
      fileInput: '''
SUPABASE_URL=https://example.supabase.co
SUPABASE_ANON_KEY=test-key
USE_ADVISOR_EDGE_FUNCTION=false
''',
    );

    expect(AdvisorConfig.useEdgeFunction, isFalse);
  });

  test('useEdgeFunction is true when env is true', () {
    dotenv.testLoad(
      fileInput: '''
SUPABASE_URL=https://example.supabase.co
SUPABASE_ANON_KEY=test-key
USE_ADVISOR_EDGE_FUNCTION=true
''',
    );

    expect(AdvisorConfig.useEdgeFunction, isTrue);
  });

  test('useEdgeFunction is true when env is 1', () {
    dotenv.testLoad(
      fileInput: '''
SUPABASE_URL=https://example.supabase.co
SUPABASE_ANON_KEY=test-key
USE_ADVISOR_EDGE_FUNCTION=1
''',
    );

    expect(AdvisorConfig.useEdgeFunction, isTrue);
  });
}
