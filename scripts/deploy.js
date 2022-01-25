const hre = require("hardhat");

async function main(name = "GMA Tickets", symbol = "GMA", contract = "Ticket") {
  console.log(`⏳ Deploying contract for token ${name} (${symbol}) to network "${hre.network.name}"...`)
  const Ticket = await hre.ethers.getContractFactory(contract);
  const ticket = await Ticket.deploy(name, symbol);

  await ticket.deployed();
  console.log(`🚀 Deployed contract for token ${name} (${symbol}) to ${ticket.address} (network: ${hre.network.name})`)

  return ticket
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
