## QNIBTerminal image
FROM qnib/slurm

ADD etc/supervisord.d/slurmd.ini /etc/supervisord.d/
ADD etc/consul.d/check_slurmd.json /etc/consul.d/
ADD /opt/qnib/slurm/bin/check_slurmd.sh /opt/qnib/slurm/bin/
