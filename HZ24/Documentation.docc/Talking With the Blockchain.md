# Talking With the Blockchain

Any node will do.

## Overview

Conceptually, blockchain is often described as "just a giant spreadsheet". This description is adequate, and may guide the protagonist in the right direction, but more importantly, it is a **publicly available** "spreadsheet". This means, anyone can get a copy of the "spreadsheet" and gather whatever information they need, as long as they have an Internet connection and some spare bits on their hard drive.

## Let's Talk

There are 2 main ways of talking with the blockchain. One way is setting up a node yourself (i.e. keeping your own copy of the "spreadsheet"), or connect to a node someone else has shared with you. In either case, to get the information we want **reliably** via either one of these methods (i.e. any node), we require a common interface. We need to make sure when we say "I want a cheeseburger", we get a cheeseburger and not a ham & cheese croissant.

### JSON-RPC

The JSON-RPC specification is the interface implemented by Ethereum nodes so that people (or computers) that want to read Ethereum blockchain data, they have a common way of gathering the necessary information. Similar to a REST API call, you make a JSON-RPC request that adheres to this specification for the kind of information that you'd like to retrieve.

For example, to obtain the current block number, you form a JSON-RPC request for the method called `eth_blockNumber` to any node that adheres to the JSON-RPC specification, and it will return a response with the current block number.


**Example using curl**:
```bash
// Request
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}'
// Result
{
  "id":83,
  "jsonrpc": "2.0",
  "result": "0x4b7" // 1207
}
```

For a detailed explanation of this interface, see the official Ethereum documentation on [JSON-RPC API](https://ethereum.org/en/developers/docs/apis/json-rpc/).

> What's noteworthy about this particular JSON-RPC specification is that you can use this interface for many different networks, not just Ethereum. Any network that also use this ever-so-wonderful JSON-RPC specification is referred to as **EVM-compatible** chains. _Zora_ is one example of an EVM-compatible chain because it implements this same JSON-RPC specification. So, when we make this request to a **Zora node**, it will also return the current block number, but this time the current block number for the Zora network, instead of the Ethereum network.

> Terms like "API", "Specification", "Interface", and "Protocol" can be used interchangebly to refer to this common set of methods JSON-RPC methods.


