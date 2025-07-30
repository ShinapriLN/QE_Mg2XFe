#!/bin/bash

echo "Kpoints, Energy(Ryd)" > collection.dat
for arg in "$@"; do
	kp=$(echo "${arg}" | cut -d "_" -f 3 | cut -d "." -f 1)
	ecut=$(grep "kinetic-energy" $arg | awk -F= '{print $2}' | awk '{print $1}')
	energy=$(grep "!" $arg | awk -F= '{print $2}' | awk '{print $1}')
	echo "$kp, $energy" >> collection.dat
done
