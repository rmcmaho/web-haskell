{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Database (getAllProjects) where

import Control.Applicative
import qualified Data.Text as T
import qualified Data.ByteString.Char8 as B
import Snap
import Snap.Snaplet.PostgresqlSimple
import Database.PostgreSQL.Simple.FromRow()

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

getAllProjects :: Handler App App ()
getAllProjects = do
  allProjects <- query_ "SELECT * FROM projects"
  writeBS $ B.pack $ show (allProjects :: [Project])
