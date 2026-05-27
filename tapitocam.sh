#!/bin/bash
# tapitocam.sh - TP-Link Tapo Camera RSTP Client
mpv --profile=low-latency --untimed --cache=no --demuxer-readahead-secs=0 --vd-lavc-threads=1 --rtsp-transport=udp --demuxer-lavf-o-add=fflags=+nobuffer --demuxer-lavf-o-add=probesize=32 --demuxer-lavf-o-add=analyzeduration=0 --video-sync=audio "rtsp://dressedinblack:Abrilchulito202X@192.168.2.200/stream1"
