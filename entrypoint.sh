#!/bin/bash -eEux
shopt -s xpg_echo
shopt -s nullglob
shopt -s dotglob

cleanup() {
    rm -rf dist build *.egg-info .eggs
}

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
                echo "\x1b[45m\x1b[1;37mBuilding for $variant ... \x1b[0m"
                cleanup
                if $variant/bin/python setup.py clean --all bdist_wheel; then
                    auditwheel repair --wheel-dir=/wheelhouse dist/*.whl
                else
                    errors+=($variant)
                fi
            done
            set +x
            if [[ -n "${errors[@]:+${errors[@]}}" ]]; then
                echo '\x1b[41m\x1b[1;33mFAILED TO BUILD WHEEL FOR: \x1b[0m'
                for error in ${errors[@]}; do
                    echo "\x1b[41m\x1b[1;33m    ${error}\x1b[0m"
                done
            else
                whl_files=(/wheelhouse/*)
                if (( ${#whl_files[*]} )); then
                    echo "\x1b[44m\x1b[1;37mBUILT WHEELS:\x1b[0m"
                    mkdir -p /code/wheelhouse
                    for whl in $whl_files; do
                        echo "\x1b[1;32m- $(basename $whl)\x1b[0m"
                        mv $whl /code/wheelhouse
                    done
                else
                    if [[ -n "$(find dist -type f 2>/dev/null)" ]]; then
                        echo '\x1b[41m\x1b[1;33mNO VALID WHEELS (perhaps bdist_wheel produced universal wheels?)\x1b[0m'
                        echo '+ ls -al dist'
                        ls -al dist/
                    else
                        echo '\x1b[41m\x1b[1;33mNO VALID WHEELS (dist is empty)\x1b[0m'
                    fi
                fi
            fi
            cleanup
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

