# delete all files in every node and copy the whole NYCU_Parallel_Programming folder to every node
parallel-ssh -h hostExceptMaster.txt -i rm -rf ~/NYCU_Parallel_Programming
parallel-scp -h hostExceptMaster.txt -r ~/NYCU_Parallel_Programming ~