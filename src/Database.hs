{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Database (getAllProjects, dbHeistConfig, projectById, getTitle) where

import Control.Applicative
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as B
import Data.Monoid (mempty)
import Data.Maybe
import Snap
import Heist
import qualified Heist.Compiled as C
import Snap.Snaplet.PostgresqlSimple
import Database.PostgreSQL.Simple.FromRow()

import Application

instance HasPostgres (Handler b App) where
  getPostgresState = with pg get

data Project = Project
  { title :: T.Text
  , description :: T.Text
  }

getTitle project = T.unpack $ title project

instance FromRow Project where
  fromRow = Project <$> field <*> field

instance Show Project where
    show project =
      "Project { title: " ++ T.unpack (title project) ++ ", description: " ++ T.unpack (description project) ++ " }\n"

resultsOfProjectById projectId = query "SELECT title,description FROM projects where id = ?" (Only (projectId::Int))

projectById projectId = listToMaybe <$> resultsOfProjectById projectId

--projectSplice :: SplicesM (RuntimeSplice (Handler App App) Project -> C.Splice (Handler App App)) ()
projectSplice = do
  "title" ## (C.pureSplice . C.textSplice $ title)
  "description" ## (C.pureSplice . C.textSplice $ description)

splice :: C.Splice (Handler App App)
splice =  C.manyWithSplices C.runChildren projectSplice $ lift $ query_ "SELECT title,description FROM projects"

--dbHesitConfig = HeistConfig (Handler App App)
dbHeistConfig = mempty { hcCompiledSplices = ("project" ## splice), hcTemplateLocations = [loadTemplates "templates"] }

getAllProjects :: Handler App App ()
getAllProjects = do
  allProjects <- query_ "SELECT * FROM projects"
  writeBS $ B.pack $ show (allProjects :: [Project])


