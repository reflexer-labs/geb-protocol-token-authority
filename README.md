# geb-gov-token-authority

Custom authority for allowing a protocol token to govern GEB.

Intentionally simple. Once set as the protocol token's authority, if the protocol token's `owner` field is subsequently set to zero, the following properties obtain:

* any user may call PROT's `burn` function
* only authorized users (according to the ProtocolTokenAuthority's `authorizedAccounts`) can call PROT's `mint()` function
* only the `root` user set in the authority can call other `isAuthorized`-protected functions of the PROT token contract
* only the `root` user can modify the ProtocolTokenAuthority's `authorizedAccounts`s or change the `root`

Though this contract could be used in different ways, it was designed in the context of an overall design for control of the PROT token via PROT governance as illustrated below.

```
<~~~ : points to source's authority
<=== : points to source's root or owner

------------------    -----------------    ----------------------    ------------------------    -----
|GovernanceQuorum|<~~~|GovernanceDelay|<===|GovernanceDelayProxy|<===|ProtocolTokenAuthority|<~~~|PROT|===>0
------------------    -----------------    ----------------------    ------------------------    -----
```

Such a structure allows governance proposals voted in on the GovernanceQuorum to make arbtirary changes to the PROT token and its permissions subject to a delay. (See DappHub contracts
[DSChief](https://github.com/dapphub/ds-chief) and [DSPause](https://github.com/dapphub/ds-pause)
for implementations of the voting contract and the delay contract, respectively.)

Note that the ProtocolTokenAuthority allows for upgrading of the PROT token's `authority` or `owner` by the `root`.
