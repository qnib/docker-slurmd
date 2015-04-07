FROM qnib/slurm
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/supervisord.d/slurmd.ini /etc/supervisord.d/
ADD etc/consul.d/check_slurmd.json /etc/consul.d/
