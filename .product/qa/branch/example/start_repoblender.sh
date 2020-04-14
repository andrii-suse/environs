set -e
mkdir -p __workdir/openqa/share/factory/iso
mkdir -p __workdir/openqa/testresults/


mkdir -p __workdir/openqa/share/factory/hdd/

hdd=openSUSE-Leap-15.1-JeOS.x86_64-15.1.0-kvm-and-xen-Current.qcow2

( cd __workdir/openqa/share/factory/hdd/ &&
[ -f $hdd ] || wget -q https://download.opensuse.org/distribution/leap/15.1/jeos/$hdd )

mkdir -p __workdir/openqa/share/repoblender/tests
ln -sf /home/an/andrii-suse/os-autoinst-distri-repositories __workdir/openqa/share/repoblender/tests
mkdir -p __workdir/openqa/share/repoblender/tests/os-autoinst-distri-repositories
# ln -sf __workdir/os-autoinst/t/data/tests/needles __workdir/openqa/share/

# "NEEDLES_DIR" : "__workdir/openqa/share/needles",

generate_data() {
    cat <<EOF
{
"ARCH" : "x86_64",
"ASSETDIR" : "__workdir/openqa/share/factory",
"BACKEND" : "qemu",
"CASEDIR" : "__workdir/openqa/share/repoblender/tests/os-autoinst-distri-repositories",
"HDD_1" : "openSUSE-Leap-15.1-JeOS.x86_64-15.1.0-kvm-and-xen-Current.qcow2",
"PRJDIR" : "__workdir/openqa/share/repoblender/tests/os-autoinst-distri-repositories",
"PROJECT" : "Apache:Test",
"REPOSITORY" : "openSUSE_Leap_15.1",
"PRODUCTDIR" : "__workdir/openqa/share/repoblender/tests/os-autoinst-distri-repositories",
"QEMU" : "x86_64",
"QEMU_NO_FDC_SET" : "1",
"QEMU_NO_KVM" : "1",
"QEMU_NO_TABLET" : "1",
"TEST" : "repoblender",
"WORKER_HOSTNAME" : "127.0.0.1",
}
EOF
}

port=$((__wid * 10 + 9526))

generate_data > __workdir/example/param.json

__srcdir/script/client --param __workdir/example/param.json --host http://127.0.0.1:${port} --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF jobs post
