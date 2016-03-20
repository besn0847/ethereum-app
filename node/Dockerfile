FROM ubuntu:15.10

RUN apt-get update &&\
	apt-get install -y --force-yes --no-install-recommends \
		software-properties-common &&\
	add-apt-repository -y ppa:ethereum/ethereum &&\
	add-apt-repository -y ppa:ethereum/ethereum-dev &&\
	apt-get update &&\
        apt-get install -y --force-yes --no-install-recommends \
                geth vim iputils-ping telnet net-tools &&\
        apt-get autoclean &&\
        apt-get autoremove &&\
        rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.ethereum

EXPOSE 8545 30303

CMD /usr/bin/geth --rpc 
