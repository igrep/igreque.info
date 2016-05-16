import Prelude hiding (lookup)
import Data.Map (lookup, fromList)
import Control.Error.Util (note)

-- 従業員の氏名をキーに、所属する部署名を持つMap
employeeDept =
  fromList [("John", "Sales"), ("Bob", "IT"), ("Yuji", "c365")]

-- 部署名をキーに、部署がある国名を持つMap
deptCountry =
  fromList [("IT", "USA"), ("Sales", "France"), ("c365", "Japan")]

-- 国名をキーに、通貨の名前を持つMap
countryCurrency =
  fromList [("USA", "Dollar"), ("France", "Euro")]

employeeCurrency :: String -> Either String String
employeeCurrency name = do
  dept <- note "Department not found!" $ lookup name employeeDept
  country <- note "Country not found!" $ lookup dept deptCountry
  note "Currency not found!" $ lookup country countryCurrency
