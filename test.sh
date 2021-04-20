#!/usr/bin/env bash

function RUN_TEST {
	nim c -r $1
	rm $1
}

cd tests
RUN_TEST test_rodster
cd ..
