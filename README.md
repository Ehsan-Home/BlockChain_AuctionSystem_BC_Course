# BlockChain_AuctionSystem 🛎
## General
This is a repository containing Block-chain src code for auction system ⚡️

With Block-chain system, auctions can be easily hold with no threats of bids compromising or changing. 

The main characteristic that Block-Chain brings up is that it uses Hash functions in two stages:
1. The guessing state
In this stage, the bidder calculates the hash of the bid concatenated with a random number called nonce and submits **this hash**.

    <div align="center">Hash(bid , nonce)</div>
2. The reveal state
In this stage, the bidder exposes bid and nonce. After revealing them, all participants will calculate the hash of the provided values (bid and nonce) and compares it with previous submitted hash. Two cases might occur: 
* They match
Meaning that the bidder has submitted the correct bid and is acting honestly.
* They don't match
Meaning that the bidder has submitted the wrong bid and is acting unhonestly.


As you might guess, there is no way for the bidder to change the intial bid since if the bidder changes the bid, the hash will not stay the same and all participant will notice it.

## Running the Code
1.You simply download the **BC Src.sol** file and copy its content to the [Remix Ethereum](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.6.6+commit.6c089d02.js&appVersion=0.7.7)

2.Go to the Run section in [Remix Ethereum](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.6.6+commit.6c089d02.js&appVersion=0.7.7) and Deploy the project.

**‼️ Important Note:** the compiler version for this project is : **0.4.24+commit.e67f0147**

Also, check out my youtube video explaining breifly how to run this project 😊 📺 : [Youtube](https://youtu.be/q-t4NOFGC7k)


My Awsome teammates are:
* Sara Sanati 🧑🏼‍💻
* [Sarvenaz Ghafourian 🧑🏼‍💻](https://github.com/Sarvenaz1376)