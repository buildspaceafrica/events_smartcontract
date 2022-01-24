const hre = require("hardhat");

async function main() {
  const Ticket = await hre.ethers.getContractFactory("Ticket");
  const ticket = await Ticket.deploy("BSA Tickets", "GMAF");
  await ticket.deployed();

  console.log("🚀 Contract deployed to address:", ticket.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
