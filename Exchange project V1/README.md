The main goal of this project is swapping two different tokens between 2 smart contracts by using calls.
So to swap FirstCoin to SecondCoin you should mint a bit firstcoins,then Firstcoin.approve allowance to spend these tokens by Secondcoin's smart contract.
Then you should use  Secondcoin.trade and past the firstcoin smart contract address and amount that you allowed to spend to the Secondcoin smart contract,then it will work;
You can swap it back by using Secondcoin.approve and Firstcoin.trade 
