import Control.Monad.Writer (Writer, tell, runWriter)
import Data.Char (isDigit)
import Text.Show.Unicode (uprint)

data UserInput =
  UserInput
    { name :: String
    , emailAddress :: String
    , annualIncome :: String
    }

validateInput :: UserInput -> Writer [String] ()
validateInput input = do
  mustBePresent "氏名" $ name input
  mustContainAtSign "メールアドレス" $ emailAddress input
  mustBePositiveInteger "年収" $ annualIncome input

mustBePresent :: String -> String -> Writer [String] ()
mustBePresent name text = do
  if null text
    then tell [name ++ "は必須入力項目です。"]
    else return ()

mustContainAtSign :: String -> String -> Writer [String] ()
mustContainAtSign name text = do
  if elem '@' text
    then return ()
    else tell [name ++ "の形式が正しくありません。"]

mustBePositiveInteger :: String -> String -> Writer [String] ()
mustBePositiveInteger name text = do
  if all isDigit text
    then return ()
    else tell [name ++ "は整数で入力してください。"]

main :: IO ()
main = do
  let input = UserInput "" "a" "nondigit"
  uprint $ runWriter $ validateInput input
