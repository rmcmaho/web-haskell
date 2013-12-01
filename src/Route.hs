
module Route where

import Snap.Core
import qualified Data.ByteString.Char8 as B

import Database (projectById, getTitle)

webRoute router = do
  rq <- getRequest
  router $ rqPathInfo rq

routeAppURL appURL = do
  dbResults <- projectById number
  writeBS $ extractResults dbResults
  where
    numberString = B.unpack appURL
    number = read numberString::Int
    extractResults results = case results of 
      Just value -> B.pack $ getTitle value
      _ -> B.empty