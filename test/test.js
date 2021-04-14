var DigigrafNFT = artifacts.require("./DigigrafNFT.sol");

// require('chai')
//     .use(require('chai-as-promised'))
//     .should()

contract('DigigrafNFT', ([acc1, acc2]) => {
    let digigrafNFT

    before(async () => {
        digigrafNFT = await DigigrafNFT.new()
    })

    describe('deploy and test...', () => {
        it('deploys successfully', async () => {
            const address = digigrafNFT.address
            assert.notEqual(address, 0x0)
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
        })
        it('...name', async () => {
          expect(await digigrafNFT.name()).to.be.eq('Digigraf')
        })
    
        it('...symbol', async () => {
          expect(await digigrafNFT.symbol()).to.be.eq('DIGIGRAF')
        })
    
        it('...owner address', async () => {
          expect(await digigrafNFT._contractOwner()).to.be.eq(acc1)
        })
    })

    describe('deploy, mint and test...', () => {
        let result
        before(async () => {
          result = await digigrafNFT.mint('token_uri_1', web3.utils.toWei('1', 'Ether'))
          await digigrafNFT.mint('token_uri_2', web3.utils.toWei('2', 'Ether'))
          await digigrafNFT.mint('token_uri_3', web3.utils.toWei('3', 'Ether'))
        })

        it('...total supply', async () => {
            expect(Number(await digigrafNFT.totalSupply())).to.be.eq(3)
        })
    
        it("...URI's", async () => {
            expect(await digigrafNFT.tokenURI('1')).to.be.eq('token_uri_1')
            expect(await digigrafNFT.tokenURI('2')).to.be.eq('token_uri_2')
            expect(await digigrafNFT.tokenURI('3')).to.be.eq('token_uri_3')
        })
    
        //check event
        it('creates images', async () => {
            // SUCESS
            const event = result.logs[0].args
            // assert.equal(event.id, 1, 'id is correct')
            // assert.equal(event.price, 0, 'price is correct')
            // assert.equal(event.owner, acc1, 'owner is correct')
            // assert.equal(event.uri, 'token_uri_1', 'uri is correct')
    
            // // FAILURE: Image must have hash
            // await digigrafNFT.mint('', 0, { from: acc1 }).should.be.rejected;
    
            // // FAILURE: Image must have description
            // await digigrafNFT.mint('Token uri', '', { from: acc1 }).should.be.rejected;
        })

        //check from Struct
        it('lists images', async () => {
            const image = await digigrafNFT.autographs(1)
            assert.equal(image.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
            assert.equal(image.owner, acc1, 'owner is correct')
        })
    
        
    })
})
