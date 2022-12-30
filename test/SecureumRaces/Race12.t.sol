import "forge-std/Test.sol";
import "../../src/SecureumRaces/Race12.sol";

contract Race12Test is Test {
    TokenV1 tokenV1;
    Vault vault;
    TokenV2 tokenV2;
    PermitModule permitModule;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
        vm.prank(alice);
        tokenV1 = new TokenV1();
        vault = new Vault(address(tokenV1));
        // tokenV2 = new TokenV2();
        // permitModule = new PermitModule();
    }

    function testAttack() public {
        // function naming error
        assert(true);
    }
}
