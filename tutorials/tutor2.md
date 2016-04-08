# Tutorial 2 : Create your first HelloWorld contract

## Pre-requisites
First, make sure you have a vanilla environment in place following the procedure [here](https://github.com/besn0847/ethereum-app/blob/master/README.md). You should have 1 Ether account (*0xefd51a97214bf1578a8bbfbbcaf641d74fb7c307*) with 100 Ethers loaded onto it if you did not mine at all yet.
But don't worry we will check this.

## Steps covered in the tutorial
In this tutorial, we will create 3 accounts : the first one for mining, the second one to create the contract and the third one to use it. The goal is to show how to compile and reuse the contract between accounts. This tutorial superseeds tutorial 1 since we redo many common steps.

We will perform the following actions in our tutorial :
* Load a JavaScript to check balances of all existing Ether accounts ;
* Create 3 new Ether accounts with a balance equal to 0 ;
* Set the first new account as the coinbase for mining ;
* Trigger Ether mining on node #0 ;
* Wait for few minutes so that Ethers have been generated and loaded to account #0
* Transfer exactly 10 Ether from account #0 to account #1 ;
* Transfer exactly 10 Ether from account #0 to account #2 ;
* Account #1 will create a HelloWorld contract ;
* Account #2 will invoke the HelloWorld contract ;
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
            "0x4f26d789e2dd6a6f860963c96125130340036012"
        > personal.newAccount();
            Passphrase: passw0rd
            Repeat passphrase: passw0rd
            "0x60d772b878a415846d356b8e8a726188d52a1d6a"
        > personal.newAccount();
            Passphrase: passw0rd
            Repeat passphrase: passw0rd
            "0x73b6146ee99b066bf788b5b41054aa8b720af6c8"
        > checkAllBalances();
            eth.accounts[0]: 0x4f26d789e2dd6a6f860963c96125130340036012   balance: 0 ether
            eth.accounts[1]: 0x60d772b878a415846d356b8e8a726188d52a1d6a   balance: 0 ether
            eth.accounts[2]: 0x73b6146ee99b066bf788b5b41054aa8b720af6c8   balance: 0 ether
            undefined

**. Step 3 : Set the new coinbase and start mining**

        > miner.setEtherbase(eth.accounts[0]);
            true
        > miner.start(1);
            true

At  this stage the node #0 will start mining and generate some Ether for account #0. Regularly check the balances with the command below and when you have more than 2 Ether, then proceed to the next step. On my PC, it took about 5 minutes (i started 4 threads in parallel).

        > checkAllBalances();

Please note that you can also check the web URL of Ethstats (http://localhost:3000) and you can speed up mining by adding more threads (eg. miner.start(4) - this is what i use personally).

**. Step 4 : Transfer 10 Ether from #0 to #1 and another 10 from #0 to #2** 

        > loadScript("/tmp/gethload.js");
            eth.accounts[0]: 0x4f26d789e2dd6a6f860963c96125130340036012     balance: 830.78125 ether
            eth.accounts[1]: 0x60d772b878a415846d356b8e8a726188d52a1d6a     balance: 0 ether
            eth.accounts[2]: 0x73b6146ee99b066bf788b5b41054aa8b720af6c8     balance: 0 ether
            undefined
        > personal.unlockAccount(eth.accounts[0],"passw0rd");
            true
        > eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei(10, "ether")});
            "0xd20c426f6b6131cf8fe9a7395c58465e220efc5330600a1715e49d041276647c"
        > eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[2], value: web3.toWei(10, "ether")});
            "0xc1fc6ad9b6adb137c682c7f4cda377dc669e5e1e6d8ca12324cf720a83a8eb41"
        > checkAllBalances();
            eth.accounts[0]: 0x4f26d789e2dd6a6f860963c96125130340036012     balance: 985.78125 ether
            eth.accounts[1]: 0x60d772b878a415846d356b8e8a726188d52a1d6a     balance: 10 ether
            eth.accounts[2]: 0x73b6146ee99b066bf788b5b41054aa8b720af6c8     balance: 10 ether
            undefined

Please note that the transfer may take few seconds since the a block must be mined.

