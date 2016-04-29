FROM ubuntu:15.10

RUN apt-get update &&\
	apt-get install -y --force-yes --no-install-recommends \
		software-properties-common &&\
	add-apt-repository -y ppa:ethereum/ethereum &&\
	add-apt-repository -y ppa:ethereum/ethereum-dev &&\
	apt-get update &&\
        apt-get install -y --force-yes --no-install-recommends \
                geth vim iputils-ping telnet net-tools curl npm git nodejs solc nginx &&\
        apt-get autoclean &&\
        apt-get autoremove &&\
        rm -rf /var/lib/apt/lists/*

ENV WS_SECRET passw0rd

ADD bootstrap.sh /
ADD eth-net-intelligence-api /root/eth-net-intelligence-api/
ADD eth-netstats /root/eth-netstats/
ADD browser-solidity /var/www/browser-solidity/
ADD solidity-browser /etc/nginx/sites-enabled/

RUN mkdir /root/.ethereum &&\
	ln -s /usr/bin/nodejs /usr/bin/node &&\
	chmod +x /bootstrap.sh &&\
	cd /root/eth-netstats &&\
	npm install &&\
	npm install -g grunt-cli &&\
	grunt all &&\
	cd /root/eth-net-intelligence-api &&\
        npm install &&\
	npm install -g pm2

EXPOSE 3000 3001 

CMD sh -c 'nginx && cd /root/eth-net-intelligence-api/ && pm2 start app.json && cd /root/eth-netstats && npm start'
