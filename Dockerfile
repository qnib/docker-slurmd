FROM qnib/slurm
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/supervisord.d/slurmd.ini /etc/supervisord.d/
ADD etc/consul.d/check_slurmd.json /etc/consul.d/
ADD opt/qnib/jobscripts/ /opt/qnib/jobscripts/
ADD opt/qnib/bin/gemm_block_mpi_50ms /opt/qnib/bin/
ADD opt/qnib/bin/gemm_block_mpi_250ms /opt/qnib/bin/
ADD opt/qnib/bin/gemm_block_mpi_500ms /opt/qnib/bin/
ADD opt/qnib/bin/generate_work.sh /opt/qnib/bin/generate_work.sh
