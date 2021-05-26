pragma solidity ^0.6.4;

import "./MockToken.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract MockCToken is MockToken {
    using SafeMath for uint256;
    uint256 public exchangeRate = 1 ether / 5;
    MockToken public underlying;

    uint256 public errorCode;
    constructor(address _underlying) MockToken("cTOKEN", "cToken", 18) public {
        underlying = MockToken(_underlying);
    }

    function mint(uint256 _amount) external returns(uint256) {
        require(underlying.transferFrom(msg.sender, address(this), _amount), "MockCToken.mint: transferFrom failed");

        uint256 mintAmount = _amount.mul(10**18).div(exchangeRate);
        _mint(msg.sender, mintAmount);

        return errorCode;
    }

    function exchangeRateStored() external view returns(uint256) {
        return exchangeRate;
    }

    function redeem(uint256 _amount) external returns(uint256) {
        _burn(msg.sender, _amount);

        uint256 underlyingAmount = _amount.mul(exchangeRate).div(10**18);
        underlying.mint(msg.sender, underlyingAmount);

        return errorCode;
    }

    function redeemUnderlying(uint256 _amount) external returns(uint256) {
        uint256 internalAmount = _amount.mul(10**18).div(exchangeRate);
        _burn(msg.sender, internalAmount);

        underlying.mint(msg.sender, _amount);

        return errorCode;
    }

    function balanceOfUnderlying(address _owner) external returns(uint256) {
        return balanceOf(_owner).mul(exchangeRate).div(10**18);
    }

    function setErrorCode(uint256 _value) public {
        errorCode = _value;
    }
}