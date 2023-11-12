#! /bin/bash

rm output.txt
touch output.txt

for i in {1..1000}
do
    ./pi.out 8 100000000 >> output.txt
    if [ $(($i%100)) -eq 0 ]
    then
        echo $i
    fi
done

cat output.txt | grep 3.141 | wc