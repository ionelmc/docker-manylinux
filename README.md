# docker-manylinux

This image:

- disables python 2.6
- has libffi/cffi preinstalled
- automatically builds the wheels (with proper cleanup and so on)
- gives some help about usage

Suggested usages:

    docker run --rm --user $UID -itv $(pwd):/code ionelmc/manylinux list
    docker run --rm --user $UID -itv $(pwd):/code ionelmc/manylinux cp3

You can also run arbitrary commands:
    
    docker run --rm --user $UID -itv $(pwd):/code ionelmc/manylinux bash


Build details: https://hub.docker.com/r/ionelmc/manylinux
