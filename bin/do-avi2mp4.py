#! /usr/bin/env python3
from configargparse import ArgParser
import os
from shlex import quote

p = ArgParser(default_config_files=['config/avi2mp4.conf'])

p.add('-n', '--dryrun', help='perform a trial run with no changes made', action='store_true')
p.add('-o', '--output', help='path to output directory', default="/work/rmegret/rmegret/videos/Gurabo")
p.add('video', help='video to convert')

args = p.parse_args()

video=os.path.realpath(args.video)
videofile=video.split('/')[-1]
videoname=videofile.split(".")[0]
videodate=videoname.split("_")[-1]

print(f"Converting video {videofile} and saving to {args.output}/{videoname}.mp4")
cmd = f"sbatch -J avi2mpg-{quote(videodate)} bin/slurm-avi2mpg.sh {quote(video)} -o {quote(args.output)}"

if args.dryrun:
	# print("Dry run: Converting video {videofile} and saving to {args.output}/{videoname}.mp4"
	print(cmd)
	print("Dryrun. Aborting...")
	quit()

# os.system(cmd)
print(cmd)