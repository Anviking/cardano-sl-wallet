{ system
, compiler
, flags
, pkgs
, hsPkgs
, pkgconfPkgs
, ... }:
  {
    flags = {};
    package = {
      specVersion = "1.10";
      identifier = {
        name = "cardano-sl";
        version = "2.0.0";
      };
      license = "MIT";
      copyright = "2016 IOHK";
      maintainer = "Serokell <hi@serokell.io>";
      author = "Serokell";
      homepage = "";
      url = "";
      synopsis = "Cardano SL main implementation";
      description = "Please see README.md";
      buildType = "Simple";
    };
    components = {
      "library" = {
        depends = ([
          (hsPkgs.base)
          (hsPkgs.aeson)
          (hsPkgs.aeson-options)
          (hsPkgs.ansi-terminal)
          (hsPkgs.ansi-wl-pprint)
          (hsPkgs.async)
          (hsPkgs.bytestring)
          (hsPkgs.canonical-json)
          (hsPkgs.cardano-sl-binary)
          (hsPkgs.cardano-sl-binary-test)
          (hsPkgs.cardano-sl-chain)
          (hsPkgs.cardano-sl-core)
          (hsPkgs.cardano-sl-crypto)
          (hsPkgs.cardano-sl-crypto-test)
          (hsPkgs.cardano-sl-db)
          (hsPkgs.cardano-sl-infra)
          (hsPkgs.cardano-sl-networking)
          (hsPkgs.cardano-sl-util)
          (hsPkgs.conduit)
          (hsPkgs.constraints)
          (hsPkgs.containers)
          (hsPkgs.contravariant)
          (hsPkgs.cryptonite)
          (hsPkgs.data-default)
          (hsPkgs.directory)
          (hsPkgs.ekg-core)
          (hsPkgs.ekg)
          (hsPkgs.ether)
          (hsPkgs.exceptions)
          (hsPkgs.filelock)
          (hsPkgs.filepath)
          (hsPkgs.formatting)
          (hsPkgs.formatting)
          (hsPkgs.generics-sop)
          (hsPkgs.hspec)
          (hsPkgs.http-api-data)
          (hsPkgs.http-client)
          (hsPkgs.http-client-tls)
          (hsPkgs.http-conduit)
          (hsPkgs.http-types)
          (hsPkgs.lens)
          (hsPkgs.lifted-async)
          (hsPkgs.memory)
          (hsPkgs.monad-control)
          (hsPkgs.mtl)
          (hsPkgs.neat-interpolation)
          (hsPkgs.network)
          (hsPkgs.network-transport)
          (hsPkgs.optparse-applicative)
          (hsPkgs.parsec)
          (hsPkgs.pvss)
          (hsPkgs.QuickCheck)
          (hsPkgs.quickcheck-instances)
          (hsPkgs.random)
          (hsPkgs.reflection)
          (hsPkgs.safe-exceptions)
          (hsPkgs.serokell-util)
          (hsPkgs.servant)
          (hsPkgs.servant-client)
          (hsPkgs.servant-client-core)
          (hsPkgs.servant-server)
          (hsPkgs.servant-swagger)
          (hsPkgs.servant-swagger-ui)
          (hsPkgs.servant-swagger-ui-core)
          (hsPkgs.servant-swagger-ui-redoc)
          (hsPkgs.stm)
          (hsPkgs.streaming-commons)
          (hsPkgs.swagger2)
          (hsPkgs.tagged)
          (hsPkgs.template-haskell)
          (hsPkgs.text)
          (hsPkgs.time)
          (hsPkgs.time-units)
          (hsPkgs.tls)
          (hsPkgs.transformers)
          (hsPkgs.universum)
          (hsPkgs.unliftio)
          (hsPkgs.unordered-containers)
          (hsPkgs.wai)
          (hsPkgs.warp)
          (hsPkgs.warp-tls)
          (hsPkgs.x509)
          (hsPkgs.x509-store)
          (hsPkgs.x509-validation)
          (hsPkgs.yaml)
          (hsPkgs.cborg)
        ] ++ pkgs.lib.optional (!system.isWindows) (hsPkgs.unix)) ++ pkgs.lib.optional (!system.isWindows && !system.isFreebsd) (hsPkgs.systemd);
        build-tools = [
          (hsPkgs.buildPackages.cpphs)
        ];
      };
      tests = {
        "cardano-test" = {
          depends = [
            (hsPkgs.QuickCheck)
            (hsPkgs.base)
            (hsPkgs.bytestring)
            (hsPkgs.cardano-crypto)
            (hsPkgs.cardano-sl)
            (hsPkgs.cardano-sl-binary)
            (hsPkgs.cardano-sl-binary-test)
            (hsPkgs.cardano-sl-chain)
            (hsPkgs.cardano-sl-chain-test)
            (hsPkgs.cardano-sl-core)
            (hsPkgs.cardano-sl-core-test)
            (hsPkgs.cardano-sl-crypto)
            (hsPkgs.cardano-sl-crypto-test)
            (hsPkgs.cardano-sl-db)
            (hsPkgs.cardano-sl-db-test)
            (hsPkgs.cardano-sl-infra)
            (hsPkgs.cardano-sl-infra-test)
            (hsPkgs.cardano-sl-networking)
            (hsPkgs.cardano-sl-util)
            (hsPkgs.cardano-sl-util-test)
            (hsPkgs.conduit)
            (hsPkgs.containers)
            (hsPkgs.cryptonite)
            (hsPkgs.data-default)
            (hsPkgs.deepseq)
            (hsPkgs.extra)
            (hsPkgs.filelock)
            (hsPkgs.formatting)
            (hsPkgs.generic-arbitrary)
            (hsPkgs.hedgehog)
            (hsPkgs.hspec)
            (hsPkgs.lens)
            (hsPkgs.network-transport)
            (hsPkgs.network-transport-inmemory)
            (hsPkgs.pvss)
            (hsPkgs.random)
            (hsPkgs.reflection)
            (hsPkgs.serokell-util)
            (hsPkgs.tagged)
            (hsPkgs.text)
            (hsPkgs.time)
            (hsPkgs.time-units)
            (hsPkgs.universum)
            (hsPkgs.unordered-containers)
          ];
          build-tools = [
            (hsPkgs.buildPackages.hspec-discover)
            (hsPkgs.buildPackages.cpphs)
          ];
        };
      };
      benchmarks = {
        "cardano-bench-criterion" = {
          depends = [
            (hsPkgs.QuickCheck)
            (hsPkgs.base)
            (hsPkgs.bytestring)
            (hsPkgs.cardano-sl)
            (hsPkgs.cardano-sl-chain)
            (hsPkgs.cardano-sl-chain-test)
            (hsPkgs.cardano-sl-core)
            (hsPkgs.cardano-sl-core-test)
            (hsPkgs.cardano-sl-crypto)
            (hsPkgs.cardano-sl-crypto-test)
            (hsPkgs.cardano-sl-db)
            (hsPkgs.cardano-sl-infra)
            (hsPkgs.cardano-sl-networking)
            (hsPkgs.cardano-sl-util)
            (hsPkgs.cardano-sl-util-test)
            (hsPkgs.conduit)
            (hsPkgs.criterion)
            (hsPkgs.deepseq)
            (hsPkgs.formatting)
            (hsPkgs.network-transport)
            (hsPkgs.network-transport-inmemory)
            (hsPkgs.optparse-applicative)
            (hsPkgs.universum)
          ];
          build-tools = [
            (hsPkgs.buildPackages.cpphs)
          ];
        };
      };
    };
  } // {
    src = pkgs.fetchgit {
      url = "https://github.com/input-output-hk/cardano-sl";
      rev = "f39f9b033e615af55ba352b7034d96ebb068e61f";
      sha256 = "1v6384iy2kjp367qs6jnqm7lsa55wgh69z6dqf70vysqn9bc2iab";
    };
    postUnpack = "sourceRoot+=/lib; echo source root reset to \$sourceRoot";
  }