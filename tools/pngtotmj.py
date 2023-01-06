#!/usr/bin/env python3
from PIL import Image
import pprint
import json
import math


NONE   = 0
SPAWN  = 1
IDK    = 2
BLOCK  = 3
TREE   = 4
EGG    = 5
METEOR = 6
BOMB   = 7
RANGE  = 8
SPEED  = 9


COLOR_TO_TILE = {
    (0xFF, 0x7F, 0x00): NONE,
    (0x00, 0xFF, 0x00): SPAWN,
    (0x62, 0x5D, 0x5D): BLOCK,
    (0x00, 0x77, 0x33): TREE,
    (0xFF, 0xFF, 0xFF): EGG,
    (0xD0, 0x2A, 0x2A): METEOR,
    (0xFF, 0x75, 0x63): BOMB,
    (0x3B, 0xD2, 0xEF): RANGE,
    (0x05, 0xFF, 0x95): SPEED,
}

PALETTE = list(COLOR_TO_TILE.keys())


def nearest_color(r, g, b, a):
    if (a != 0xFF):
        return (0xFF, 0xFF, 0xFF)

    nearest = None
    distance = 0

    for pr, pg, pb in PALETTE:
        d = (r - pr)**2 + (g - pg)**2 + (b - pb)**2
        if nearest is None or d < distance:
            nearest = (pr, pg, pb)
            distance = d

    return nearest


def convert(
    infile: str,
    convert: bool = False
) -> str:

    tiles = []
    width = height = 0
    with Image.open(infile) as img:
        img = img.convert('RGBA')
        pixels = img.load()
        width, height = img.size
        for y in range(width):
            for x in range(height):
                r, g, b, a = pixels[x, y]

                if convert:
                    r, g, b = nearest_color(r, g, b, a)

                tilenum = COLOR_TO_TILE[(r, g, b)]
                tiles.append(tilenum)

    base = json.load(open('../res/baseJson.json'))
    layer = json.load(open('../res/layerJson.json'))

    base['width'] = width
    base['height'] = height
    layer['width'] = width
    layer['height'] = height
    layer['data'] = tiles
    base['layers'] = [layer]

    return json.dumps(base, indent=2)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'filename',
        type=str,
        help='png file',
    )
    parser.add_argument(
        '--convert',
        action='store_true',
    )
    parser.add_argument(
        '--output',
        '-o',
        type=str,
        default=None,
        help='output file'
    )
    args = parser.parse_args()

    data = convert(args.filename, convert=args.convert)

    if args.output is None:
        print(data)
    else:
        with open(args.output, 'w') as f:
            f.write(data)
