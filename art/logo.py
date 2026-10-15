# Pixel-art logo for Elytra HUD: 32x32 grid, scaled with nearest neighbour.
from PIL import Image, ImageDraw
N = 32
img = Image.new("RGB", (N, N))
px = img.load()
# Dusk sky: deep blue at the top to violet at the bottom, in 4-px bands.
top, bot = (24, 30, 64), (88, 52, 110)
for y in range(N):
    t = (y // 4) / ((N - 1) // 4)
    c = tuple(round(a + (b - a) * t) for a, b in zip(top, bot))
    for x in range(N):
        px[x, y] = c

# Wings: polygon mask at grid resolution (no anti-aliasing).
mask = Image.new("1", (N, N))
d = ImageDraw.Draw(mask)
left = [(15, 7), (9, 7), (4, 9), (2, 12), (3, 17), (6, 21), (9, 23), (11, 21), (13, 16), (15, 12)]
d.polygon(left, fill=1)
d.polygon([(N - 1 - x, y) for x, y in left], fill=1)
m = mask.load()
light, mid, dark, edge = (196, 196, 214), (150, 148, 178), (108, 104, 140), (52, 46, 80)
for y in range(N):
    for x in range(N):
        if not m[x, y]:
            continue
        border = any(not (0 <= x + dx < N and 0 <= y + dy < N and m[x + dx, y + dy])
                     for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
        if border:
            px[x, y] = edge
            continue
        # Feathers: stripes running from the spine out to the wing tip.
        dist = abs(x - 15.5)
        if y < 10:
            px[x, y] = light  # shoulder
        else:
            px[x, y] = (light, mid, mid, dark)[int(dist) % 4]
# Spine gap between the wings.
for y in range(7, 13):
    px[15, y] = px[16, y] = edge

# HUD corner brackets (white).
W = (240, 240, 240)
for (cx, cy, sx, sy) in ((1, 1, 1, 1), (30, 1, -1, 1), (1, 30, 1, -1), (30, 30, -1, -1)):
    for i in range(4):
        px[cx + sx * i, cy] = W
        px[cx, cy + sy * i] = W

# Green climb arrow, bottom centre.
G, Gd = (92, 220, 92), (40, 140, 40)
arrow = ["...G...", "..GGG..", ".GGGGG.", "GGGGGGG", "..GGG..", "..GGG..", "..GGG.."]
for j, row in enumerate(arrow):
    for i, ch in enumerate(row):
        if ch == "G":
            px[12 + i, 24 + j] = G if i < 4 or j < 4 else Gd

# Run from the repo root: python3 art/logo.py
img.resize((512, 512), Image.NEAREST).save("art/logo-512.png")
img.resize((128, 128), Image.NEAREST).save("pack.png")
