#!/usr/bin/env bash


if [[ $RANDOM -gt 15000 ]]
then
  echo "build failed!"
  exit 1
fi


echo "build succeeded!"