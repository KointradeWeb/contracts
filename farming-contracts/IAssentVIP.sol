//     ___                         __ 
//    /   |  _____________  ____  / /_
//   / /| | / ___/ ___/ _ \/ __ \/ __/
//  / ___ |(__  |__  )  __/ / / / /_  
// /_/  |_/____/____/\___/_/ /_/\__/  
// 
// 2022 - Assent Protocol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

// Shorten version with only functions needed for the masterchef

interface IAssentVIP {
    
    function isVIP() external view returns(bool result);

    function getFarmsDepFeeReduction(address _user) external view returns(uint reduction);
    
}