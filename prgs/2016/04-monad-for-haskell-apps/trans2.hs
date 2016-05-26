import Control.Monad.Except (throwError)
import Control.Monad.Writer (WriterT, tell, execWriterT)
import Text.Show.Unicode (uprint)

-- とある人のテストの成績
data Scores =
  Scores
    { test1 :: Int
    , test2 :: Int
    , test3 :: Int
    }

-- 成績計算Monad。Monad Transformerで
type CountScoreMonad =
  WriterT [Int] (Either String) ()

countScore :: Int -> CountScoreMonad
countScore score =
  if score >= 50
    then tell [score]
    else throwError "赤点！"

runTests :: Scores -> Either String Int
runTests scores =
  -- execWriterT は runWriterT した結果にsndを適用する関数。
  -- tellして貯めていった結果**のみ**に関心がある場合に使う。
  let result :: Either String [Int]
      result = execWriterT $ do
        countScore $ test1 scores
        countScore $ test2 scores
        countScore $ test3 scores
  in
    do -- このdoブロックは、fmap sum pointsと書き換えてもよい。
      points <- result
      return $ sum points

main :: IO ()
main = do
  let input = Scores 30 50 100
  uprint $ runTests input
