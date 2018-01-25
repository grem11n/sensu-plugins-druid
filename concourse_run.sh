#!/bin/bash - 
#===============================================================================
#
#          FILE: concourse_run.sh
# 
#         USAGE: ./concourse_run.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 01/25/2018 10:56
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
bundle install
bundle exec rake default
gem build sensu-plugins-druid.gemspec
gem install sensu-plugins-druid-*.gem

