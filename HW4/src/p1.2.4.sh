mpicxx ./pi_gather.cc -o pi_gather
if [ $? -ne 0 ]; then
    echo "compile fail"
    exit 1
fi

sh ./copy2everynode.sh
if [ $? -ne 0 ]; then
    echo "copy fail"
    exit 1
fi

mpirun -np 4 --hostfile hosts pi_gather 1000000000
if [ $? -ne 0 ]; then
    echo "run fail"
    exit 1
fi