import os
import re
import sys

import taglib


def na(s):
    return None if s == "NA" else s


name = sys.argv[1]

song = taglib.File(name)
m = re.fullmatch(r"(.+)@(.+)@(.+)@(.+)@(.+)@(.+)\.flac", name)
assert m

if title := song.tags.get("TITLE"):
    track = title[0]
else:
    track = na(m[1]) or m[2]

if not song.tags.get("ALBUM"):
    song.tags["ALBUM"] = [track]

if not song.tags.get("ARTIST"):
    try:
        artist = next(
            re.finditer(r"Associated  Performer: (.*)", song.tags["DESCRIPTION"][0])
        )[1]
    except (IndexError, KeyError, StopIteration):
        artist = na(m[3]) or na(m[4]) or na(m[5]) or m[6]
    song.tags["ARTIST"] = artist

song.save()
os.rename(name, f"{track} - {song.tags['ARTIST'][0]}.flac")
