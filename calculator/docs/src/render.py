"""SVG → PNG. Пробует rsvg-convert, cairosvg, затем node + sharp (что найдётся)."""
import shutil
import subprocess
from pathlib import Path

IMG = Path(__file__).resolve().parent.parent / 'images'


def img(name):
    return str(IMG / name)


def render(svg, png, scale=2):
    if shutil.which('rsvg-convert'):
        subprocess.run(['rsvg-convert', '-z', str(scale), '-b', 'white', '-o', png, svg], check=True); return
    try:
        import cairosvg
        cairosvg.svg2png(url=svg, write_to=png, scale=scale, background_color='white'); return
    except ImportError:
        pass
    subprocess.run(['node', '-e', f"require('sharp')('{svg}',{{density:{72*scale}}}).flatten({{background:'#fff'}}).png().toFile('{png}').then(()=>0)"], check=True)
