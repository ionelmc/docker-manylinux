#!/bin/bash -eEux
shopt -s xpg_echo

if [[ ! -e /code ]]; then
    set +x
    echo '\x1b[41m\x1b[1;33mERROR: Make sure you have mounted something in /code.\x1b[0m

Eg:

    docker run --rm --user $UID -itv $(pwd):/code ionelmc/manylinux
'
    exit 1
else
    cd /code
    cmd="${1:-}"
    case $cmd in
        (cp[0-9]*|"")
            errors=()
            for variant in /opt/python/$cmd*; do
                echo "\x1b[45m\x1b[1;37m Building for $variant ... \x1b[0m"
                rm -rf dist build *.egg-info .eggs
                if $variant/bin/python setup.py clean --all bdist_wheel; then
                    auditwheel repair dist/*.whl
                else
                    errors+=($variant)
                fi
            done
            rm -rf dist build *.egg-info .eggs
            set +x
            if [[ -n "${errors[@]:+${errors[@]}}" ]]; then
                echo '\x1b[41m\x1b[1;33m FAILED TO BUILD WHEEL FOR: \x1b[0m'
                for error in ${errors[@]}; do
                    echo "\x1b[41m\x1b[1;33m    ${error}\x1b[0m"
                done
            else
                echo "\x1b[44m\x1b[1;37m BUILT WHEELS: \x1b[0m"
                echo "\x1b[1;32m$(ls -al wheelhouse)\x1b[0m"
            fi
        ;;
        (list)
            set +x
            echo "\x1b[32mAvailable pythons:\x1b[0m"
            for variant in /opt/python/*; do
                echo "\x1b[1;32m    $(basename $variant)"
            done
        ;;
        (*)
            exec "$@"
        ;;
    esac
fi

