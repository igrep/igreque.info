import Control.Monad.Writer (Writer, tell, execWriter)

-- とある人のテストの成績
data Scores =
  Scores
    { test1 :: Int
    , test2 :: Int
    , test3 :: Int
    }

countScore :: Int -> Writer [Int] ()
countScore int =
  tell [int]

runTests :: Scores -> Int
runTests scores =
  -- execWriter は runWriter した結果にsndを適用する関数。
  -- tellして貯めていった結果**のみ**に関心がある場合に使う。
  let points = execWriter $ do
        countScore $ test1 scores
        countScore $ test2 scores
        countScore $ test3 scores
  in
    sum points

main :: IO ()
main = do
  let input = Scores 30 50 100
  print $ runTests input
