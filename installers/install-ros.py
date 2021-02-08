"""
Install ROS packages.

Do not run this file directly. It won't work. Instead run:

$ pyinfra @local __file__
"""

from pyinfra.operations import apt

USE_SUDO_PASSWORD = True

ROS_VERSION="noetic"

apt.key(
    name="Install Packages / ROS / Add GPG Key",
    keyserver="keyserver.ubuntu.com",
    keyid="C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654", sudo=True,
)

apt.repo(
    name="Install Packages / ROS / Add Repo",
    src="deb  http://packages.ros.org/ros/ubuntu focal main",
    filename="owncloud",
    sudo=True,
)

# Note: catkin tools is broken until the OSRF push new packages.
# See this issue for a fix:
#   https://github.com/catkin/catkin_tools/issues/594
# The interim solution is install the git version:
#   pipx install "git+https://github.com/catkin/catkin_tools.git"

apt.packages(
    name="Install Packages / ROS / Install Packages",
    packages=[f"ros-{ROS_VERSION}-desktop", "python3-rosdep"])
    sudo=True, update=True,
)

# TODO: sudo rosdep init && rosdep update

# to install workspace package.
# rosdep install --from-paths src --ignore-src -r -y
