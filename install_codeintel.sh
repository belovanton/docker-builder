#!/bin/bash

easy_install pip
pip install -U pip
pip install -U virtualenv

virtualenv --python=python2 $HOME/.c9/python2
source $HOME/.c9/python2/bin/activate

mkdir /tmp/codeintel
pip install --download /tmp/codeintel codeintel==0.9.3

cd /tmp/codeintel
tar xf CodeIntel-0.9.3.tar.gz
mv CodeIntel-0.9.3/SilverCity CodeIntel-0.9.3/silvercity
tar czf CodeIntel-0.9.3.tar.gz CodeIntel-0.9.3
pip install -U --no-index --find-links=/tmp/codeintel codeintel