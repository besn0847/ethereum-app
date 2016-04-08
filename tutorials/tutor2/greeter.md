	greeterContract.new(
		_greeting,
		{
			from:eth.accounts[2],
			data: greeterCompiled.greeter.code,
			gas: 300000
		},
		function(e, contract){
			if(!e) {
				if(!contract.address) {
					console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
				} else {
					console.log("Contract mined! Address: " + contract.address); console.log(contract);
				}
			}
		}
	);
