#!/bin/bash

echo "Ecut, Energy(Ryd)" > collection.dat
for arg in "$@"; do
	ecut=$(grep "kinetic-energy" $arg | awk -F= '{print $2}' | awk '{print $1}')
	energy=$(grep "!" $arg | awk -F= '{print $2}' | awk '{print $1}')
	echo "$ecut, $energy" >> collection.dat
done
