#!/bin/sh

#   Copyright (C) 2016 Deepin, Inc.
#
#   Author:     Li LongYu <lilongyu@linuxdeepin.com>
#               Peng Hao <penghao@linuxdeepin.com>

#               Vufa <countstarlight@gmail.com>

version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

BOTTLENAME="Deepin-TIM"
APPVER="9.3.2deepin20"
WINEPREFIX="$HOME/.deepinwine/$BOTTLENAME"
TIM_VER="3.3.9.22051"
EXEC_PATH="c:/Program Files/Tencent/TIM/Bin/TIM.exe"
START_SHELL_PATH="/opt/deepinwine/tools/run_v4.sh"
TIM_INSTALLER_PATH="c:/Program Files/Tencent/TIM$TIM_VER.exe"
export MIME_TYPE=""
export DEB_PACKAGE_NAME="com.qq.office.deepin"
export APPRUN_CMD="deepin-wine5"
DISABLE_ATTACH_FILE_DIALOG=""

export SPECIFY_SHELL_DIR=`dirname $START_SHELL_PATH`

ARCHIVE_FILE_DIR="/opt/apps/$DEB_PACKAGE_NAME/files"

export WINEDLLPATH=/opt/$APPRUN_CMD/lib:/opt/$APPRUN_CMD/lib64

OpenWinecfg()
{
    env WINEPREFIX=$WINEPREFIX $APPRUN_CMD winecfg
}

Run()
{
    if [ -z "$DISABLE_ATTACH_FILE_DIALOG" ];then
        export ATTACH_FILE_DIALOG=1
    fi

    if [ -n "$EXEC_PATH" ];then
        if [ ! -f "$WINEPREFIX/reinstalled" ];then
            env LC_ALL=zh_CN.UTF-8 WINEDLLOVERRIDES="winemenubuilder.exe=d" $START_SHELL_PATH $BOTTLENAME $APPVER "$TIM_INSTALLER_PATH" "$@"
            touch $WINEPREFIX/reinstalled
        else
            env LC_ALL=zh_CN.UTF-8 $START_SHELL_PATH $BOTTLENAME $APPVER "$EXEC_PATH" "$@"
        fi
    else
        env LC_ALL=zh_CN.UTF-8 $START_SHELL_PATH $BOTTLENAME $APPVER "uninstaller.exe" "$@"
    fi
}

HelpApp()
{
	echo " Extra Commands:"
	echo " winecfg        Open winecfg"
	echo " -h/--help      Show program help info"
}

if [ -z $1 ]; then
	Run "$@"
	exit 0
fi
case $1 in
	"winecfg")
		OpenWinecfg
		;;
	"-h" | "--help")
		HelpApp
		;;
	*)
		Run "$@"
		;;
esac
exit 0
