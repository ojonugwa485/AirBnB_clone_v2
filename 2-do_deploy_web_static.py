#!/usr/bin/python3
""" Does deployment"""

from fabric.api import *
import os

env.hosts = ["34.73.8.171", "34.74.18.52"]
env.user = "ubuntu"


def do_deploy(archive_path):
    """ Deploys archive to servers"""
    if not os.path.exists(archive_path):
        return False

    results = []

    res = put(archive_path, "/tmp")
    results.append(res.succeeded)

    basename = os.path.basename(archive_path)
    if basename[-4:] == ".tgz":
        name = basename[:-4]
    newdir = "/data/web_static/releases/" + name
    run("mkdir -p " + newdir)
    run("tar -xzf /tmp/" + basename + " -C " + newdir)

    run("rm /tmp/" + basename)
    run("mv " + newdir + "/web_static/* " + newdir)
    run("rm -rf " + newdir + "/web_static")
    run("rm -rf /data/web_static/current")
    run("ln -s " + newdir + " /data/web_static/current")

    return True