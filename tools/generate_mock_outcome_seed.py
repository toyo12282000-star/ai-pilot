#!/usr/bin/env python3
"""Generate mock_outcome_seed_data.dart from 006_outcome_seed_data.sql."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "supabase/migrations/006_outcome_seed_data.sql"
OUT_PATH = (
    ROOT
    / "apps/mobile/lib/features/workflow/data/repositories/mock_outcome_seed_data.dart"
)

STEP_MAP = {
    "50000000-0000-4000-8000-000000000001": "step_short_1",
    "50000000-0000-4000-8000-000000000002": "step_short_2",
    "50000000-0000-4000-8000-000000000003": "step_short_3",
    "50000000-0000-4000-8000-000000000004": "step_short_4",
    "50000000-0000-4000-8000-000000000005": "step_blog_1",
    "50000000-0000-4000-8000-000000000006": "step_blog_2",
    "50000000-0000-4000-8000-000000000007": "step_sns_1",
    "50000000-0000-4000-8000-000000000008": "step_sns_2",
}

WF_MAP = {
    "40000000-0000-4000-8000-000000000001": "wf_youtube_short",
    "40000000-0000-4000-8000-000000000002": "wf_blog",
    "40000000-0000-4000-8000-000000000003": "wf_sns",
}

TOOL_MAP = {
    "20000000-0000-4000-8000-000000000001": "tool_chatgpt",
    "20000000-0000-4000-8000-000000000002": "tool_claude",
    "20000000-0000-4000-8000-000000000003": "tool_gemini",
    "20000000-0000-4000-8000-000000000004": "tool_perplexity",
    "20000000-0000-4000-8000-000000000005": "tool_canva",
    "20000000-0000-4000-8000-000000000006": "tool_elevenlabs",
    "20000000-0000-4000-8000-000000000007": "tool_capcut",
    "20000000-0000-4000-8000-000000000008": "tool_cursor",
    "20000000-0000-4000-8000-000000000009": "tool_ideogram",
    "20000000-0000-4000-8000-00000000000a": "tool_vrew",
    "20000000-0000-4000-8000-00000000000b": "tool_voicevox",
}

PROMPT_MAP = {
    "30000000-0000-4000-8000-000000000001": "prompt_short_idea",
    "30000000-0000-4000-8000-000000000002": "prompt_short_script",
    "30000000-0000-4000-8000-000000000003": "prompt_blog_outline",
    "30000000-0000-4000-8000-000000000004": "prompt_blog_body",
    "30000000-0000-4000-8000-000000000005": "prompt_sns_caption",
    "30000000-0000-4000-8000-000000000006": "prompt_sns_image",
}

OUTCOME_MAP = {
    "80000000-0000-4000-8000-000000000001": "outcome_youtube_short",
    "80000000-0000-4000-8000-000000000002": "outcome_blog",
    "80000000-0000-4000-8000-000000000003": "outcome_sns",
}

OPTION_ID_MAP = {
    f"60000000-0000-4000-8000-{i:012d}": f"step_tool_{i:03d}"
    for i in range(1, 33)
}

VARIANT_ID_MAP = {
    f"70000000-0000-4000-8000-{i:012d}": f"variant_{i:03d}"
    for i in range(1, 41)
}

OUTCOME_TYPE = {
    "video": "OutcomeType.video",
    "article": "OutcomeType.article",
    "sns_post": "OutcomeType.snsPost",
}

VARIANT_TYPE = {
    "beginner": "PromptVariantType.beginner",
    "high_quality": "PromptVariantType.highQuality",
    "short_time": "PromptVariantType.shortTime",
    "viral": "PromptVariantType.viral",
    "professional": "PromptVariantType.professional",
    "seo": "PromptVariantType.seo",
    "sns": "PromptVariantType.sns",
}

DIFFICULTY = {
    "easy": "StepToolDifficulty.easy",
    "normal": "StepToolDifficulty.normal",
    "hard": "StepToolDifficulty.hard",
}


def dart_str(s: str) -> str:
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n") + "'"


def map_uuid(uuid: str, mapping: dict[str, str]) -> str | None:
    return mapping.get(uuid)


def parse_outcomes(sql: str) -> list[dict]:
    block = re.search(
        r"INSERT INTO public\.workflow_outcomes.*?VALUES(.*?)ON CONFLICT",
        sql,
        re.DOTALL,
    )
    if not block:
        return []
    rows = []
    for m in re.finditer(
        r"\(\s*'([^']+)',\s*'([^']+)',\s*'([^']*)',\s*'((?:[^']|\\')*)',\s*'([^']+)'",
        block.group(1),
    ):
        oid, wid, title, desc, otype = m.groups()
        desc = desc.replace("\\'", "'")
        rest = block.group(1)[m.end() :]
        expected = re.search(r"'((?:[^']|\\')*)'", rest)
        expected_val = expected.group(1).replace("\\'", "'") if expected else None
        rows.append(
            {
                "id": OUTCOME_MAP[oid],
                "workflow_id": WF_MAP[wid],
                "title": title,
                "description": desc,
                "outcome_type": OUTCOME_TYPE[otype],
                "expected_result": expected_val,
            }
        )
    return rows


def parse_tool_options(sql: str) -> list[dict]:
    block = re.search(
        r"INSERT INTO public\.workflow_step_tool_options.*?VALUES(.*?)ON CONFLICT",
        sql,
        re.DOTALL,
    )
    if not block:
        return []
    rows = []
    pattern = re.compile(
        r"\('([^']+)',\s*'([^']+)',\s*'([^']+)',\s*(true|false),\s*"
        r"'((?:[^']|\\')*)',\s*'([^']+)',\s*'((?:[^']|\\')*)',\s*(\d+)",
        re.IGNORECASE,
    )
    for m in pattern.finditer(block.group(1)):
        oid, sid, tid, rec, reason, diff, pricing, sort = m.groups()
        rows.append(
            {
                "id": OPTION_ID_MAP.get(oid, f"step_tool_{oid[-3:]}"),
                "step_id": STEP_MAP[sid],
                "tool_id": TOOL_MAP[tid],
                "recommended": rec.lower() == "true",
                "reason": reason.replace("\\'", "'"),
                "difficulty": DIFFICULTY[diff],
                "pricing": pricing.replace("\\'", "'"),
                "sort": int(sort),
            }
        )
    return rows


def parse_alternatives(sql: str) -> list[dict]:
    block = re.search(
        r"INSERT INTO public\.ai_tool_alternatives.*?VALUES(.*?)ON CONFLICT",
        sql,
        re.DOTALL,
    )
    if not block:
        return []
    rows = []
    for m in re.finditer(
        r"\('([^']+)',\s*'([^']+)',\s*'((?:[^']|\\')*)',\s*(\d+)\)",
        block.group(1),
    ):
        aid, alt, reason, sort = m.groups()
        rows.append(
            {
                "ai_tool_id": TOOL_MAP[aid],
                "alt_id": TOOL_MAP[alt],
                "reason": reason.replace("\\'", "'"),
                "sort": int(sort),
            }
        )
    return rows


def split_sql_values(values_blob: str) -> list[str]:
    """Split top-level SQL VALUES tuples, respecting quotes."""
    tuples: list[str] = []
    depth = 0
    in_quote = False
    escape = False
    start = None
    for i, ch in enumerate(values_blob):
        if escape:
            escape = False
            continue
        if ch == "\\" and in_quote:
            escape = True
            continue
        if ch == "'":
            in_quote = not in_quote
            continue
        if in_quote:
            continue
        if ch == "(":
            if depth == 0:
                start = i
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0 and start is not None:
                tuples.append(values_blob[start : i + 1])
                start = None
    return tuples


def unquote_sql_string(s: str) -> str:
    s = s.strip()
    if s.upper() == "NULL":
        return ""
    if s.startswith("E'") or s.startswith("e'"):
        s = s[1:]
    if s.startswith("'") and s.endswith("'"):
        inner = s[1:-1]
        return inner.replace("''", "'").replace("\\n", "\n").replace("\\'", "'")
    return s


def parse_field(field: str) -> str:
    field = field.strip()
    if field.upper() == "NULL":
        return ""
    if field.startswith("ARRAY["):
        items = re.findall(r"'((?:[^']|\\')*)'", field)
        return items
    return unquote_sql_string(field)


def parse_prompt_variants(sql: str) -> list[dict]:
    block = re.search(
        r"INSERT INTO public\.prompt_variants.*?VALUES(.*?)ON CONFLICT",
        sql,
        re.DOTALL,
    )
    if not block:
        return []
    rows = []
    for tup in split_sql_values(block.group(1)):
        inner = tup[1:-1].strip()
        fields: list[str] = []
        buf = []
        in_quote = False
        escape = False
        depth = 0
        for ch in inner:
            if escape:
                buf.append(ch)
                escape = False
                continue
            if ch == "\\" and in_quote:
                buf.append(ch)
                escape = True
                continue
            if ch == "'":
                in_quote = not in_quote
                buf.append(ch)
                continue
            if not in_quote:
                if ch in "([":
                    depth += 1
                elif ch in ")]":
                    depth -= 1
                elif ch == "," and depth == 0:
                    fields.append("".join(buf).strip())
                    buf = []
                    continue
            buf.append(ch)
        if buf:
            fields.append("".join(buf).strip())
        if len(fields) < 12:
            continue
        if not fields[0].strip().startswith("'70000000"):
            continue
        vid = fields[0].strip("'")
        sid = fields[1].strip("'")
        ptid_raw = parse_field(fields[2])
        title = parse_field(fields[3])
        vtype = parse_field(fields[4])
        content = parse_field(fields[5])
        expected = parse_field(fields[6])
        tips = parse_field(fields[7])
        variables = parse_field(fields[8])
        sort = int(fields[9].strip().strip("'"))
        rows.append(
            {
                "id": VARIANT_ID_MAP.get(vid, f"variant_{vid[-3:]}"),
                "step_id": STEP_MAP[sid],
                "prompt_template_id": PROMPT_MAP.get(ptid_raw) if ptid_raw else None,
                "title": title,
                "variant_type": VARIANT_TYPE[vtype],
                "content": content,
                "expected_output": expected,
                "usage_tips": tips,
                "variables": variables if isinstance(variables, list) else [],
                "sort": sort,
            }
        )
    return rows


def emit_outcomes(outcomes: list[dict]) -> str:
    lines = ["final List<WorkflowOutcome> mockWorkflowOutcomes = ["]
    for o in outcomes:
        lines.append("  WorkflowOutcome(")
        lines.append(f"    id: '{o['id']}',")
        lines.append(f"    workflowId: '{o['workflow_id']}',")
        lines.append(f"    title: {dart_str(o['title'])},")
        lines.append(f"    description: {dart_str(o['description'])},")
        lines.append(f"    outcomeType: {o['outcome_type']},")
        if o.get("expected_result"):
            lines.append(f"    expectedResult: {dart_str(o['expected_result'])},")
        lines.append("    sortOrder: 0,")
        lines.append("    createdAt: mockBaseDate,")
        lines.append("    updatedAt: mockBaseDate,")
        lines.append("  ),")
    lines.append("];")
    return "\n".join(lines)


def emit_options(options: list[dict]) -> str:
    lines = ["final List<WorkflowStepToolOption> mockWorkflowStepToolOptions = ["]
    for o in options:
        lines.append("  WorkflowStepToolOption(")
        lines.append(f"    id: '{o['id']}',")
        lines.append(f"    workflowStepId: '{o['step_id']}',")
        lines.append(f"    aiToolId: '{o['tool_id']}',")
        lines.append(f"    isRecommended: {str(o['recommended']).lower()},")
        lines.append(f"    recommendationReason: {dart_str(o['reason'])},")
        lines.append(f"    difficulty: {o['difficulty']},")
        if o.get("pricing"):
            lines.append(f"    pricingNote: {dart_str(o['pricing'])},")
        lines.append(f"    sortOrder: {o['sort']},")
        lines.append("    createdAt: mockBaseDate,")
        lines.append("    updatedAt: mockBaseDate,")
        lines.append("  ),")
    lines.append("];")
    return "\n".join(lines)


def emit_variants(variants: list[dict]) -> str:
    lines = ["final List<PromptVariant> mockPromptVariants = ["]
    for v in variants:
        lines.append("  PromptVariant(")
        lines.append(f"    id: '{v['id']}',")
        lines.append(f"    workflowStepId: '{v['step_id']}',")
        if v.get("prompt_template_id"):
            lines.append(f"    promptTemplateId: '{v['prompt_template_id']}',")
        lines.append(f"    title: {dart_str(v['title'])},")
        lines.append(f"    variantType: {v['variant_type']},")
        content = v["content"]
        if len(content) > 120 or "\n" in content:
            lines.append(f"    content: {dart_str(content)},")
        else:
            lines.append(f"    content: {dart_str(content)},")
        if v.get("expected_output"):
            lines.append(f"    expectedOutput: {dart_str(v['expected_output'])},")
        if v.get("usage_tips"):
            lines.append(f"    usageTips: {dart_str(v['usage_tips'])},")
        if v["variables"]:
            vars_dart = ", ".join(f"'{x}'" for x in v["variables"])
            lines.append(f"    variables: [{vars_dart}],")
        lines.append(f"    sortOrder: {v['sort']},")
        lines.append("    createdAt: mockBaseDate,")
        lines.append("    updatedAt: mockBaseDate,")
        lines.append("  ),")
    lines.append("];")
    return "\n".join(lines)


def emit_alternatives(alts: list[dict]) -> str:
    lines = ["final List<AIToolAlternative> mockAIToolAlternatives = ["]
    for a in alts:
        lines.append("  AIToolAlternative(")
        lines.append(f"    aiToolId: '{a['ai_tool_id']}',")
        lines.append(f"    alternativeAiToolId: '{a['alt_id']}',")
        lines.append(f"    reason: {dart_str(a['reason'])},")
        lines.append(f"    sortOrder: {a['sort']},")
        lines.append("  ),")
    lines.append("];")
    return "\n".join(lines)


def main() -> None:
    sql = SQL_PATH.read_text(encoding="utf-8")
    outcomes = parse_outcomes(sql)
    options = parse_tool_options(sql)
    variants = parse_prompt_variants(sql)
    alts = parse_alternatives(sql)

    header = """import 'package:ai_pilot/features/workflow/data/repositories/mock_seed_data.dart';
import 'package:ai_pilot/features/workflow/domain/entities/ai_tool_alternative.dart';
import 'package:ai_pilot/features/workflow/domain/entities/prompt_variant.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_outcome.dart';
import 'package:ai_pilot/features/workflow/domain/entities/workflow_step_tool_option.dart';

/// Mock Workflow Outcome 一覧（Sprint 12.3 品質シード）。
"""

    body = "\n\n".join(
        [
            emit_outcomes(outcomes),
            "/// Mock Step ツール候補。",
            emit_options(options),
            "/// Mock プロンプトバリエーション。",
            emit_variants(variants),
            "/// Mock AI ツール代替候補。",
            emit_alternatives(alts),
        ]
    )

    OUT_PATH.write_text(header + body + "\n", encoding="utf-8")
    print(
        f"Generated {OUT_PATH.name}: "
        f"{len(outcomes)} outcomes, {len(options)} options, "
        f"{len(variants)} variants, {len(alts)} alternatives"
    )


if __name__ == "__main__":
    main()
