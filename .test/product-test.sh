trap 'test -z "$intrap" && export intrap=1 && kill -- -$$' SIGINT SIGTERM EXIT

shopt -s nullglob
shopt -s globstar
fails=0
passes=0
skips=0
total=0
mkdir -p .log
date > .log/RES
for suite in .product/**/.test/* ; do
    test -d $suite || continue
    echo TESTSUITE $suite:
    # if [ -f $(dirname "$suite")/up ] && ! $(dirname "$suite")/.check_prerequisites.sh ; then
    #     echo "*** SKIP $((++skips))/$((++total)) $suite"
    # fi
    # if [ -x "$suite"/.check_prerequisites.sh ] && ! $(dirname "$suite")/.check_prerequisites.sh ; then
    #    echo "*** SKIP $((++skips))/$((++total)) $suite"
    # fi
    # ./build_topology.sh $(dirname "$suite")

    for upscript in $suite/up.* ; do
        upmode=${upscript##*.}
        [ -z $1 ] || [ x$1 = x$upmode ] || continue 
        for t in $suite/*.sh ; do
            bash -e $t $upmode 2>&1 | tee .log/$(basename $t).$upmode
            res=${PIPESTATUS[0]}
            [ $res -gt 0 ] || echo "*** PASS $((++passes))/$((++total)) $t $upmode"
            [ $res -gt 0 ] || echo "*** PASS $t $upmode" >> .log/RES
            [ $res -eq 0 ] || echo "*** FAIL $((++fails))/$((++total)) $t $upmode"
            [ $res -eq 0 ] || echo "*** FAIL $t $upmode" >> .log/RES
            [ $res -eq 0 ] || [ x${AUTOSTOP} != x1 ] || exit 1
        done
    done
done
echo TOTAL : PASS / SKIP / FAIL
echo $total : $passes / $skips / $fails
cat .log/RES
( exit $fails )
