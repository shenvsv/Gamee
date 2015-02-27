#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rm -fr $DIR/obj/*
rm -fr $DIR/libs/armeabi/*.so
rm -fr $DIR/assets/res/*
rm -fr $DIR/assets/scripts/*

