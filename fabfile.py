from fabric.api import local
from fabric.api import sudo
from fabric.api import cd
from fabric.api import lcd
from fabric.api import run
from fabric.context_managers import shell_env


WORKSPACE = '/home/ubuntu/zvm-toolchain'
OTHER_LIBS = '%s/other_libs' % WORKSPACE
ZEROVM_ROOT = '%s/zerovm' % OTHER_LIBS
ZVM_PREFIX = '%s/zvm-root' % OTHER_LIBS
ZRT_ROOT = '%s/zrt' % OTHER_LIBS
VALZ = '%s/valz' % ZEROVM_ROOT
PATH = '%s/bin:%s:$PATH' % (ZVM_PREFIX, VALZ)

ENV = dict(
    WORKSPACE=WORKSPACE,
    GITURL='https://github.com/zerovm',
    ZEROVM_ROOT=ZEROVM_ROOT,
    ZVM_PREFIX=ZVM_PREFIX,
    ZRT_ROOT=ZRT_ROOT,
    PATH=PATH,
    VALZ=VALZ,
    LIBRARY_PATH=VALZ,
    LD_LIBRARY_PATH=VALZ,
)

SCRIPT = """\
git clone $GITURL/toolchain.git $WORKSPACE
cd $WORKSPACE/SRC
git clone $GITURL/linux-headers-for-nacl.git
git clone $GITURL/gcc.git
git clone $GITURL/glibc.git
git clone $GITURL/newlib.git
git clone $GITURL/binutils.git
git clone $GITURL/zerovm.git $ZEROVM_ROOT
git clone $GITURL/validator.git $ZEROVM_ROOT/valz
git clone $GITURL/zrt.git $ZRT_ROOT

cd $VALZ
make validator
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so.0.9.0
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so.0
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so

cd $ZEROVM_ROOT
make all install PREFIX=$ZVM_PREFIX

cd $WORKSPACE
make -j8
"""


def test():
    with shell_env(**ENV):
        for cmd in SCRIPT.split('\n'):
            run(cmd)
