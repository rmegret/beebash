#! /usr/bin/env python3
from configargparse import ArgParser
import os
from shlex import quote

BEE_PATH = quote(os.environ['BEE_PATH'])

p = ArgParser(default_config_files=[BEE_PATH+'config/mergetags.conf'])

p.add('-n', '--dryrun', help='perform a trial run with no changes made', action='store_true')
p.add('-o', '--output', help='path to output directory', env_var='BEE_DATA')
p.add('video', help='video to convert')
p.add('--f0', help='frame start', type=int, default=0)
p.add('--f1', help='frame end', type=int, default=72100)

args = p.parse_args()

video=os.path.realpath(args.video)
videofile=video.split('/')[-1]
videoname=videofile.split(".")[0]

cmd = f"sbatch -J mergetags-{quote(videofile)} -D {quote(args.output)}/logs {BEE_PATH}/bin/slurm-mergetags.sh {quote(videoname)} {quote(args.output)} {args.f0} {args.f1}"

if args.dryrun:
	print(cmd)
	print("Dryrun. Aborting...")
	quit()

os.system(cmd)
