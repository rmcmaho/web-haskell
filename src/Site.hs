{-# LANGUAGE OverloadedStrings #-}

module Site where

import qualified Data.ByteString.Char8 as B
import Snap.Core
import Snap.Snaplet
import Snap.Util.FileServe
import Snap.Snaplet.PostgresqlSimple

import Application
import Database

getAllProjects :: Handler App App ()
getAllProjects = do
  allProjects <- query_ "SELECT * FROM projects"
  writeBS $ B.pack $ show (allProjects :: [Project])

routes :: [(B.ByteString, Handler App App ())]
routes = [ ("",          serveDirectory "static")
         , ("/projects", method GET getAllProjects)
         ]

siteInit :: SnapletInit App App
siteInit = makeSnaplet "snap_postgres" "Simple snap site using postgres" Nothing $ do
  pgs <- nestSnaplet "pg" pg pgsInit
  addRoutes routes
  return $ App pgs