trap 'test -n "$intrap" || { export intrap=1 && kill -- -$$ 2> /dev/null; } || :' SIGINT SIGTERM EXIT

shopt -s nullglob
shopt -s globstar
fails=0
passes=0
skips=0
total=0


tested_products="$1"
tested_modes="$2"

mkdir -p .log
date > .log/RES
for product in .product/* ; do
    [ -d "$product" ] || continue
    [ -z "$tested_products" ] || {
        product_found=""
        for tested_product in $tested_products; do
            [ $product != .product/$tested_product ] || product_found=1
        done
        test $product_found || continue
    }

    for suite in "$product"/**/.test/* ; do
        test -d $suite || continue
        echo TESTSUITE $suite:
        [[ ! $suite =~ .disabled ]] || continue
        # if [ -f $(dirname "$suite")/up ] && ! $(dirname "$suite")/.check_prerequisites.sh ; then
        #     echo "*** SKIP $((++skips))/$((++total)) $suite"
        # fi
        # if [ -x "$suite"/.check_prerequisites.sh ] && ! $(dirname "$suite")/.check_prerequisites.sh ; then
        #    echo "*** SKIP $((++skips))/$((++total)) $suite"
        # fi
        # ./build_topology.sh $(dirname "$suite")

        for upscript in $suite/up.* ; do
            upmode=${upscript##*.}
            [ -z "$tested_modes" ] || {
                mode_found=""
                for tested_mode in $tested_modes; do
                    [ $upmode != $tested_mode ] || mode_found=1
                done
                test $mode_found || continue
            }

            for t in $suite/*.sh ; do
                # use setsid to create new process group for each test, so they can clean own subprocesses properly
                setsid bash -e $t $upmode 2>&1 | tee .log/$(basename $t).$upmode
                res=${PIPESTATUS[0]}
                [ $res -gt 0 ] || echo "*** PASS $((++passes))/$((++total)) $t $upmode"
                [ $res -gt 0 ] || echo "*** PASS $t $upmode" >> .log/RES
                [ $res -eq 0 ] || echo "*** FAIL $((++fails))/$((++total)) $t $upmode"
                [ $res -eq 0 ] || echo "*** FAIL $t $upmode" >> .log/RES
                [ $res -eq 0 ] || [ x${AUTOSTOP} != x1 ] || exit 1
            done
        done
    done
done
echo TOTAL : PASS / SKIP / FAIL
echo $total : $passes / $skips / $fails
cat .log/RES
( exit $fails )
