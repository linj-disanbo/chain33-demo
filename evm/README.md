
## 智能合约

智能合约是用 solidity 实现的.

1.  需要定义合约的 ABI（Application Binary Interface），可以使用 solc（Solidity Compiler）来编译 solidity 合约代码生成 ABI ()

2.  使用 golang 调用需要使用 go-ethereum 中的 abi 库来编写evm合约调用的代码

参考文档 https://chain.33.cn/document/67

下面以一个nft合约为例子演示智能合约的使用

## nft 合约部署

参考文档 https://github.com/assetcloud/AssetChain/wiki/%E5%BC%80%E5%8F%91-%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6-Remix-Metamask%E5%BC%80%E5%8F%91%E6%99%BA%E8%83%BD%E5%90%88%E7%BA%A6

## nft 合约调用

下载依赖

```
$ npm init -y
$ npm install --save-dev @openzeppelin/contracts
```

在 nft/nft 目录下 放置 tools 和 @openzeppelin

```
$ ls
  nft.sol  @openzeppelin  tools
```

生成 nft.go

```
./tools/abigen --solc ./tools/solc  --sol nft.sol   --pkg nft  --out nft.go
```

编译测试

```
go build call_nft2.go
```


## 合约代码


./evm/nft/nft/nft.sol

```
 pragma solidity ^0.8.6;

   import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
   import "@openzeppelin/contracts/utils/Counters.sol";
   import "@openzeppelin/contracts/access/Ownable.sol";
   import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

   contract AsNFT is ERC721URIStorage, Ownable {
       using Counters for Counters.Counter;
       Counters.Counter private _tokenIds;

       constructor() ERC721("Goddess", "GODDESS") {}

       function mintNFT(address recipient, string memory tokenURI)
           public onlyOwner
           returns (uint256)
       {
           _tokenIds.increment();

           uint256 newItemId = _tokenIds.current();
           _mint(recipient, newItemId);
           _setTokenURI(newItemId, tokenURI);

           return newItemId;
       }
   }
```
