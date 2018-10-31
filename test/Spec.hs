import           Lib
import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec =
    describe "succ" $ do
        it "succ 0 == 1" $ do
             Lib.succ Lib.zero `shouldSatisfy` (== 1)




