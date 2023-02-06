const {assert} = require('chai');
const KryptoBird = artifacts.require('./Kryptobird')

//check for chai
require('chai')
.use(require('chai-as-promised'))
.should();

contract('KryptoBird', async (accounts) => {
    let contract;
    before(async () => {
           contract = await KryptoBird.deployed();
        }
    )

    describe('deployment', async () => {
        it('should deploys successfully', async () => {
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        });
        it('should has a name', async () => {
            const name = await contract.name();
            assert.equal(name, 'Kryptobird');
        });
        it('should has a symbol', async () => {
            const symbol = await contract.symbol();
            assert.equal(symbol, 'KBIRD');
        });
    })
    describe('minting', async () => {
        it('should create a new token', async () => {
            const result = await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();
            assert.equal(totalSupply, 1);
            const event = result.logs[0].args;
            assert.equal(event._to, accounts[0], 'to is msg.sender');

            await contract.mint('https...1').should.be.rejected;
        });
    })
    describe('indexing', async () => {
        it('should list KryptoBirdz', async () => {
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');
            const totalSupply = await contract.totalSupply();
            let result = [];
            let KryptoBird;
            for (i = 1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i - 1);
                result.push(KryptoBird);
            }
            let expected = ['https...1','https...2','https...3','https...4'];
            assert.equal(result.join(','), expected.join(','));
        });

    })
})
