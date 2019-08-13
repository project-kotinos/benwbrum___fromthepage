#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive
export CI=true
export TRAVIS=true
export CONTINUOUS_INTEGRATION=true
export USER=travis
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export RAILS_ENV=test
export RACK_ENV=test
export MERB_ENV=test
export JRUBY_OPTS="--server -Dcext.enabled=false -Xcompile.invokedynamic=false"


apt-get update && apt-get install -y tzdata ghostscript graphviz libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
gem install bundler -v 2.0.1

# before_install
export QMAKE=/usr/lib/x86_64-linux-gnu/qt5/bin/qmake
qtchooser -qt=qt5
bash travis/.travis_setup.sh
# install
bundle install --jobs=3 --retry=3
# before_script
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:fixtures:load FIXTURES_PATH=spec/fixtures
# script
xvfb-run bundle exec rspec
