#!/bin/bash
COUNT="$(cat test.txt | wc -l)"
echo $(( $COUNT / 4 )) >> ../output_temp.txt
