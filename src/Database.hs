{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Database (getAllProjects, getAllProjectsHeist) where

import Control.Applicative
import Control.Monad.Trans.Either
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as B
import Snap
import Heist
import qualified Heist.Compiled as C
import Snap.Snaplet.PostgresqlSimple
import Database.PostgreSQL.Simple.FromRow()
import Blaze.ByteString.Builder

import Application

instance HasPostgres (Handler b App) where
  getPostgresState = with pg get

data Project = Project
  { title :: T.Text
  , description :: T.Text
  }

instance FromRow Project where
  fromRow = Project <$> field <*> field

instance Show Project where
    show project =
      "Project { title: " ++ T.unpack (title project) ++ ", description: " ++ T.unpack (description project) ++ " }\n"

--projectSplice :: SplicesM (RuntimeSplice (Handler App App) Project -> C.Splice (Handler App App)) ()
projectSplice = do
  "title" ## (C.pureSplice . C.textSplice $ title)
  "description" ## (C.pureSplice . C.textSplice $ description)

splice :: C.Splice (Handler App App)
splice =  C.manyWithSplices C.runChildren projectSplice $ lift $ query_ "SELECT * FROM projects"

getHeistState heistConfig = liftIO $ either (error "Heist Init failed") id <$> (runEitherT $ initHeist heistConfig)

getBuilder heistState = maybe (error "Render template failed") fst $ C.renderTemplate heistState "database"

getAllProjectsHeist = do
  let heistConfig = HeistConfig defaultInterpretedSplices defaultLoadTimeSplices ("project" ## splice) noSplices [loadTemplates "templates"]
  heistState <- getHeistState heistConfig
  builder <- getBuilder heistState
  writeBS $ toByteString builder

getAllProjects :: Handler App App ()
getAllProjects = do
  allProjects <- query_ "SELECT * FROM projects"
  writeBS $ B.pack $ show (allProjects :: [Project])
