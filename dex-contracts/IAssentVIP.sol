//     ___                         __ 
//    /   |  _____________  ____  / /_
//   / /| | / ___/ ___/ _ \/ __ \/ __/
//  / ___ |(__  |__  )  __/ / / / /_  
// /_/  |_/____/____/\___/_/ /_/\__/  
// 
// 2022 - Assent Protocol

// SPDX-License-Identifier: MIT

pragma solidity =0.5.16;

// Shorten version with only functions needed for the DEX

interface IAssentVIP {
    
    function isVIP() external view returns(bool result);

    function getDexFeeReduction(address _user) external view returns(uint reduction);
    
}