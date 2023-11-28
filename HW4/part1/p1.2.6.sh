mpicxx ./pi_one_side.cc -o pi_one_side
if [ $? -ne 0 ]; then
    echo "compile fail"
    exit 1
fi

sh ./copy2everynode.sh
if [ $? -ne 0 ]; then
    echo "copy fail"
    exit 1
fi

echo "run my pi_one_side"
mpirun -np 4 --hostfile hosts pi_one_side 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi

echo "run TA's pi_one_side"
mpirun -np 4 --hostfile hosts /home/HW4/ref/pi_one_side 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi
