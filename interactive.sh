salloc \
--time=01:00:00 \
--account=project_2005380 \
--ntasks-per-node=1 \
--cpus-per-task=4 \
--nodes=1 \
-p \
gputest \
--gres=gpu:a100:1
