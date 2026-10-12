from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SIZE = 1024
CORNER_RATIO = 0.22
MARGIN_RATIO = 0.06
START = (0x4F, 0x46, 0xE5)
END = (0x7C, 0x3A, 0xED)
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
HERE = Path(__file__).parent


def gradient(size):
    image = Image.new("RGB", (size, size))
    pixels = image.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * (size - 1))
            pixels[x, y] = tuple(round(a + (b - a) * t) for a, b in zip(START, END))
    return image


def icon():
    margin = round(SIZE * MARGIN_RATIO)
    inner = SIZE - 2 * margin
    mask = Image.new("L", (SIZE, SIZE), 0)
    ImageDraw.Draw(mask).rounded_rectangle((margin, margin, SIZE - margin, SIZE - margin), round(inner * CORNER_RATIO), fill=255)
    image = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    image.paste(gradient(SIZE), (0, 0), mask)
    draw = ImageDraw.Draw(image)
    font = ImageFont.truetype(FONT, round(inner * 0.62))
    left, top, right, bottom = draw.textbbox((0, 0), "A", font=font)
    draw.text(((SIZE - (right - left)) / 2 - left, (SIZE - (bottom - top)) / 2 - top), "A", font=font, fill="white")
    return image


if __name__ == "__main__":
    master = icon()
    master.resize((512, 512), Image.LANCZOS).save(HERE / "app.png")
    master.save(HERE / "app.ico", sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
    master.save(HERE / "app.icns")
    master.resize((128, 128), Image.LANCZOS).save(HERE.parent.parent / "backend/src/main/resources/desktop/icon.png")
