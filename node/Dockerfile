FROM ubuntu:15.10

RUN apt-get update &&\
	apt-get install -y --force-yes --no-install-recommends \
		software-properties-common &&\
	add-apt-repository -y ppa:ethereum/ethereum &&\
	add-apt-repository -y ppa:ethereum/ethereum-dev &&\
	apt-get update &&\
        apt-get install -y --force-yes --no-install-recommends \
                geth vim iputils-ping telnet net-tools curl solc &&\
        apt-get autoclean &&\
        apt-get autoremove &&\
        rm -rf /var/lib/apt/lists/*

ADD ethereum/ /root/ethereum/

RUN mkdir /root/.ethereum

EXPOSE 8545 30303

CMD /usr/bin/geth --rpc --networkid 888 --port 30303 --rpcaddr "0.0.0.0" --rpcport 8545 --rpcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --datadir="/root" -verbosity 6 --ipcdisable --nodiscover --genesis /root/ethereum/private-genesis.json --etherbase "efd51a97214bf1578a8bbfbbcaf641d74fb7c307" 

