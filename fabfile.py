from fabric.api import cd
from fabric.api import run


WORKSPACE = '/home/ubuntu/zvm-toolchain'
HOME = '/home/ubuntu'
ZEROVM_ROOT = '%s/zerovm' % HOME
ZVM_PREFIX = '%s/zvm-root' % HOME
ZRT_ROOT = '%s/zrt' % HOME
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

CLONE = """\
git clone $GITURL/linux-headers-for-nacl.git
git clone $GITURL/gcc.git
git clone $GITURL/glibc.git
git clone $GITURL/newlib.git
git clone $GITURL/binutils.git
git clone $GITURL/zerovm.git $ZEROVM_ROOT
git clone $GITURL/validator.git $ZEROVM_ROOT/valz
git clone $GITURL/zrt.git $ZRT_ROOT\
"""

VALIDATOR = """\
make validator
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so.0.9.0
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so.0
ln -s ./out/Release/libvalidator.so.0.9.0 libvalidator.so\
"""

ZEROVM = """\
make all install PREFIX=$ZVM_PREFIX\
"""

BUILD = """\
make -j8\
"""


def _run_with_env(env_dict, command):
    environ = ';'.join(['export %s=%s' % (k, v) for k, v in env_dict.items()])
    run('%s; %s' % (environ, command), pty=False)


def _run_script(script):
    for command in script.split('\n'):
        _run_with_env(ENV, command)


def run_all():
    clone()
    validator()
    zerovm()
    build()


def clone():
    _run_with_env(ENV, 'git clone $GITURL/toolchain.git $WORKSPACE')
    with cd('%s/SRC' % WORKSPACE):
        _run_script(CLONE)


def validator():
    with cd(VALZ):
        _run_script(VALIDATOR)


def zerovm():
    with cd(ZEROVM_ROOT):
        _run_script(ZEROVM)


def build():
    with cd(WORKSPACE):
        _run_script(BUILD)
