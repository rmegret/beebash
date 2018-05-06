#! /usr/bin/env python3
from configargparse import ArgParser
import os
from shlex import quote

BEE_PATH = quote(os.environ['BEE_PATH'])

p = ArgParser(default_config_files=[BEE_PATH+'config/cleantags.conf'])

p.add('-n', '--dryrun', help='perform a trial run with no changes made', action='store_true')
p.add('-o', '--output', help='path to output directory', env_var='BEE_DATA')
p.add('video', help='video to convert')
p.add('--family', help='video family', default="tag25h5inv")
p.add('--f0', help='frame start', type=int, default=0)
p.add('--f1', help='frame end', type=int, default=72100)
p.add('--ids', help="List of ids to avoid, eg. [1602,1603,1604]", default="[13,14,15,16]")
p.add('--hm', help='Hamming distance', type=int, default=2)
p.add('--bx', help='Excluding box, [left,top,right,bottom]', default="[175,30,2305,1240]")

args = p.parse_args()

video=os.path.realpath(args.video)
videofile=video.split('/')[-1]
videoname=videofile.split(".")[0]

cmd = f"sbatch -J cleantags-{quote(videofile)} -D {quote(args.output)}/logs {BEE_PATH}/bin/slurm-cleantags.sh {quote(videoname)} {quote(args.output)} {quote(args.ids)} {args.hm} {quote(args.bx)}"

if args.dryrun:
        print(cmd)
        print("Dryrun. Aborting...")
        quit()

os.system(cmd)