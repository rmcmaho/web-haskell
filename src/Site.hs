{-# LANGUAGE OverloadedStrings #-}

module Site (siteInit) where

import qualified Data.ByteString.Char8 as B
import Snap.Core
import Snap.Snaplet
import Snap.Util.FileServe
import Snap.Snaplet.PostgresqlSimple

import Application
import Database

routes :: [(B.ByteString, Handler App App ())]
routes = [ ("", serveDirectory ".")
         , ("/projects", method GET getAllProjects)
         , ("/heist", method GET getAllProjectsHeist)
         ]

siteInit :: SnapletInit App App
siteInit = makeSnaplet "snap_postgres" "Simple snap site using postgres" Nothing $ do
  pgs <- nestSnaplet "pg" pg pgsInit
  addRoutes routes
  return $ App pgs
