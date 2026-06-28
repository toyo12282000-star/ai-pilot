#!/usr/bin/env python3
"""Generate placeholder AI Pilot launcher and splash PNG assets."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

PRIMARY = (0x5B, 0x5C, 0xEB, 255)
WHITE = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "apps" / "mobile" / "assets" / "app_icon"

FONT_CANDIDATES = [
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
    "/System/Library/Fonts/Supplemental/Helvetica.ttc",
    "/Library/Fonts/Arial Bold.ttf",
]


def load_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    for path in FONT_CANDIDATES:
        font_path = Path(path)
        if font_path.exists():
            return ImageFont.truetype(str(font_path), size=size)
    return ImageFont.load_default()


def draw_mark(
    draw: ImageDraw.ImageDraw,
    center: tuple[int, int],
    scale: float,
    *,
    white: tuple[int, int, int, int] = WHITE,
) -> None:
    cx, cy = center
    ring_radius = int(188 * scale)
    ring_width = max(4, int(28 * scale))

    draw.ellipse(
        [
            cx - ring_radius,
            cy - ring_radius,
            cx + ring_radius,
            cy + ring_radius,
        ],
        outline=white,
        width=ring_width,
    )

    tick_height = int(110 * scale)
    tick_half_width = int(36 * scale)
    top_y = cy - ring_radius - int(20 * scale)
    draw.polygon(
        [
            (cx, top_y - tick_height),
            (cx + tick_half_width, top_y),
            (cx - tick_half_width, top_y),
        ],
        fill=white,
    )

    dot_radius = max(3, int(24 * scale))
    draw.ellipse(
        [
            cx - dot_radius,
            cy - dot_radius,
            cx + dot_radius,
            cy + dot_radius,
        ],
        fill=white,
    )

    font = load_font(int(240 * scale))
    text = "AI"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_w = bbox[2] - bbox[0]
    text_h = bbox[3] - bbox[1]
    text_x = cx - text_w // 2
    text_y = cy + int(170 * scale) - text_h // 2
    draw.text((text_x, text_y), text, fill=white, font=font)


def save_app_icon(path: Path, size: int) -> None:
    image = Image.new("RGBA", (size, size), PRIMARY)
    draw = ImageDraw.Draw(image)
    corner = int(size * 0.22)
    mask = Image.new("L", (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, size, size], radius=corner, fill=255)
    rounded = Image.new("RGBA", (size, size), TRANSPARENT)
    rounded.paste(image, mask=mask)

    draw = ImageDraw.Draw(rounded)
    draw_mark(draw, (size // 2, int(size * 0.46)), scale=size / 1024)
    rounded.save(path, format="PNG")


def save_foreground(path: Path, size: int) -> None:
    image = Image.new("RGBA", (size, size), TRANSPARENT)
    draw = ImageDraw.Draw(image)
    draw_mark(draw, (size // 2, int(size * 0.46)), scale=size / 1024)
    image.save(path, format="PNG")


def save_splash_logo(path: Path, size: int) -> None:
    image = Image.new("RGBA", (size, size), TRANSPARENT)
    draw = ImageDraw.Draw(image)
    badge_size = int(size * 0.72)
    badge_x = (size - badge_size) // 2
    badge_y = (size - badge_size) // 2
    draw.rounded_rectangle(
        [badge_x, badge_y, badge_x + badge_size, badge_y + badge_size],
        radius=int(badge_size * 0.22),
        fill=PRIMARY,
    )
    draw_mark(
        draw,
        (size // 2, int(size * 0.46)),
        scale=size / 1024 * 0.72,
    )
    image.save(path, format="PNG")


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    save_app_icon(OUT_DIR / "app_icon.png", 1024)
    save_foreground(OUT_DIR / "app_icon_foreground.png", 1024)
    save_splash_logo(OUT_DIR / "splash_logo.png", 512)
    print(f"Generated icons in {OUT_DIR}")


if __name__ == "__main__":
    main()
