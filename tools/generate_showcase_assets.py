#!/usr/bin/env python3
"""Generate unified minimal showcase preview/thumbnail SVGs for AI Pilot."""

from __future__ import annotations

import os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "apps/mobile/assets/showcases"

ACCENT = "#4F46E5"
BG = "#F8F9FB"
SURFACE = "#FFFFFF"
BORDER = "#E7EAF0"
TEXT = "#111827"
MUTED = "#6B7280"


def svg_content(
    width: int,
    height: int,
    category: str,
    title: str,
    platform: str,
) -> str:
    margin = max(24, width // 24)
    inner_w = width - margin * 2
    inner_h = height - margin * 2
    title_lines = _wrap(title, 14 if width >= 800 else 10)
    title_y = margin + inner_h * 0.62
    lines_svg = ""
    for i, line in enumerate(title_lines[:3]):
        lines_svg += (
            f'<text x="{margin + 32}" y="{title_y + i * 34}" '
            f'font-family="system-ui, -apple-system, sans-serif" font-size="28" '
            f'font-weight="600" fill="{TEXT}">{_esc(line)}</text>\n'
        )

    mock_ui = _mock_ui(platform, margin, inner_w, inner_h)

    return f"""<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">
  <rect fill="{BG}" width="{width}" height="{height}"/>
  <rect x="{margin}" y="{margin}" width="{inner_w}" height="{inner_h}" rx="28" fill="{SURFACE}" stroke="{BORDER}" stroke-width="2"/>
  <rect x="{margin + 28}" y="{margin + 28}" width="96" height="28" rx="14" fill="{BG}" stroke="{BORDER}"/>
  <text x="{margin + 44}" y="{margin + 48}" font-family="system-ui, -apple-system, sans-serif" font-size="14" font-weight="600" fill="{MUTED}">{_esc(category)}</text>
  {mock_ui}
  {lines_svg}
  <circle cx="{width - margin - 36}" cy="{margin + 42}" r="6" fill="{ACCENT}" opacity="0.85"/>
</svg>
"""


def _mock_ui(platform: str, margin: int, inner_w: int, inner_h: int) -> str:
    x = margin + 32
    y = margin + 80
    w = inner_w - 64
    h = inner_h * 0.42
    if platform == "youtube":
        return (
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="16" fill="{BG}" stroke="{BORDER}"/>'
            f'<polygon points="{x + w//2 - 18},{y + h//2 - 24} {x + w//2 + 28},{y + h//2} {x + w//2 - 18},{y + h//2 + 24}" fill="{ACCENT}" opacity="0.35"/>'
        )
    if platform == "instagram":
        return (
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="16" fill="{BG}" stroke="{BORDER}"/>'
            f'<rect x="{x + 24}" y="{y + 24}" width="{w - 48}" height="{h - 48}" rx="12" fill="{SURFACE}" stroke="{BORDER}"/>'
            f'<circle cx="{x + w - 48}" cy="{y + 36}" r="8" fill="{ACCENT}" opacity="0.4"/>'
        )
    return (
        f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="{BG}" stroke="{BORDER}"/>'
        f'<rect x="{x + 24}" y="{y + 28}" width="{w * 0.55}" height="12" rx="6" fill="{BORDER}"/>'
        f'<rect x="{x + 24}" y="{y + 52}" width="{w * 0.75}" height="10" rx="5" fill="{BORDER}" opacity="0.7"/>'
        f'<rect x="{x + 24}" y="{y + 72}" width="{w * 0.65}" height="10" rx="5" fill="{BORDER}" opacity="0.5"/>'
    )


def _wrap(text: str, max_len: int) -> list[str]:
    words = text.replace("【", "").replace("】", "").split()
    if not words:
        return [text[:max_len]]
    lines: list[str] = []
    current = ""
    for word in words:
        candidate = f"{current} {word}".strip()
        if len(candidate) <= max_len:
            current = candidate
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines or [text[:max_len]]


def _esc(value: str) -> str:
    return (
        value.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


ENTRIES = [
    ("youtube", "wf_youtube_short", "showcase_yt_1", "雑学", "世界一危険な島3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_2", "美容", "ドラッグストア化粧水3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_3", "歴史", "世界の変な法律3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_4", "ガジェット", "2026年おすすめガジェット3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_5", "旅行", "週末に行ける絶景スポット3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_6", "ゲーム", "令和に遊びたい神ゲー3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_7", "お金", "今すぐできる節約術3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_8", "副業", "月1万円の始め方ショート", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_9", "AI", "ChatGPT活用アイデア3選", 400, 711, 1080, 1920),
    ("youtube", "wf_youtube_short", "showcase_yt_10", "料理", "15分で作る時短レシピ3選", 400, 711, 1080, 1920),
    ("instagram", "wf_sns", "showcase_sns_1", "カルーセル", "朝のルーティン5ステップ", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_2", "ビジネス", "AIツール比較カルーセル", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_3", "副業", "副業で月3万円の3つの方法", 400, 400, 1080, 1350),
    ("instagram", "wf_sns", "showcase_sns_4", "名言", "仕事が捗る名言5選", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_5", "美容", "夜のスキンケアルーティン", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_6", "旅行", "週末カップル旅プラン", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_7", "カフェ", "映えカフェ5選", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_8", "商品紹介", "在宅ワークデスク3点", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_9", "レシピ", "15分パスタの作り方", 400, 400, 1080, 1080),
    ("instagram", "wf_sns", "showcase_sns_10", "英語", "毎日5分で身につく英語", 400, 400, 1080, 1080),
    ("blog", "wf_blog", "showcase_blog_1", "SEO", "ChatGPTで副業を始める完全ガイド", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_2", "副業", "在宅ワークの始め方2026年版", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_3", "AI", "Notionでタスク管理を始める", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_4", "ガジェット", "ノートPC比較ガイド2026", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_5", "レビュー", "AIアプリ5選レビュー", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_6", "投資", "初心者向けNISA入門", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_7", "旅行", "国内温泉旅おすすめ5選", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_8", "転職", "履歴書の書き方テンプレ", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_9", "プログラミング", "Python入門30日プラン", 800, 450, 1200, 630),
    ("blog", "wf_blog", "showcase_blog_10", "ライフハック", "時間術10選", 800, 450, 1200, 630),
]


def main() -> None:
    for folder, workflow_id, showcase_id, category, title, tw, th, pw, ph in ENTRIES:
        base = OUT / folder / workflow_id / showcase_id
        base.mkdir(parents=True, exist_ok=True)
        platform = folder
        (base / "thumbnail.svg").write_text(
            svg_content(tw, th, category, title, platform),
            encoding="utf-8",
        )
        (base / "preview.svg").write_text(
            svg_content(pw, ph, category, title, platform),
            encoding="utf-8",
        )
    print(f"Generated {len(ENTRIES) * 2} SVG files under {OUT}")


if __name__ == "__main__":
    main()
