{\rtf1\ansi\ansicpg1252\cocoartf2513
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\pardirnatural\partightenfactor0

\f0\fs24 \cf0 //0xca35b7d915458ef540ade6068dfe2f44e8fa733c : Auctioner\
// Cryptographic : https://solidity.readthedocs.io/en/v0.4.24/units-and-global-variables.html#mathematical-and-cryptographic-functions\
// Address related : https://solidity.readthedocs.io/en/v0.4.24/units-and-global-variables.html#mathematical-and-cryptographic-functions\
\
\
\
\
pragma solidity ^ 0.4.24<0.7.1;\
\
\
contract Auction\{\
    \
\
    uint reservePrice;\
    uint biddingPeriod;\
    uint revealPeriod;\
    uint initialFund;\
    \
    //initial funds, not being returned to dishonest nodes;\
    uint bid;\
    bool state;\
    uint auctionState;\
    uint secs;\
    // 0 : bid , 1 : reveal , 2 : claim\
    \
    // address changed to valid checksum by this link:\
    // https://etherscan.io/address/0xca35b7d915458ef540ade6068dfe2f44e8fa733c\
    address auctioneer = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;\
    \
    \
    mapping (address => bytes32) bidsHashed;\
    mapping (address => uint) bids;\
    mapping (address => string) nonces;\
    \
    \
    address[] addresses;\
    uint numberOfAddresses;\
    \
    \
    uint winnerBid;\
    address winnerAddress;\
    uint residual;\
    \
    modifier checkAddressOfAuctioneer(address adr)\{\
        require(adr==auctioneer, "Address of auctioneer is not verified");_;\
    \}\
    \
    modifier checkAddressOfBidder(address adr)\{\
        require(adr != auctioneer , "auctioneer cannot participate in bidding!");_;\
    \}\
    \
    constructor() public payable checkAddressOfAuctioneer(msg.sender) \{\
        require(msg.value > 0 , "Enter initial fund in Value input");\
        reservePrice = 5;\
        numberOfAddresses = 0;\
        initialFund = msg.value;\
        auctionState = 0;\
        \
        \
        // 60 = 1 min\
        // 600 = 10 mins\
        biddingPeriod = block.timestamp + 60;\
        \
        // 900 = 15 mins\
        revealPeriod = block.timestamp + 120;\
        \
        \
        winnerBid = 0;\
    \}\
    \
    function bidFunc(uint amount, string nonce) public checkAddressOfBidder(msg.sender) payable\{\
        require(block.timestamp < biddingPeriod , "Time for bidding is OVER!");\
        require(amount > reservePrice , "Bid amount is too low!");\
        \
        \
        bid = amount;\
        \
        addresses.push(msg.sender);\
        numberOfAddresses += 1;\
        \
        \
        // nonce used same as flip coin example\
        bidsHashed[msg.sender] = keccak256(bid , nonce);\
    \}\
    \
    function revealFunc(uint amount , string nonce) public checkAddressOfBidder(msg.sender) payable\{\
        require(block.timestamp > biddingPeriod , "Revealing not started yet!");\
        require(block.timestamp < revealPeriod , "Time for revealing is OVER!");\
        \
        auctionState = 1;\
        \
        bid = amount;\
        bids[msg.sender] = bid;\
        nonces[msg.sender] = nonce;\
        verifyBidsFunc();\
    \}\
    \
    function verifyBidsFunc() view private\{\
        bytes32 temp = keccak256(bids[msg.sender] , nonces[msg.sender]);\
        require(temp == bidsHashed[msg.sender], "bid or nonce is not verifyied");\
    \}\
    \
    function claimWinnerFunc() public payable \{\
        require(block.timestamp > revealPeriod , "Claiming winner is not started yet!");\
        require(msg.value == initialFund, "For claiming, please enter correct initial fund in Value input");\
        \
        auctionState = 2;\
        \
        for(uint i = 0 ; i < numberOfAddresses ; i++)\{\
            // addresses\
            if(winnerBid < bids[addresses[i]] ) \{\
                winnerBid = bids[addresses[i]];\
                winnerAddress = addresses[i];\
            \}\
        \}\
        \
        \
        if(msg.sender == winnerAddress) \{\
            residual = bids[winnerAddress] - initialFund;\
            // ***\
            residual = residual + initialFund;\
            auctioneer.transfer(residual);\
        \}\
        \
    \
        if(bids[msg.sender] == 0)\{\
            auctioneer.transfer(msg.value);\
        \}\
        \
    \}\
    \
    \
    function returnWinnerInfo() public view returns(address , uint)\{\
        require(block.timestamp > revealPeriod , "No winner info is obtained yet!");\
        return(winnerAddress,winnerBid);\
    \}\
    \
    \
    function amIDishonest() public view checkAddressOfBidder(msg.sender) returns(string)\{\
        require(block.timestamp > revealPeriod , "Honesty is determined after claiming the winner.");\
        if(bids[msg.sender] == 0)\{\
            return ("You are DISHONEST & initial fund is deducted from your account ! :(");\
        \}\
        else\{\
            return ("You are HONEST & initial fund is NOT deducted from your account ! :)");\
        \}\
    \}\
    \
    function getInitialFund() public view returns(uint)\{\
        return (initialFund);\
    \}\
    \
    function seondsRemaining() public view returns(uint)\{\
        if(auctionState == 0) \{\
            secs = biddingPeriod - block.timestamp;\
        \}\
        else if(auctionState == 1)\{\
            secs = revealPeriod - block.timestamp;\
        \}\
        else if (auctionState == 2)\{\
            secs = 0;\
        \}\
        \
        \
        return secs;\
    \}\
    \
\}\
\
}