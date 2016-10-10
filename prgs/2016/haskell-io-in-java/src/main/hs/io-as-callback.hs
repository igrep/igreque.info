#!/usr/bin/env stack
-- stack --resolver=lts-7.2 runghc --package=bytestring

import System.IO (withFile, IOMode(ReadMode))
import qualified Data.ByteString.Char8 as BS

data FileReader =
  FileReader
    { path :: String
    , onOpened :: IO ()
    , onClosed :: IO ()
    }

readBy :: FileReader -> IO BS.ByteString
readBy reader =
  let readFiringEvents handle = do
        onOpened reader
        contents <- BS.hGetContents handle
        putStrLn "Processing file..."
        onClosed reader
        return contents
  in
    withFile (path reader) ReadMode readFiringEvents


notifyOpened :: IO ()
notifyOpened =
  putStrLn "Opened!"

notifyClosed :: IO ()
notifyClosed =
  putStrLn "Closed!"

main :: IO ()
main = do
  let fileReader =
        FileReader
          { path = "sample.txt"
          , onOpened = notifyOpened
          , onClosed = notifyClosed
          }

  content <- readBy fileReader
  putStrLn "The content was:"
  BS.putStrLn content
