//     ___                         __ 
//    /   |  _____________  ____  / /_
//   / /| | / ___/ ___/ _ \/ __ \/ __/
//  / ___ |(__  |__  )  __/ / / / /_  
// /_/  |_/____/____/\___/_/ /_/\__/  
// 
// 2022 - Assent Protocol

pragma solidity =0.5.16;

import './IAssentFactory.sol';
import './AssentPair.sol';
import './IAssentVIP.sol';

contract AssentFactory is IAssentFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(AssentPair).creationCode));

    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    IAssentVIP public vip;    

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    event FeeToUpdated(address indexed previousAddress, address indexed newAddress);
    event FeeToSetterUpdated(address indexed previousAddress, address indexed newAddress);
    event VIPUpdated(IAssentVIP indexed previousAddress, IAssentVIP indexed newAddress);

    constructor(address _feeToSetter,address _feeTo) public {
        require (_feeTo!=address(0),"_feeTo : Forbidden");
        require (_feeToSetter!=address(0),"_feeToSetter : Forbidden");
        feeTo = _feeTo;
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'AssentSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'AssentSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'AssentSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(AssentPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IAssentPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'AssentSwap: FORBIDDEN');
        emit FeeToUpdated(feeTo, _feeTo);
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'AssentSwap: FORBIDDEN');
        emit FeeToSetterUpdated(feeToSetter, _feeToSetter);
        feeToSetter = _feeToSetter;
    }
    
    function setSwapFee(address _pair, uint32 _swapFee) external {
        require(msg.sender == feeToSetter, 'AssentSwap: FORBIDDEN');
        AssentPair(_pair).setSwapFee(_swapFee);
    }

    function setVIP(IAssentVIP _vip) external {
        require(msg.sender == feeToSetter, 'AssentSwap: FORBIDDEN');
        require (_vip.isVIP(), "Not a vip contract");
        require (_vip.getDexFeeReduction(address(this)) == 0, "getAssentFeeReduction wrong answer");
        emit VIPUpdated(vip, _vip);
        vip = _vip;
    }

    function getDexFeeReduction(address _user) view public returns(uint _dexFeeReduction) {
        if (address(vip) != address(0)) {
            return vip.getDexFeeReduction(_user);
        }
        else {
            return 0;
        }        
    }         
}