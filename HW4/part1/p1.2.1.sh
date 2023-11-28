mpicxx ./pi_block_linear.cc -o pi_block_linear
if [ $? -ne 0 ]; then
    echo "compile fail"
    exit 1
fi

sh ./copy2everynode.sh
if [ $? -ne 0 ]; then
    echo "copy fail"
    exit 1
fi

echo "run my pi_block_linear"
mpirun -np 4 --hostfile hosts pi_block_linear 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi

echo "run TA's pi_block_linear"
mpirun -np 4 --hostfile hosts /home/HW4/ref/pi_block_linear 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi