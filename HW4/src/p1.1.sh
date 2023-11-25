mpicxx ./hello.cc -o mpi_hello
sh ./copy2everynode.sh
mpirun -np 8 --hostfile hosts mpi_hello