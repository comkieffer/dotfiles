"""
Install all the packages for the base system.

Do not urun this file directly. It won't work. Instead run:

$ pyinfra @local __file__
"""

from pyinfra.operations import apt, git

USE_SUDO_PASSWORD = True

# Note:
# `iwyu` needs access to the clang-common resources for the version of libclang it was
# built against. The easiest way to achieve this is to install the right `clang-common`
# package. As of 2021-01 it is `clang-common-9-dev`.
#

apt.packages(
    name="C++ Development Environment / Install Core Packages",
    packages=["build-essential", "cmake", "cmake-qt-gui", "clang", "iwyu", "clang-common-9-dev"],
    latest=True, sudo=True,
)
