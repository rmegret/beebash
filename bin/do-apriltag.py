#! /usr/bin/env python3
from configargparse import ArgParser
import os
from shlex import quote

p = ArgParser(default_config_files=['config/apriltag.conf'])

p.add('-n', '--dryrun', help='perform a trial run with no changes made', action='store_true')
p.add('-o', '--output', help='path to output directory', default="/work/rmegret/rmegret/tags")
p.add('video', help='video to convert')
p.add('--family', help='video family', default="tag25h5inv")
p.add('--f0', help='frame start', type=int, default=0)
p.add('--f1', help='frame end', type=int, default=10)
p.add('--fps', help='frames per second', default=20, type=int)

args = p.parse_args()

video=os.path.realpath(args.video)
videofile=video.split('/')[-1]
videoname=videofile.split(".")[0]
videodate=videoname.split("_")[-1]

cmd = f"sbatch -J {quote(args.family)}-{args.f0}-{args.f1}-{quote(videofile)} bin/slurm-apriltag.sh {quote(args.output)}/{quote(videoname)}/{quote(args.family)} {quote(videofile)} {quote(args.family)} {args.f0} {args.f1} {args.fps}"

if args.dryrun:
	print(cmd)
	print("Dryrun. Aborting...")
	quit()

# os.system(cmd)
print(cmd)