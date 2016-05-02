# Tutorial 3 : Creating you first advanced Smart Contract

## Context
This third tutorial goes slightly deeper into Ethereum Smart Contracts. It is based on [this tutorial](https://github.com/eshon/conference) created by [Eva Shon](http://beluga8.com/), initially built for Truffle. I took the same content to create this tutorial and the next one (focusing on Mix IDE to build a DApp).

The purpose of this tutorial is to show how to create a Smart Contract developped and compiled through the Solidity browser which is embedded in the containers set-up. Then we will push transactions to the blockchain.

The Smart Contract used here is called Conference (see [this github repo](https://github.com/eshon/conference/tree/master/contracts)) and allows an organizer to set-up a conference point of sales. The subscribers can then buy tickets while the organizer can also change the overall allowed quota or refund existing users.

## Pre-requisites
Please make sure you have been through the first 2 tutorials since we will re-use what was done, especially to create users and transfer ethers. 

The steps described below assume you have done steps 1 to 4 from [this tutorial](https://github.com/besn0847/ethereum-app/blob/master/tutorials/tutor2.md). So you should have at the beginning :
* 3 users with user #0 having many ether and users #1 & #2 with 10 ethers each
* Ethernode #1 should be mining, so adding other ethers to user #0 account

Check the balance with the checkAllBalances() function loaded from the Javascript. Don't stop mining blocks since this is required for the rest of this tutorial.

Also there might be an issue with the Solidity Browser authorization. So make sure you are on the same host as your Docker host or build a tunnel through SSH. It is important you address the browser through this url : http://localhost:3001. Otherwise, the contract will not be deployed to the blockchain.

## Steps covered in this tutorial
The following steps will be performed in this tutorial :
   * Get hands-on with the Solidity Browser
   * Write (or copy) your Conference smart contract
   * Deploy the Smart Contract to the blockchain	
   * Buy tickets for 3 users
   * Change the quota, refund users by the organizer
   * Terminate the smart contract on the blockchain

All of the above will require access to the Geth command line to unlock accounts (just few times) and the rest will be done through a simple web browser pointing to the Solidity Browser at http://localhost:3001.

## Step-by-step tutorial
### **. Step 0: Make sure everything is up & running**
If you followed the first 4 steps of [this tutorial](https://github.com/besn0847/ethereum-app/blob/master/tutorials/tutor2.md), your accounts balance should look like this :

![Screencap 001](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-001.png)

Again to get access to the Geth command line, just type the following command from your terminal :

    docker exec -ti ethermgmt geth attach rpc:http://ethernode0:8545

Then test the connectivity to the Solidity Browser which is deployed on the ethermgmt node and accessible at http://localhost:3001. Again, i only authorized this URL so you need to either be on the Docker host or open an SSH connection tunneling to your localhost client ports : 3000 (etherstats), 3001 (browser) and 8545 (Geth node 0).

So open your browser and point it to http://localhost:3001. Then close any subwindow which is open (usually there is one for the Ballot contract).

![Screencap 002](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-002.png)

### **. Step 1: Create a new smart contract named Conference**
First,create a new contract which will be compiled locally. See the screenshot below to add a new contarct.

![Screencap 003](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-003.png)

Then paste the code below (or grab it from [Conference.sol](https://github.com/eshon/conference/blob/master/contracts/Conference.sol) on Github) in the new window and rename the contract as conference (click OK if required). You should then see in the left panel the compiled version of Conference which can be deployed on the blockchain.

![Screencap 004](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-004.png)

Note that you can directly deploy the contract on the blockchain by using the Javascript from the "Web3 deploy" tab. This would be done as we did it in the [2nd tutorial](https://github.com/besn0847/ethereum-app/blob/master/tutorials/tutor2.md). However this time, we will directly deploy it from the Solidity Browser.

### **. Step 2: Deploy the Conference smart contract to the blockchain**
Now switch to the provider view : we will connect to the blockchain deployed locally in the Docker containers. Then select the "Web3 Provider Endpoint" and don't change the URL (http://localhost:8545).

![Screencap 005](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-005.png)

To deploy the contract, you will need to use some Ether; so let's use the user account #0 which is used as etherbase and gets new ether everyt time a block is mined. It must be unlocked to spend some of the ether : do this through the Geth command line.

![Screencap 006](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-006.png)

Now it is time to switch to the transaction view. Then make sure at the top, you select the user #0 address and just deploy the contract to the blockchain.

![Screencap 007](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-007.png)

After maximum 15 seconds, the transaction is mined in the next block and the contract is instantiated as shown in the picture below. The contract address can be used in the future to re-use directly this contract instance. The Solidity Browser collects the default variables values which are shown closed to the blue buttons :
   * the quota is set to 100 so 0x64 in Hex
   * the contract is associated with one single organizer
   * there is no registrant so far    

![Screencap 008](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-008.png)

Congrats ! You deployed your first contract with the Soldity Browser. Simple, isn't it ?
   
### **. Step 3 : Buy 3 tickets for the conference**
It is now time to play a bit with your new Conference contract. Since we unlocked the user #0, let's start with him and buy a ticket for 5 ether. To do so, select the user #0 address and set the value to 5 (which is in ether by default).

Then click the buyTicket() button. The transaction is mined within the next 15 seconds and an event is generated by the blockchain to notify that user #0 purchased a ticket for 5.10^18 wei = 5 ether. You can check the accounts balance from the CLI but because user #0 address is the ether base, you won't see much : just the cost of committing the transaction to the blockchain.

![Screencap 009](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-009.png)

Let's do the same for user #1 who buys a ticket for 4 ether. But first start by unlocking this account and then commit your transaction to the blockchain.

![Screencap 010](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-010.png)
![Screencap 011](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-011.png)

Finally do the same for user #2 (unlocking then buying)

![Screencap 012](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-012.png)
![Screencap 013](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-013.png)

If you check the current number of registrants, you will see 3 as expected.

### **. Step 4 : The organizer polls the blockchain**
The conference organizer as some special rights. Let's dive a bit on this part but first unlock the user #0 account.

![Screencap 014](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-014.png)

Now the organizer will first check the current quota (which is 100) and set it to 50.
First just click on the quota button which invoke the blockchain to return the current value.

![Screencap 015](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-015.png)

Then set the changeQoota value to 50 and commit the transaction. The block is mined within 15s again.

![Screencap 016](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-016.png)

Let's recheck the current quota value : 0x32 so 50 as expected.

![Screencap 017](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-017.png)

Finally the user #0 will check the amount he paid to buy the ticket. This is done by entering its own address as the input for the registrantsPaid() function. The result return is in hex and is equal to 5.10^18 wei or 5 ether.

![Screencap 018](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-018.png)

### **. Step 5 : The organizer will refund the tickets to users #1 & #2**
Only the organizer can perform this action but before doing so he checks how many registrants there are by invoking the numRegistrants button.

![Screencap 019](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-019.png)

Now it is time to refund both users. Make sure the proper user address is entered as well as the exact amount of wei used by the users to buy tickets. In this tutorial, i probably missed a 0 out of 18 and one of the 2 users has not been refunded.

![Screencap 020](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-020.png)
![Screencap 021](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-021.png)

On that latter screenschot, note the refund event generated by the blockchain. Also note that there is only one registrant left (user #0). Finally, check the user account balances to see the refund is ok minus the costs to mine the transactions (one is wrong here).

![Screencap 022](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-022.png)

### **. Step 6 : The organizer terminates the conference**
Now, it is time to close the conference registration. Thanks to the 'suicide' entry in the contract, the organizer can remove it from the blockchain. So the organizer selects the destroy() function and waits until the transaction has been mined.

![Screencap 023](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-023.png)

As shown below, the contract does not exist anymore on the blockchain and it is impossible to poll any attribute.

![Screencap 024](https://github.com/besn0847/ethereum-app/raw/master/tutorials/tutor3/tutor3-024.png)

## Conclusion
The goal of this tutorial was to show how to use the Solidity Browser to develop, build, deploy and test Smart Contracts. The next tutorial will focus on the Mix IDE to build a DApp but the same Smart Contract will be used underneath.

The Solidity Browser gives the ability to develop contracts locally or on  a live blockchain. Coupling it with a containerized deployment, you can look under the hood and see what exactly happens regarding gas consumption, mining...

Finally, to use quickly and easily the Solidity Browser, just clone its Github repository and point your browser to the index.html file. You can then start developping without any conenctivity to any blockchain.

## References
* [Tutorial #1: Transfer funds between Ether accounts](https://github.com/besn0847/ethereum-app/blob/master/tutorials/tutor1.md)
* [Tutorial #2: Create your first HelloWorld contract](https://github.com/besn0847/ethereum-app/blob/master/tutorials/tutor2.md)
* [The Solidity Browser github](https://chriseth.github.io/browser-solidity/)
* [The Conference smart contract](https://medium.com/@ConsenSys/a-101-noob-intro-to-programming-smart-contracts-on-ethereum-695d15c1dab4#.7iw930hp1) 
* [The Solidity reference docs](https://www.google.fr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=4&cad=rja&uact=8&ved=0ahUKEwjvnd-SvbvMAhWHDxoKHZYUDqwQFgg2MAM&url=https%3A%2F%2Fethereum.github.io%2Fsolidity%2F&usg=AFQjCNE7gN4OoMVrr-B8BALbD2bNKYn7fg&sig2=f2L_tXkMzI-UhbDwmJK6WA)
