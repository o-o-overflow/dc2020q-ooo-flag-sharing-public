from python:3.8

run apt-get -qq update && apt-get install -qq --no-install-recommends xinetd rsyslog
run pip install gensafeprime fuckpy3 forbiddenfruit numpy

# Note: anything that goes in public_files must be pre-built and checked in git
copy chal.py /
copy matrix.ooo /
copy prime.ooo /
copy flag /

RUN mkdir /shares
RUN useradd flagsharer
RUN chown flagsharer.flagsharer /shares

# the deployment tester will pass in the flag from the yaml
ARG THE_FLAG="OOO{test flag}"
RUN touch /flag && chmod 644 /flag && echo -n $THE_FLAG > /flag

copy service.conf /service.conf
copy banner_fail /banner_fail
copy wrapper /wrapper

expose 5000
#cmd ["/usr/sbin/xinetd", "-d", "-dontfork", "-f", "/service.conf"]
cmd ["/usr/sbin/xinetd", "-syslog", "local0", "-dontfork", "-f", "/service.conf"]
# ^^ If ps would be too revealing, replace with the line below.
#    AFAIK, this also disables the built-in printf(%n) protection, so YMMV.
#cmd chmod go-rwx /proc && /usr/sbin/xinetd -syslog local0 -dontfork -f /service.conf
