# Tutorial 1 : Transfer funds between Ether accounts

## Pre-requisites
First, make sure you have a vanilla environment in place following the procedure [here](https://github.com/besn0847/ethereum-app/blob/master/README.md). You should have 1 Ether account (*0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307*) with 100 Ethers loaded onto it if you did not mine at all yet.
But don't worry we will check this.

## Steps covered in the tutorial
We will perform the following actions in our tutorial :
* Load a JavaScript to check balances of all existing Ether accounts ;
* Create 3 new Ether accounts with a balance equal to 0 ;
* Set the first new account as the coinbase for mining ;
* Trigger Ether mining on node #0 ;
* Wait for few minutes so that Ethers have been generated and loaded to account #0
* Recheck the accounts balances ;
* Transfer exactly 2 Ether from account #0 to account #1 ;
* Recheck the accounts balances ;
* Transfer exactly 1 Ether from account #1 to account  #2 ;
* Recheck the accounts balances (you should see the transaction cost taken away from the account #1 ;
* Stop Ether mining on node #3 ;

## Step by step tutorial
**. Step 1 : Create and load a Javascript to check account balance**

		docker exec -ti ethermgmt /bin/bash
	    # cat > /tmp/gethload.js << EOF
            function checkAllBalances() {    var i =0;    eth.accounts.forEach( function(e){        console.log("  eth.accounts["+i+"]: " +  e + " \tbalance: " + web3.fromWei(eth.getBalance(e), "ether") + " ether");        i++;    })};
            EOF
        # exit
        
        docker exec -ti ethermgmt geth attach rpc:http://ethernode0:8545
            instance: Geth/v1.4.0-unstable/linux/go1.5.1
            coinbase: 0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307
            at block: 0 (Thu, 01 Jan 1970 00:00:00 UTC)
            datadir: /root
        > loadScript("/tmp/gethload.js");
            true

You should see a 'true' returned when the script has been loaded.

**. Step 2 : Create 3 new Ether accounts and check the balance**

		> personal.newAccount();
		    Passphrase: passw0rd
		    Repeat passphrase: passw0rd
            "0x09a3c5e6158f6e35ce07457b6646e67a581de904"
        > personal.newAccount();
            Passphrase: passw0rd
            Repeat passphrase: passw0rd
            "0xdbdebfa62657768070687b39a1698f4fbc4bf1c5"
        > personal.newAccount();
            Passphrase: passw0rd
            Repeat passphrase: passw0rd
            "0x62b733ed73e4713da473baecc67fc2af71adb25b"
        > checkAllBalances();
            eth.accounts[0]: 0x09a3c5e6158f6e35ce07457b6646e67a581de904   balance: 0 ether
            eth.accounts[1]: 0xdbdebfa62657768070687b39a1698f4fbc4bf1c5   balance: 0 ether
            eth.accounts[2]: 0x62b733ed73e4713da473baecc67fc2af71adb25b   balance: 0 ether
            undefined

**. Step 3 : Set the new coinbase and start mining**

        > miner.setEtherbase(eth.accounts[0]);
            true
        > miner.start(1);
            true

At  this stage the node #0 will start mining and generate some Ether for account #0. Regularly check the balances with the command below and when you have more than 2 Ether, then proceed to the next step. On my PC, it took about 5 minutes (i started 4 threads in parallel).

        > checkAllBalances();

Please note that you can also check the web URL of Ethstats (http://localhost:3000) and you can speed up mining by adding more threads (eg. miner.start(4) - this is what i use personally).

**. Step 4 : Transfer 2 Ether from #0 to #1**

        > loadScript("/tmp/gethload.js");
            eth.accounts[0]: 0x09a3c5e6158f6e35ce07457b6646e67a581de904   balance: 320 ether
            eth.accounts[1]: 0xdbdebfa62657768070687b39a1698f4fbc4bf1c5   balance: 0 ether
            eth.accounts[2]: 0x62b733ed73e4713da473baecc67fc2af71adb25b   balance: 0 ether
            undefined
        > personal.unlockAccount(eth.accounts[0],"passw0rd");
            true
        > eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei(2, "ether")});
            "0xbed2de19ed5752fbc0efeeca4794b6fe860ad22500f539a3c7fe527b2ce40e14"
        > checkAllBalances();
			eth.accounts[0]: 0x09a3c5e6158f6e35ce07457b6646e67a581de904   balance: 795.1875 ether
			eth.accounts[1]: 0xdbdebfa62657768070687b39a1698f4fbc4bf1c5   balance: 2 ether
			eth.accounts[2]: 0x62b733ed73e4713da473baecc67fc2af71adb25b   balance: 0 ether
			undefined

Please note that the transfer may take few seconds since the a block must be mined.

**. Step 5 : Transfer 2 Ether from #1 to #2**

Now we will check how much it costs to transfer 1 Ether. To do so we will transfer 1 Ether from account #1 to #2 and check account #1 balance.

        > personal.unlockAccount(eth.accounts[1],"passw0rd");
            true
        > eth.sendTransaction({from: eth.accounts[1], to: eth.accounts[2], value: web3.toWei(1, "ether")});
            "0xa4cfc4c7a9ad75bfdfd2fc5fa2df3ade411853d21652e80a0fb819485ea9228f"
        > checkAllBalances();
            eth.accounts[0]: 0x09a3c5e6158f6e35ce07457b6646e67a581de904   balance: 1119.87542 ether
            eth.accounts[1]: 0xdbdebfa62657768070687b39a1698f4fbc4bf1c5   balance: 0.99958 ether
            eth.accounts[2]: 0x62b733ed73e4713da473baecc67fc2af71adb25b   balance: 1 ether
            undefined
        > miner.stop(1);

So we see that the Ether has correctly been transferred to the 3rd account (#2) and that the cost for the transaction is 0.00042 Ether. Knowing 1 Ether is approximately 10€, this means 0.4 cts€.

## Conclusion
During the preparation of this tutorial, 239 blocks have been mined to give an idea of the magnitude order. The hashrate on my PC for one node with 4 threads is around 800 KH/s which is far far below the average good miner rate (25 MH/s) but sufficient for this exercise.

You can finish this tutorial by erasing the Ethereum app from Docker (*docker-compose kill && docker-compose rm*).

