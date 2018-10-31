module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

succ :: Int -> Int
succ = (+ 1)