**. Step 5 : Account #1 will create the HelloWorld contract**
Unlock the account #1 and define the HelloWorld contract.

        > personal.unlockAccount(eth.accounts[1],"passw0rd");
            true
        > greeterSource = 'contract mortal { address owner; function mortal() { owner = msg.sender;} function kill() { if (msg.sender == owner) suicide(owner);}} contract greeter is mortal {string greeting; function greeter(string _greeting) public { greeting = _greeting;} function greet() constant returns (string) { return greeting;}}';
            "contract mortal { address owner; function mortal() { owner = msg.sender;} function kill() { if (msg.sender == owner) suicide(owner);}} contract greeter is mortal {string greeting; function greeter(string _greeting) public { greeting = _greeting;} function greet() constant returns (string) { return greeting;}}"

Now compile the contract :

        > greeterCompiled = web3.eth.compile.solidity(greeterSource);
            {
              greeter: {
                code: "0x606060405260405161023e38038061023e8339810160405280510160008054600160a060020a031916331790558060016000509080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10609f57805160ff19168380011785555b50608e9291505b8082111560cc57600081558301607d565b50505061016e806100d06000396000f35b828001600101855582156076579182015b82811115607657825182600050559160200191906001019060b0565b509056606060405260e060020a600035046341c0e1b58114610026578063cfae321714610068575b005b6100246000543373ffffffffffffffffffffffffffffffffffffffff908116911614156101375760005473ffffffffffffffffffffffffffffffffffffffff16ff5b6100c9600060609081526001805460a06020601f6002600019610100868816150201909416939093049283018190040281016040526080828152929190828280156101645780601f1061013957610100808354040283529160200191610164565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600f02600301f150905090810190601f1680156101295780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b565b820191906000526020600020905b81548152906001019060200180831161014757829003601f168201915b505050505090509056",
                info: {
                  abiDefinition: [{...}, {...}, {...}],
                  compilerOptions: "--bin --abi --userdoc --devdoc --add-std --optimize -o /tmp/solc454447886",
                  compilerVersion: "0.3.0",
                  developerDoc: {
                    methods: {}
                  },
                  language: "Solidity",
                  languageVersion: "0.3.0",
                  source: "contract mortal { address owner; function mortal() { owner = msg.sender;} function kill() { if (msg.sender == owner) suicide(owner);}} contract greeter is mortal {string greeting; function greeter(string _greeting) public { greeting = _greeting;} function greet() constant returns (string) { return greeting;}}",
                  userDoc: {
                    methods: {}
                  }
                }
              },
              mortal: {
                code: "0x606060405260008054600160a060020a03191633179055605c8060226000396000f3606060405260e060020a600035046341c0e1b58114601a575b005b60186000543373ffffffffffffffffffffffffffffffffffffffff90811691161415605a5760005473ffffffffffffffffffffffffffffffffffffffff16ff5b56",
                info: {
                  abiDefinition: [{...}, {...}],
                  compilerOptions: "--bin --abi --userdoc --devdoc --add-std --optimize -o /tmp/solc454447886",
                  compilerVersion: "0.3.0",
                  developerDoc: {
                    methods: {}
                  },
                  language: "Solidity",
                  languageVersion: "0.3.0",
                  source: "contract mortal { address owner; function mortal() { owner = msg.sender;} function kill() { if (msg.sender == owner) suicide(owner);}} contract greeter is mortal {string greeting; function greeter(string _greeting) public { greeting = _greeting;} function greet() constant returns (string) { return greeting;}}",
                  userDoc: {
                    methods: {}
                  }
                }
              }
            }

