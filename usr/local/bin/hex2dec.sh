#!/bin/bash
echo "Type a hex number"
for ((; ;))
do
    read hexNum
    echo $(( 16#$hexNum ))
done

