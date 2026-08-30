from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).parent
RAW = ROOT / "en-US" / "raw"
WIDTH, HEIGHT = 1320, 2868
FONT = "/System/Library/Fonts/SFNS.ttf"


SCREENS = [
    ("01-hydration.png", "01-home.png", "Hydration,\nbeautifully simple", "Your daily progress at a glance.", None),
    ("02-quick-add.png", "01-home.png", "Log water\nin one tap", "Fast, effortless, always within reach.", (0, 760, 1320, 2520)),
    ("03-progress.png", "02-stats.png", "See progress\nthat motivates", "Clear trends turn small sips into habits.", None),
    ("04-history.png", "04-history.png", "Every sip,\nremembered", "Review your hydration journey anytime.", None),
    ("05-awards.png", "03-awards.png", "Build habits.\nEarn milestones.", "Celebrate consistency as it grows.", None),
    ("06-themes.png", "05-settings.png", "Make Drinkly\nyours", "Premium themes designed for your style.", None),
    ("07-insights.png", "01-home.png", "Stay on track\nall day", "Smart insights keep your goal in sight.", (0, 420, 1320, 2180)),
]

SCREENS_TR = [
    ("01-hydration.png", "01-home.png", "Su takibi,\nartık çok kolay", "Günlük ilerlemen tek bakışta.", None),
    ("02-quick-add.png", "01-home.png", "Tek dokunuşla\nsu ekle", "Hızlı, zahmetsiz ve her zaman elinin altında.", (0, 760, 1320, 2520)),
    ("03-progress.png", "02-stats.png", "İlerlemeni gör,\nmotivasyonunu koru", "Küçük adımlar sağlıklı alışkanlıklara dönüşsün.", None),
    ("04-history.png", "04-history.png", "Her yudum\nkayıt altında", "Su tüketim geçmişine istediğin zaman göz at.", None),
    ("05-awards.png", "03-awards.png", "Alışkanlık oluştur.\nBaşarıları kutla.", "İstikrarını korurken yeni hedefler kazan.", None),
    ("06-themes.png", "05-settings.png", "Drinkly’yi\nkişiselleştir", "Tarzına uygun premium temaları seç.", None),
    ("07-insights.png", "01-home.png", "Gün boyu\nhedefinde kal", "Akıllı bilgiler hedefini görünür tutar.", (0, 420, 1320, 2180)),
]


def font(size: int):
    return ImageFont.truetype(FONT, size=size)


def gradient(start, end):
    image = Image.new("RGB", (WIDTH, HEIGHT))
    pixels = image.load()
    for y in range(HEIGHT):
        t = y / (HEIGHT - 1)
        for x in range(WIDTH):
            drift = (x / (WIDTH - 1) - 0.5) * 0.08
            mix = max(0, min(1, t + drift))
            pixels[x, y] = tuple(round(a + (b - a) * mix) for a, b in zip(start, end))
    return image


def rounded_screen(source: Image.Image, target_width: int, crop):
    if crop:
        source = source.crop(crop)
    ratio = target_width / source.width
    target_height = round(source.height * ratio)
    source = source.resize((target_width, target_height), Image.Resampling.LANCZOS).convert("RGB")
    mask = Image.new("L", source.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, source.width, source.height), radius=72, fill=255)
    layer = Image.new("RGBA", source.size)
    layer.paste(source.convert("RGBA"), mask=mask)
    return layer


def render(file_name, source_name, title, subtitle, crop, index, output):
    palettes = [
        ((255, 83, 101), (255, 159, 69)),
        ((255, 101, 92), (255, 177, 82)),
        ((233, 82, 116), (255, 148, 79)),
        ((255, 112, 88), (247, 160, 83)),
        ((241, 78, 111), (255, 139, 75)),
        ((220, 79, 128), (255, 150, 83)),
        ((255, 91, 97), (255, 167, 72)),
    ]
    canvas = gradient(*palettes[index])
    ambient = Image.new("RGBA", (WIDTH, HEIGHT), (0, 0, 0, 0))
    ambient_draw = ImageDraw.Draw(ambient)
    ambient_draw.ellipse((-220, -180, 720, 760), fill=(255, 255, 255, 30))
    ambient_draw.ellipse((820, 320, 1510, 1040), fill=(255, 224, 160, 30))
    ambient = ambient.filter(ImageFilter.GaussianBlur(90))
    canvas = Image.alpha_composite(canvas.convert("RGBA"), ambient)

    draw = ImageDraw.Draw(canvas)
    draw.text((92, 110), "DRINKLY", font=font(34), fill=(255, 255, 255, 210), spacing=4)
    draw.multiline_text((92, 205), title, font=font(92), fill="white", spacing=0, stroke_width=0)
    title_box = draw.multiline_textbbox((92, 205), title, font=font(92), spacing=0)
    draw.text((94, title_box[3] + 30), subtitle, font=font(35), fill=(255, 255, 255, 225))

    source = Image.open(RAW / source_name)
    screen = rounded_screen(source, 1110 if crop is None else 1160, crop)
    screen_x = (WIDTH - screen.width) // 2
    screen_y = 650
    shadow = Image.new("RGBA", (screen.width + 120, screen.height + 120), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (60, 50, screen.width + 60, screen.height + 50), radius=82, fill=(79, 30, 30, 105)
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(42))
    canvas.alpha_composite(shadow, (screen_x - 60, screen_y - 50))
    canvas.alpha_composite(screen, (screen_x, screen_y))
    canvas.convert("RGB").save(output / file_name, quality=95)


for locale, screens in (("en-US", SCREENS), ("tr-TR", SCREENS_TR)):
    output = ROOT / locale / "screenshots"
    output.mkdir(parents=True, exist_ok=True)
    for idx, spec in enumerate(screens):
        render(*spec, idx, output)
