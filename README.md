# Ethereum Application
## Context
From my very own point of view, Ethereum is so far the best implementation of blockchains. Even if based on the same approach as Bitcoin, it is not a fork and has been rewritten from scratch. It embeds the Ether gas concept to "bill" the cost of a transaction as well as the "Smart Contracts" concept to store any kind of transaction.

Ethereum is very well documented but when i started looking more deeply into it about a month, i felt frustrated not having a quick way to build a private blockchain environment on Docker to experiment and test on Ethereum. There is of course a TestNet available, there are also some guides on how to build a local set-up but nothing quick and replicable.

Hence this Docker app aims to set-up a local Ethereum cluster environment with the EtherStats UI to track miners and block status. This set-up is completely isolated from Internet and does not even require connectivity except for the build part of course.

## Architecture & Configuration
This application will create a private Ethereum cluster of 4 nodes. It also includes a management node which is used to bootstrap the blockchain and to consolidate node statistics through the well known EtherStats UI.

There is also a default account ('*0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307*') with 100 ether as a starting point. Mining is not enabled by default but can be started through the Geth command line as you will see later on.

The following set-up is used here :
> Docker Engine 1.10.3 

> Docker Composer 1.6.2

Make sure you use at least those versions since the composer must be able to read version 2 files and the engine must be able to set-up software defined networks.

## Set-up
The set-up is very straight forward using Docker. You need to clone the Github repository, build the application and kick it off, the latter being done under the same command.

. Step 1 : Clone the Git repository
```
git clone https://github.com/besn0847/ethereum-app.git
```

. Step 2 : Kick off the build & start-up of teh Ethereum application
```
cd ethereum-app
docker-compose up -d
```
It may take a while to build and start : on my PC, it takes around 3 minutes to build everything. When you are done, just check everything is started correctly.

. Step 3 : Check the Ethereum application has been started
```
docker-compose ps
```
You should get something like :
```
   Name                 Command               State           Ports          
----------------------------------------------------------------------------
ethermgmt    sh -c sleep 10 && /bootstr ...   Up      0.0.0.0:3000->3000/tcp 
ethernode0   /bin/sh -c /usr/bin/geth - ...   Up      30303/tcp, 8545/tcp    
ethernode1   /bin/sh -c /usr/bin/geth - ...   Up      30303/tcp, 8545/tcp    
ethernode2   /bin/sh -c /usr/bin/geth - ...   Up      30303/tcp, 8545/tcp    
ethernode3   /bin/sh -c /usr/bin/geth - ...   Up      30303/tcp, 8545/tcp    
```

. Step 4 : Connect to the UI to see the Ethereum dashboard

Point your browser to the URL below and you will see your local private dashboard equivalent to [this one](https://ethstats.net/).
> http://<your_docker_host>:3000

## Simple use cases
Here are 3 basic use cases (more to come in the future)

. **Use case 1 : Check your account balance**

We assume here you want to check your account balance. Then simply connect to the Ethereum geth CLI and request your account balance.
```
docker exec -t -i ethermgmt /usr/bin/geth attach rpc:http://ethernode0:8545
    instance: Geth/v1.4.0-unstable/linux/go1.5.1
    coinbase: 0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307
    at block: 0 (Thu, 01 Jan 1970 00:00:00 UTC)
    datadir: /root
> web3.fromWei(eth.getBalance("0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307"), "ether");
    100
> exit
```
We see that this account has 100 associated Ethers. Since the mining has not started, there is currently no reward so the balance will remain stable : this will change when mining).  

. **Use case 2 : Create a new account**

We now create a second account in the Blokchain. The balance will be 0 at this stage.
```
docker exec -t -i ethermgmt /usr/bin/geth attach rpc:http://ethernode0:8545
    instance: Geth/v1.4.0-unstable/linux/go1.5.1
    coinbase: 0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307
    at block: 0 (Thu, 01 Jan 1970 00:00:00 UTC)
    datadir: /root
> personal.newAccount();
    Passphrase: passw0rd
    Repeat passphrase: passw0rd
    "0xf4a6605e6385e483e921f83b362fc792c3cd95aa"
> primary = eth.accounts[0];
    "0xf4a6605e6385e483e921f83b362fc792c3cd95aa"
> balance = web3.fromWei(eth.getBalance(primary), "ether");
    0
> exit
```
The account balance will change if Ethers are transferred or when mining starts.

. **Use case 3 : Start mining & check accounts balances**

Now we will start mining on one node (we could do the 4 but depends on your PC power).
```
docker exec -t -i ethermgmt /usr/bin/geth attach rpc:http://ethernode0:8545
    instance: Geth/v1.4.0-unstable/linux/go1.5.1
    coinbase: 0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307
    at block: 0 (Thu, 01 Jan 1970 00:00:00 UTC)
    datadir: /root
> miner.start(1);
    true
> exit
```

Connect to the EtherStats dashboard above : you should see some blocks mined. Then check the accounts balances.
```
docker exec -t -i ethermgmt /usr/bin/geth attach rpc:http://ethernode0:8545
    instance: Geth/v1.4.0-unstable/linux/go1.5.1
    coinbase: 0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307
    at block: 44 (Wed, 23 Mar 2016 18:19:36 UTC)
    datadir: /root
> web3.fromWei(eth.getBalance("0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307"), "ether");
    330
> exit
```
Now just stop the mining and the balance will not change anymore.
```
docker exec -t -i ethermgmt /usr/bin/geth attach rpc:http://ethernode0:8545
    instance: Geth/v1.4.0-unstable/linux/go1.5.1
    coinbase: 0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307
    at block: 44 (Wed, 23 Mar 2016 18:19:36 UTC)
    datadir: /root
> miner.stop(1);
    true
> exit
```

## References
- [Ethereum](https://ethereum.org/)
- [Private Ethereum setup](https://github.com/vallard/ethereum-infrastructure)
- [How To Create A Private Ethereum Chain](http://adeduke.com/2015/08/how-to-create-a-private-ethereum-chain/)
- [Setup a Local Test Blockchain](http://tech.lab.carl.pro/kb/ethereum/testnet_setup)

