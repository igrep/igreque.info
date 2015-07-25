import Data.STRef
import Control.Monad
import Control.Monad.ST
import Prelude hiding (sum)

-- Haskellが分からない場合はとりあえず読み飛ばそう！ここではそんなに重要じゃない！
sum :: [Int] -> Int
sum numbers = runST $ do
  result <- newSTRef 0 -- 最終的に結果として返す変数を初期化して...
  forM_ numbers $ \n -> do
    modifySTRef' result (+n) -- 書き変えていって...
  readSTRef result -- 結果として返す
