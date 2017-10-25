#!/bin/bash -eEux
shopt -s xpg_echo

if [[ ! -e /code ]]; then
    set +x
    echo '\x1b[41m\x1b[1;33mERROR: Make sure you have mounted something in /code.\x1b[0m

Eg:

    docker run --rm --user $UID -itv $(pwd):/code ionelmc/manylinux-64bit
'
    exit 1
else
    cd /code
    if [[ -z "${1:-}" ]]; then
        errors=()
        for variant in /opt/python/*; do
            rm -rf dist build *.egg-info .eggs
            if $variant/bin/python setup.py clean --all bdist_wheel; then
                auditwheel repair dist/*.whl
            else
                errors+=($variant)
            fi
        done
        rm -rf dist build *.egg-info .eggs
        set +x
        if [[ -n "$errors" ]]; then
            echo '\x1b[41m\x1b[1;33mFAILED TO BUILD WHEEL FOR\x1b[0m'
            for error in ${errors[@]}; do
                echo "\x1b[41m\x1b[1;33m    ${error}\x1b[0m"
            done
        fi
    else
        exec "$@"
    fi
fi

