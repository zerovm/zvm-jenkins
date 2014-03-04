import subprocess as sp
import sys

from datetime import datetime as dt
from debian import changelog


DEFAULT_RELEASE = 1


def latest_package(fullname, email, pkg_name, version, ppa=None):
    """
    Generate and prepend an entry to the debian/changelog, the create a
    "latest" package. Changelog entry details are generated from the latest
    commit in git and the current date/time.
    """
    short_hash, merge_msg = _get_hash_merge_msg()
    now = dt.utcnow()
    _update_changelog(short_hash, merge_msg, fullname, email, pkg_name,
                      version, now)
    src_pkg_file = _create_package(
        pkg_name, version, short_hash, now
    )
    if ppa is not None:
        _publish_package(src_pkg_file, ppa)


def _sp_run(cmd):
    return sp.check_call(cmd, shell=True)


def _create_package(pkg_name, version, short_hash, now):
    """
    Create a source package and return the file name of the .changes file.
    """
    tar_name = '%(pkg)s_%(version)s-%(dt_int)s-git%(short_hash)s.orig.tar.gz'
    tar_name %= dict(pkg=pkg_name,
                     version=version,
                     dt_int=now.strftime('%Y%m%d%H%M%S'),
                     short_hash=short_hash)
    pkg_file = ('%(pkg)s_%(version)s-%(dt_int)s-git%(short_hash)s-%(rel)s'
                '%%(suffix)s')
    pkg_file %= dict(
        pkg=pkg_name,
        version=version,
        dt_int=now.strftime('%Y%m%d%H%M%S'),
        short_hash=short_hash,
        rel=DEFAULT_RELEASE,
    )
    src_pkg_file = pkg_file % dict(suffix='_source.changes')

    archive = ('tar czf ../%(tar)s * --exclude=debian')
    archive %= dict(tar=tar_name)
    _sp_run(archive)

    # build a source package
    _sp_run('debuild -S')

    return src_pkg_file


def _publish_package(src_package_file, ppa):
    publish = 'dput %(ppa)s ../%(src_pkg)s'
    publish %= dict(src_pkg=src_package_file, ppa=ppa)
    _sp_run(publish)


def _get_hash_merge_msg():
    """
    Get the the short hash and merge message from the latest git commit, which
    is assumed to be a merge commit.
    """
    cmd = 'git log -n 1 --abbrev-commit'
    output = sp.check_output(cmd.split()).strip().split('\n')
    short_hash = output[0].split()[1]
    merge_msg = output[-1].strip()

    return short_hash, merge_msg


def _update_changelog(short_hash, merge_msg, fullname, email, pkg_name,
                      version, now):
    """
    Re-write the changelog, prepending the new generated entry.
    """
    new_version = '%s-%s-git%s-%s' % (version, now.strftime('%Y%m%d%H%M%S'),
                                      short_hash, DEFAULT_RELEASE)
    sp.check_call(['dch', '-v', new_version, merge_msg],
                  env={'DEBFULLNAME': fullname, 'DEBEMAIL': email})


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Usage: python %s NAME EMAIL [PPA]\n'
              'PPA (optional) should include the `ppa` prefix. Example: '
              'ppa:zerovm-ci/zervovm-latest' % __file__)
        sys.exit(1)

    fullname = sys.argv[1]
    email = sys.argv[2]

    # PPA publishing is optional
    ppa = None
    if len(sys.argv) == 4:
        ppa = sys.argv[3]

    # parse the upstream version and package name from the changelog
    with open('debian/changelog') as cl_fp:
        cl = changelog.Changelog(cl_fp)
        pkg_name = cl.get_package()
        version = cl.version.upstream_version
    latest_package(fullname, email, pkg_name, version, ppa=ppa)
