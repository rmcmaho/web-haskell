{-# LANGUAGE FlexibleInstances #-}

module Database where

import Control.Applicative
import qualified Data.Text as T
import Snap
import Snap.Snaplet.PostgresqlSimple
import Database.PostgreSQL.Simple.FromRow


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
    show (Project title description) =
      "Project { title: " ++ T.unpack title ++ ", description: " ++ T.unpack description ++ " }\n"