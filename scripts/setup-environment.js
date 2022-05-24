const hre = require("hardhat");

async function main() {
	console.log("Deploying Contracts...");

	const TokenA = await hre.ethers.getContractFactory("tokenA");
	const tokenA = await TokenA.deploy();
	await tokenA.deployed();
	console.log("tokenA deployed to:", tokenA.address);
	
	const TokenB = await hre.ethers.getContractFactory("tokenB");
	const tokenB = await TokenB.deploy();
	await tokenB.deployed();
	console.log("tokenB deployed to:", tokenB.address);

	const Token_exchanger = await hre.ethers.getContractFactory("token_exchanger");
	const token_exchanger = await Token_exchanger.deploy();
	await token_exchanger.deployed();
	console.log("token_exchanger deployed to:", token_exchanger.address);
	
	
	const accounts = await hre.ethers.getSigners();
	accounts.forEach(async (account) => {
		tokenA.transfer(account.address,1000)
			.then((tx) => { console.log("1000 tokenA transferred from OWNER to ",account.address)});
		tokenB.transfer(account.address,1000)
			.then((tx) => { console.log("1000 tokenB transferred from OWNER to ",account.address)});
		let a = await tokenA.connect(account);
		a.approve(token_exchanger.address,500)
			.then((tx) => { console.log("500 tokenA approved from ",account.address, "to exchanger_token")});
		let b = await tokenB.connect(account);
		b.approve(token_exchanger.address,500)
			.then((tx) => { console.log("500 tokenB approved from ",account.address ,"to exchanger_token")});
	});

}
main().catch((error) => {
	console.error(error);
	process.exitCode=1;
});

