{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE TypeApplications           #-}

module Test.Spec.Ed25519Bip44 (spec) where

import           Universum

import           Cardano.Crypto.Wallet (generate)
import           Pos.Crypto (PassPhrase (..), PublicKey, emptySalt,
                     mkEncSecretWithSaltUnsafe)

import           Cardano.Wallet.Kernel.Ed25519Bip44 (ChangeChain,
                     deriveAccountPrivateKey, deriveAddressPublicKey)

import qualified Data.ByteString as BS
import           Test.Hspec (Spec, describe, it)
import           Test.Pos.Core.Arbitrary ()
import           Test.QuickCheck (Arbitrary (..), InfiniteList (..), Property,
                     arbitraryBoundedIntegral, arbitrarySizedBoundedIntegral,
                     property, shrinkIntegral)

-- A wrapper type for hardened keys generator
newtype Hardened
    = Hardened Word32
    deriving (Show, Eq, Ord, Enum, Real, Integral, Num)

-- A wrapper type for non-hardened keys generator
newtype NonHardened
    = NonHardened Word32
    deriving (Show, Eq, Ord, Enum, Real, Integral, Num)

instance Bounded Hardened where
    minBound = Hardened 0x80000000 -- 2^31
    maxBound = Hardened $ maxBound @Word32

instance Bounded NonHardened where
    minBound = NonHardened $ minBound @Word32
    maxBound = NonHardened 0x7FFFFFFF -- 2^31 - 1

-- TODO (akegalj): seems like Large from quickcheck which is using
-- arbitrarySizedBoundedIntegral doesn't work correctly. That implementation
-- doesn't repect minBound and produces numbers which are bellow minBound!
instance Arbitrary Hardened where
    arbitrary = arbitraryBoundedIntegral
    shrink = filter (>= minBound) . shrinkIntegral

instance Arbitrary NonHardened where
    arbitrary = arbitrarySizedBoundedIntegral
    shrink = shrinkIntegral

-- | Deriving address public key should fail if address index
-- is hardened. We should be able to derive Address public key
-- only with non-hardened address index
prop_deriveAddressPublicKeyHardened
    :: PublicKey
    -> ChangeChain
    -> Hardened
    -> Property
prop_deriveAddressPublicKeyHardened accPubKey change (Hardened addressIx) =
    property $ isNothing addrPubKey
  where
    addrPubKey = deriveAddressPublicKey accPubKey change addressIx

-- | Deriving address public key should succeed if address index
-- is non-hardened.
prop_deriveAddressPublicKeyNonHardened
    :: PublicKey
    -> ChangeChain
    -> NonHardened
    -> Property
prop_deriveAddressPublicKeyNonHardened accPubKey change (NonHardened addressIx) =
    property $ isJust addrPubKey
  where
    addrPubKey = deriveAddressPublicKey accPubKey change addressIx

-- | Deriving account private key should always fail
-- if account index is non-hardened
prop_deriveAccountPrivateKeyNonHardened
    :: InfiniteList Word8
    -> PassPhrase
    -> NonHardened
    -> Property
prop_deriveAccountPrivateKeyNonHardened (InfiniteList seed _) passPhrase@(PassPhrase passBytes) (NonHardened accountIx) =
    property $ isNothing accPrvKey
  where
    masterEncPrvKey = mkEncSecretWithSaltUnsafe emptySalt passPhrase $ generate (BS.pack $ take 32 seed) passBytes
    accPrvKey =
        deriveAccountPrivateKey
            passPhrase
            masterEncPrvKey
            accountIx

-- | Deriving account private key should always succeed
-- if account index is hardened
prop_deriveAccountPrivateKeyHardened
    :: InfiniteList Word8
    -> PassPhrase
    -> Hardened
    -> Property
prop_deriveAccountPrivateKeyHardened (InfiniteList seed _) passPhrase@(PassPhrase passBytes) (Hardened accountIx) =
    property $ isJust accPrvKey
  where
    masterEncPrvKey = mkEncSecretWithSaltUnsafe emptySalt passPhrase $ generate (BS.pack $ take 32 seed) passBytes
    accPrvKey =
        deriveAccountPrivateKey
            passPhrase
            masterEncPrvKey
            accountIx

spec :: Spec
spec = describe "Ed25519Bip44" $ do
    describe "Deriving address public key" $ do
        it "fails if address index is hardened" $
            property prop_deriveAddressPublicKeyHardened
        it "succeeds if address index is non-hardened" $
            property prop_deriveAddressPublicKeyNonHardened
    describe "Deriving account private key" $ do
        it "fails if account index is non-hardened" $
            property prop_deriveAccountPrivateKeyNonHardened
        it "succeeds if account index is hardened" $
            property prop_deriveAccountPrivateKeyHardened
