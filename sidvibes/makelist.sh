#!/bin/bash

find ../C64Music/ -type f -name *.sid | sed 's/..\/C64Music//g' > sidlist.txt

