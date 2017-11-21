#!/usr/bin/env python3

from subprocess import call
import os

def main():

    '''Launch SLURM apriltag detect with either single frame or multi-frame JSON output.'''
    
    from argparse import ArgumentParser

    # for some reason pylint complains about members being undefined :(
    # pylint: disable=E1101

    parser = ArgumentParser(
        description='Detect tags in videos.')
        
    show_default = ' (default %(default)s)'

    parser.add_argument('video', metavar='VIDEO',
                        help='video to use')

    parser.add_argument('-F', '--family-preset', dest='family', default='tag25h5inv',
                        help='Family preset: detect "inv" at the end of the name to set both "family" and "inverse"')
    parser.add_argument('-f0', dest='f0', default=0, type=int,
                        help='Frame start '+ show_default)
    parser.add_argument('-f1', dest='f1', default=72100, type=int,
                        help='Frame end '+ show_default)
    parser.add_argument('-step', dest='step', default=10000, type=int,
                        help='Max split interval '+ show_default)
    parser.add_argument('-rerun', dest='rerun', default=-1, type=int,
                        help='Rerun a split session '+ show_default)
                        
    parser.add_argument('-fps', dest='fps', default=20.0, type=float,
                        help='fps '+ show_default)

    parser.add_argument('-d', dest='dryrun', default=False, 
                        action='store_true',
                        help='only show actions to be taken '+ show_default)
                                                
    parser.add_argument('-o', dest='dirbaseout', default='/work/rmegret/rmegret/tags', 
                        help='Basedir to output tags '+ show_default)
    parser.add_argument('-t','-time', dest='time', default='4:30:00', help='Override TIMELIMIT parameter, format H:MM:SS'+ show_default)


    options = parser.parse_args()
    
    print(options)
    
    video=options.video
    
    videofile=video.split('/')[-1]
    videoname=os.path.splitext(videofile)[0]
    
    dirout=options.dirbaseout+'/'+videoname

    print("""video={video}
videoname={videoname}
family={family}
f0={f0}
f1={f1}
step={step}
fps={fps}
dirbaseout={dirbaseout}
dirout={dirout}
dryrun={dryrun}
""".format(**vars(options),dirout=dirout,videoname=videoname))
           
    count = (options.f1-options.f0+options.step)//options.step
           
    print("\n### {f0}-{f1} with step={step}".format(f0=options.f0,f1=options.f1,step=options.step))
    
    for i in range(count):
        ff0 = options.f0+i*options.step
        ff1 = min(options.f1,ff0+options.step-1)
        print("  id={id}:  {ff0}-{ff1}".format(id=i,ff0=ff0,ff1=ff1))

    if (count>1):    
        usearray=True
        if (options.rerun==-1):
            params=["sbatch", "-J", "tags-{}-{}-{}".format(videoname,options.f0,options.f1), 
            "--array=0-{}".format(count-1), "--time="+options.time,
            "/work/rmegret/rmegret/utils/bash/slurm-apriltag-m.sh", dirout,
            options.video, options.family, str(options.f0), str(options.f1), 
            str(options.fps), str(options.step)]
            print(" ".join(params))
            if (not options.dryrun):
                call(params)
        else:
            print("Rerunning batch #{}".format(options.rerun))
            for i in [ options.rerun ]:
                ff0 = options.f0+i*options.step
                ff1 = min(options.f1,ff0+options.step-1)
                params=["sbatch", "-J", "tags-{}-{}-{}".format(videoname,ff0,ff1),
                "--time="+options.time,
                "/work/rmegret/rmegret/utils/bash/slurm-apriltag-m.sh", dirout,
                options.video, options.family, str(ff0), str(ff1),
                str(options.fps), str(options.step)]
                print(" ".join(params))
                if (not options.dryrun):
                    call(params)
    else:
        params=["sbatch", "-J", "tags-{}-{}-{}".format(videoname,options.f0,options.f1),
            "/work/rmegret/rmegret/utils/bash/slurm-apriltag-m.sh", dirout, "--time="+options.time,
            options.video, options.family, str(options.f0), str(options.f1), 
            str(options.fps)]
        print(" ".join(params))
        if (not options.dryrun):
            call(params)


if __name__ == '__main__':

    main()


