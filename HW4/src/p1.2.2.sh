mpicxx ./pi_block_tree.cc -o pi_block_tree
if [ $? -ne 0 ]; then
    echo "compile fail"
    exit 1
fi

sh ./copy2everynode.sh
if [ $? -ne 0 ]; then
    echo "copy fail"
    exit 1
fi

mpirun -np 4 --hostfile hosts pi_block_tree 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi

echo "run TA's pi_block_tree"
mpirun -np 4 --hostfile hosts /home/HW4/ref/pi_block_tree 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi