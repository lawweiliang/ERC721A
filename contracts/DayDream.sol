// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ERC721A.sol";


contract DayDream is Ownable, ERC721A, ReentrancyGuard {
    using Address for address;
    using Strings for uint256;

    uint256 public constant price = 0.05 ether;
    uint256 public constant maxSupply = 6666;
    uint256 public constant maxMintPerUser = 20;
    string public baseTokenURI;
    bool public paused = false;

    uint256 public preSaleTime = 1636682400;
    uint256 public publicSaleTime = 1637028000;

    mapping(address => bool) public whiteList;
    mapping(uint256 => string) private _tokenURIs;

    event DayDreamPop(uint256 indexed tokenId, address indexed tokenOwner);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri
    ) ERC721A(_name, _symbol, maxMintPerUser, maxSupply) {
        baseTokenURI = _uri;
    }

    function preSale(uint8 _purchaseNum) external payable onlyWhiteList {
        require(!paused, "DayDream: currently paused");
        require(
            block.timestamp >= preSaleTime,
            "DayDream: preSale is not open"
        );
        require(
            (totalSupply() + _purchaseNum) <= maxSupply,
            "DayDream: reached max supply"
        );
        require(
            (numberMinted(_msgSender()) + _purchaseNum) <= maxMintPerUser,
            "DayDream: can not hold more than 5"
        );
        require(
            msg.value >= (price * _purchaseNum),
            "DayDream: price is incorrect"
        );

        _safeMint(_msgSender(), _purchaseNum);
    }

    function publicSale(uint8 _purchaseNum) external payable {
        require(!paused, "DayDream: currently paused");
        require(
            block.timestamp >= publicSaleTime,
            "DayDream: publicSale is not open"
        );
        require(
            (totalSupply() + _purchaseNum) <= maxSupply,
            "DayDream: reached max supply"
        );
        require(
            (numberMinted(_msgSender()) + _purchaseNum) <= maxMintPerUser,
            "DayDream: can not hold more than 5"
        );
        require(
            msg.value >= (price * _purchaseNum),
            "DayDream: price is incorrect"
        );

        _safeMint(_msgSender(), _purchaseNum);
    }

     // After 6 months, owner mint the rest and list it over opensea.
     function ownerMint()
        external
        onlyOwner
    {
        require(
            totalSupply() < maxSupply,
            "DayDream: reached max supply"
        );
        require(block.timestamp >= publicSaleTime + 180 days, "DayDream: Nesting 6 months"); 

        uint256 remainingNft = maxSupply - totalSupply();
        _safeMint(_msgSender(), remainingNft);
    } 

    modifier onlyWhiteList() {
        require(whiteList[_msgSender()], "DayDream: caller not in WhiteList");
        _;
    }

    function setPreSaleTime(uint256 _time) external onlyOwner {
        preSaleTime = _time;
    }

    function setPublicSaleTime(uint256 _time) external onlyOwner {
        publicSaleTime = _time;
    }

    function pauseSale() external onlyOwner {
        paused = !paused;
    }

    function addBatchWhiteList(address[] memory _accounts) external onlyOwner {
        for (uint256 i = 0; i < _accounts.length; i++) {
            whiteList[_accounts[i]] = true;
        }
    }

    function withdraw() external onlyOwner {
        // payable(owner()).transfer(address(this).balance);

        uint ethBalance = address(this).balance;

        uint section1Earn = (ethBalance / 1000) * 700;
        uint section2Earn = (ethBalance / 1000) * 275;
        uint section3Earn = (ethBalance / 1000) * 25;

        address section1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        payable(section1).transfer(section1Earn);

        address section2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
        payable(section2).transfer(section2Earn);

        address section3 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
        payable(section3).transfer(section3Earn);
    }

     function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = tokenOfOwnerByIndex(_owner, index);
            }
            return result;
        }
    }

    /* function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = tokenOfOwnerByIndex(_owner, index);
            }
            return result;
        }
    }

    function childContractOfToken(uint256 _tokenId)
        external
        view
        returns (address[] memory)
    {
        uint256 childCount = totalChildContracts(_tokenId);
        if (childCount == 0) {
            return new address[](0);
        } else {
            address[] memory result = new address[](childCount);
            uint256 index;
            for (index = 0; index < childCount; index++) {
                result[index] = childContractByIndex(_tokenId, index);
            }
            return result;
        }
    }

    function childTokensOfChildContract(uint256 _tokenId, address _childAddr)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = totalChildTokens(_tokenId, _childAddr);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = childTokenByIndex(_tokenId, _childAddr, index);
            }
            return result;
        }
    } */

    function _baseURI() internal view virtual override returns (string memory) {
      return baseTokenURI;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseTokenURI = _baseURI;
    }

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }
}
