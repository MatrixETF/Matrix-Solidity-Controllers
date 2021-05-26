pragma solidity ^0.6.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {

    bool public failTransferFrom;
    bool public failTransfer;
    bool public returnFalseTransferFrom;
    bool public returnFalseTransfer;
    bool public doKyberLikeApproval;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol) public {
        _setupDecimals(_decimals);
    }


    // TEST CONDITIONS SETTERS
    
    function setTransferFromFailed(bool _value) external {
        failTransferFrom = _value;
    }

    function setTransferFailed(bool _value) external {
        failTransfer = _value;
    }

    function setTransferFromReturnFalse(bool _value) external {
        returnFalseTransferFrom = _value;
    }

    function setTransferReturnFalse(bool _value) external {
        returnFalseTransfer = _value;
    }

    function setDoKyberLikeApproval(bool _value) external {
        doKyberLikeApproval = _value;
    }

    // ERC20 OVERRIDES

    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool) {
        require(!failTransferFrom, "MockToken.transferFrom: transferFrom set to fail");

        if(returnFalseTransferFrom) {
            return false;
        }

        return super.transferFrom(_from, _to, _amount);
    }

    function transfer(address _to, uint256 _amount) public override returns (bool) {
        require(!failTransfer, "MockToken.transfer: transferFrom set to fail");

        if(returnFalseTransfer) {
            return false;
        }

        return super.transfer(_to, _amount);
    }

    function approve(address _spender, uint256 _amount) public override returns (bool) {
        if(doKyberLikeApproval) {
            require(_amount == 0 || allowance(msg.sender, _spender) == 0, "APPROVAL_NOT_CURRENTLY_ZERO");
        }
        return super.approve(_spender, _amount);
    }

    function mint(address _to, uint256 _amount) external {
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) external {
        _burn(_from, _amount);
    }
}