You can recheck the accounts #1 & #2 balances : there are still 10 Ethers on each; so compiling the contract didn't cost anything to account #1.
Now let's be prepared to invoke the contract by account #2.

        > personal.unlockAccount(eth.accounts[2],"passw0rd");
            true
        > _greeting = "Hello World!";
            "Hello World!"
        > greeterContract = web3.eth.contract(greeterCompiled.greeter.info.abiDefinition);
            {
              abi: [{
                  constant: false,
                  inputs: [],
                  name: "kill",
                  outputs: [],
                  type: "function"
              }, {
                  constant: true,
                  inputs: [],
                  name: "greet",
                  outputs: [{...}],
                  type: "function"
              }, {
                  inputs: [{...}],
                  type: "constructor"
              }],
              eth: {
                _requestManager: {
                  polls: {},
                  provider: {
                    newAccount: function(),
                    send: function(),
                    sendAsync: function(),
                    unlockAccount: function()
                  },
                  timeout: null,
                  poll: function(),
                  reset: function(keepIsSyncing),
                  send: function(data),
                  sendAsync: function(data, callback),
                  sendBatch: function(data, callback),
                  setProvider: function(p),
                  startPolling: function(data, pollId, callback, uninstall),
                  stopPolling: function(pollId)
                },
                accounts: ["0x4f26d789e2dd6a6f860963c96125130340036012", "0x60d772b878a415846d356b8e8a726188d52a1d6a", "0x73b6146ee99b066bf788b5b41054aa8b720af6c8"],
                blockNumber: 279,
                coinbase: "0x4f26d789e2dd6a6f860963c96125130340036012",
                compile: {
                  lll: function(),
                  serpent: function(),
                  solidity: function()
                },
                defaultAccount: undefined,
                defaultBlock: "latest",
                gasPrice: 20000000000,
                hashrate: 100746,
                mining: true,
                pendingTransactions: [],
                syncing: false,
                call: function(),
                contract: function(abi),
                estimateGas: function(),
                filter: function(fil, callback),
                getAccounts: function(callback),
                getBalance: function(),
                getBlock: function(),
                getBlockNumber: function(callback),
                getBlockTransactionCount: function(),
                getBlockUncleCount: function(),
                getCode: function(),
                getCoinbase: function(callback),
                getCompilers: function(),
                getGasPrice: function(callback),
                getHashrate: function(callback),
                getMining: function(callback),
                getNatSpec: function(),
                getPendingTransactions: function(callback),
                getStorageAt: function(),
                getSyncing: function(callback),
                getTransaction: function(),
                getTransactionCount: function(),
                getTransactionFromBlock: function(),
                getTransactionReceipt: function(),
                getUncle: function(),
                getWork: function(),
                iban: function(iban),
                icapNamereg: function(),
                isSyncing: function(callback),
                namereg: function(),
                resend: function(),
                sendIBANTransaction: function(),
                sendRawTransaction: function(),
                sendTransaction: function(),
                sign: function(),
                signTransaction: function(),
                submitTransaction: function(),
                submitWork: function()
              },
              at: function(address, callback),
              getData: function(),
              new: function()
            }

