# Claims
The Crust Claims contract is used as the on-chain document that contains relevant information
for the generation of the initial state of Crust. There're 3 kind token contracts which holds 
the mapping of Ethereum addresses to a token amount (CRU, CRU18, CRU24). CRU is a standard ERC20 
token. CRU18 and CRU24 are locked and not transferable.

## Functionality

- Allows an allocation Ethereum address to claim their allocation to a Crust address.
- Allow Crust Committee to vest tokens to an Ethereum address .
- Allows Crust Committee to adjust the cap of the tokens.

## Run the tests

Clone the repository locally and run the following commands.

```sh
npm install
truffer test
```
