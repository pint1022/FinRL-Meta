#!/bin/bash

docker build -f docker/Dockerfile --network=host -t finrlmeta .
