#! /usr/bin/env bash
#=========================================================================
# Copyright (c) 2015, 2016 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#
#   MIT license: https://github.com/GsDevKit/GsDevKit_home/blob/master/license.txt
#=========================================================================

theArgs="$*"
source ${GS_HOME}/bin/private/shFeedback
start_banner

usage() {
  cat <<HELP
USAGE: $(basename $0) [-h] [-c https | ssh ] [-o <organization-name>]

OPTIONS
  -h
     display help
  -c https | ssh
     clone using https (https://github.com) or ssh (git@github.com).
     https is the default.
  -o <organization-name>
     use <organization-name> instead of GsDevKit. Use this option when
     you've forked the other GsDevKit_* projects.

EXAMPLES
   $(basename $0) -h
   $(basename $0)

HELP
}

if [ "${GS_HOME}x" = "x" ] ; then
   exit_1_banner "The \$GS_HOME environment variable needs to be defined"
fi
source ${GS_HOME}/bin/defGsDevKit.env

modeArg=""
organizationArg=""
while getopts "hc:o:" OPT ; do
  case "$OPT" in
    h) usage; exit 0;;
    c) modeArg=" -c ${OPTARG} ";;
    o) organizationArg=" -o ${OPTARG} ";;
    *) usage; exit_1_banner "Uknown option";;
  esac
done
shift $(($OPTIND - 1))

if [ $# -ne 0 ]; then
  usage; exit_1_banner "Unexpected argument ($1)"
fi

$GS_HOME/bin/setupGsDevKit $modeArg $organizationArg server

exit_0_banner "...finished"
