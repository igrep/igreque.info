#!/usr/bin/env stack
-- stack --resolver=lts-5.8 runghc --package=mtl

import Control.Monad (forM_)
import Control.Monad.State.Lazy (execState, modify)

import Prelude hiding (sum)


main :: IO ()
main = print $ sum [1, 2, 3]


sum :: [Int] -> Int
sum integers =
  (flip execState) 0 $ do
    forM_ integers $ \i -> do
      modify (+ i)
