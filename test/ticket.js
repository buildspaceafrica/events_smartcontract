const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Ticket", function () {
  it("Should have 0 total supply after deployment", async function () {
    const Ticket = await ethers.getContractFactory("Ticket");
    const ticket = await Ticket.deploy("GMA Tickets", "GMA");
    await ticket.deployed();

    expect(await ticket.totalSupply()).to.equal(0);
  });
});
 