Now we can invoke the contract (make sure your are still mining) :

        > greeter = greeterContract.new(_greeting,{from:eth.accounts[2], data: greeterCompiled.greeter.code, gas: 300000}, function(e, contract){ if(!e) { if(!contract.address) { console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");} else { console.log("Contract mined! Address: " + contract.address); console.log(contract);}}});
            Contract transaction send: TransactionHash: 0x6ba9804c5924027bebb3b2aec0783dc441f6e8233a28ccee0fac28462822e981 waiting to be mined...
            {
              _eth: {
                _requestManager: {
                  polls: {
                    0xe62ab82ceda9a5ca8249ed9a480ec741: {...}
                  },
                  provider: {
                    newAccount: function(),
                    send: function(),
                    sendAsync: function(),
                    unlockAccount: function()
                  },
                  timeout: {},
                  poll: function(),
                  reset: function(keepIsSyncing),
                  send: function(data),
                  sendAsync: function(data, callback),
                  sendBatch: function(data, callback),
                  setProvider: function(p),
                  startPolling: function(data, pollId, callback, uninstall),
                  stopPolling: function(pollId)
                },
                accounts: ["0x4f26d789e2dd6a6f860963c96125130340036012", "0x60d772b878a415846d356b8e8a726188d52a1d6a", "0x73b6146ee99b066bf788b5b41054aa8b720af6c8"],
                blockNumber: 304,
                coinbase: "0x4f26d789e2dd6a6f860963c96125130340036012",
                compile: {
                  lll: function(),
                  serpent: function(),
                  solidity: function()
                },
                defaultAccount: undefined,
                defaultBlock: "latest",
                gasPrice: 20000000000,
                hashrate: 107128,
                mining: true,
                pendingTransactions: [{
                    blockHash: "0x0000000000000000000000000000000000000000000000000000000000000000",
                    blockNumber: null,
                    from: "0x73b6146ee99b066bf788b5b41054aa8b720af6c8",
                    gas: "0x493e0",
                    gasPrice: "0x4a817c800",
                    hash: "0x6ba9804c5924027bebb3b2aec0783dc441f6e8233a28ccee0fac28462822e981",
                    input: "0x606060405260405161023e38038061023e8339810160405280510160008054600160a060020a031916331790558060016000509080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10609f57805160ff19168380011785555b50608e9291505b8082111560cc57600081558301607d565b50505061016e806100d06000396000f35b828001600101855582156076579182015b82811115607657825182600050559160200191906001019060b0565b509056606060405260e060020a600035046341c0e1b58114610026578063cfae321714610068575b005b6100246000543373ffffffffffffffffffffffffffffffffffffffff908116911614156101375760005473ffffffffffffffffffffffffffffffffffffffff16ff5b6100c9600060609081526001805460a06020601f6002600019610100868816150201909416939093049283018190040281016040526080828152929190828280156101645780601f1061013957610100808354040283529160200191610164565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600f02600301f150905090810190601f1680156101295780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b565b820191906000526020600020905b81548152906001019060200180831161014757829003601f168201915b5050505050905090560000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000c48656c6c6f20576f726c64210000000000000000000000000000000000000000",
                    nonce: "0x0",
                    to: null,
                    transactionIndex: null,
                    value: "0x0"
                }],
                syncing: false,
                call: function(),
                contract: function(abi),
                estimateGas: function(),
                filter: function(fil, callback),
                getAccounts: function(callback),
                getBalance: function(),
                getBlock: function(),
                getBlockNumber: function(callback),
                getBlockTransactionCount: function(),
                getBlockUncleCount: function(),
                getCode: function(),
                getCoinbase: function(callback),
                getCompilers: function(),
                getGasPrice: function(callback),
                getHashrate: function(callback),
                getMining: function(callback),
                getNatSpec: function(),
                getPendingTransactions: function(callback),
                getStorageAt: function(),
                getSyncing: function(callback),
                getTransaction: function(),
                getTransactionCount: function(),
                getTransactionFromBlock: function(),
                getTransactionReceipt: function(),
                getUncle: function(),
                getWork: function(),
                iban: function(iban),
                icapNamereg: function(),
                isSyncing: function(callback),
                namereg: function(),
                resend: function(),
                sendIBANTransaction: function(),
                sendRawTransaction: function(),
                sendTransaction: function(),
                sign: function(),
                signTransaction: function(),
                submitTransaction: function(),
                submitWork: function()
              },
              abi: [{
                  constant: false,
                  inputs: [],
                  name: "kill",
                  outputs: [],
                  type: "function"
              }, {
                  constant: true,
                  inputs: [],
                  name: "greet",
                  outputs: [{...}],
                  type: "function"
              }, {
                  inputs: [{...}],
                  type: "constructor"
              }],
              address: undefined,
              transactionHash: "0x6ba9804c5924027bebb3b2aec0783dc441f6e8233a28ccee0fac28462822e981"
            }

To finish, wait for the contract to be mined and rechck the balances

        >
            Contract mined! Address: 0x23a75fbb505099a33df24cc20e4a19207fcff751
            [object Object]
        > checkAllBalances();
            eth.accounts[0]: 0x4f26d789e2dd6a6f860963c96125130340036012     balance: 1535.78471852 ether
            eth.accounts[1]: 0x60d772b878a415846d356b8e8a726188d52a1d6a     balance: 10 ether
            eth.accounts[2]: 0x73b6146ee99b066bf788b5b41054aa8b720af6c8     balance: 9.99653148 ether
            undefined

So we see that the cos the transaction mining (about 0.0035 Ether or 3 cts€).

## Conclusion
This tutorial has shown how to compile a simple contract through the Geth console. It has also shown that there is no cost to create the contract and publish it but there is a cost (10 times higher than simply transferring Ether) to invoke and run the contract.

You can finish this tutorial by erasing the Ethereum app from Docker (docker-compose kill && docker-compose rm).

