// stake tokens 
// unstake tokens 
// issue tokens 
// add allowed tokens 
// getEth value
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contrats/token/ERC20/IERC20.sol";

contract TokenFarm is Ownable
{
    address[] public allowedTokens;
    address[] public stakers;
    mapping(address => mapping(address => uint256)) public stakingBalance;
    mapping(address => uint256) public uniqueTokensStaked;
    IERC20 public dappToken;

    constructor(address _dapptokenAddress) public
    {
        dappToken = IERC20(_dapptokenAddress);
    }

    function stakeTokens(uint256 _amount, address _token) public
    {
        // what tokens can they stake?
        // how much can they stake?
        require(_amount > 0, "bros add funds abeg!!!");
        require(tokenIsAllowed(_token), "Token is currently not allowed");
        // transferFrom
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        stakingBalance[_token][msg.sender] += amount;
        UpdateUniqueTokensStaked(msg.sender, _token);
        if(uniqueTokensStaked[msg.sender] == 1)
        {
            stakers.push(msg.sender);
        }

    }

    function UpdateUniqueTokensStaked(address _user, address _token) internal
    {
        if(stakingBalance[_token][_user] <= 0)
        {
            uniqueTokenStaked[_user] += 1;
        }
    }

    function tokenIsAllowed(address _token) public view returns(bool) 
    {
        for(uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++)
        {
            if(allowedTokens[allowedTokensIndex] == _token)
            {
                return true;
            }
            return false;
        }   
    }

    function addAllowedTokens(address _token) public onlyOwner
    {
        allowedTokens.push(_token);
    }

    function issueTokens() public onlyOwner
    {
        // 100 ETH 1:1 for every 1 Eth, we give 1 DApp Token
        // 50 ETH AND 50 DAI staked, and we want to give reward of 1 DAAP / 1 DAI
        // Issue tokens to all stakers
        for (uint256 stakersIndex = 0; stakersIndex < stakers.length; stakersIndex++ )
        {
            address recipeient = stakers[stakersIndex];
            uint256 iserTotalValue = getUserTotalValue(recipeient);
            // send then a token reward
            dappToken.transfer(recipeient);
            // based on their total value locked
        }

    }

    function getUserTotalValue(address _user) public view returns(uint256)
    {
        uint256 totalValue = 0;
        require(uniqueTokensStaked[_user] > 0, "No tokens staked!!");
        for (uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++)
        {
            totalValue += getUserSingleTokenValue(_user, allowedTokens[allowedTokensIndex]);
        }
    }

    function getUserSingleTokenValue(address _user, address _token) public view returns(uint256)
    {
        // 1 ETH -> $2,000
        //  2000
        // 200 DAI -> $200
        // 200
        if (uniqueTokensStaked[_user] <= 0)
        {
            return 0;
        }
        
    }

}