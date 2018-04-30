#! /usr/bin/env python3
from configargparse import ArgParser
import os
from shlex import quote

p = ArgParser(default_config_files=['config/cleantags.conf'])

p.add('-n', '--dryrun', help='perform a trial run with no changes made', action='store_true')
p.add('-o', '--output', help='path to output directory', default="/work/rmegret/rmegret/tags")
p.add('video', help='video to convert')
p.add('--family', help='video family', default="tag25h5inv")
p.add('--f0', help='frame start', type=int, default=0)
p.add('--f1', help='frame end', type=int, default=72100)

args = p.parse_args()

video=os.path.realpath(args.video)
videofile=video.split('/')[-1]

cmd = f"sbatch -J cleantags-{quote(videofile)} bin/slurm-cleantags.sh {quote(videofile)} {quote(args.output)}"

if args.dryrun:
	print(cmd)
	print("Dryrun. Aborting...")
	quit()

# os.system(cmd)
print(cmd)