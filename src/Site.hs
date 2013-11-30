{-# LANGUAGE OverloadedStrings #-}

module Site (siteInit) where

import qualified Data.ByteString.Char8 as B
import Snap.Core
import Snap.Snaplet
import Snap.Util.FileServe
import Snap.Snaplet.Heist
import Snap.Snaplet.PostgresqlSimple

import Application
import Database

instance HasHeist App where
  heistLens = subSnaplet heist

routes :: [(B.ByteString, Handler App App ())]
routes = [ ("", serveDirectory ".")
         , ("/projects", method GET getAllProjects)
         , ("/heist", method GET (cRender "database"))
         ]

siteInit :: SnapletInit App App
siteInit = makeSnaplet "snap_postgres" "Simple snap site using postgres" Nothing $ do
  pgs <- nestSnaplet "pg" pg pgsInit
  hs <- nestSnaplet "" heist $ heistInit "templates"
  addConfig hs dbHeistConfig
  addRoutes routes
  return $ App pgs hs
