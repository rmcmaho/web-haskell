-- For makeLenses
{-# Language TemplateHaskell #-}

module Application where

import Control.Lens
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple

data App = App
  { _pg :: Snaplet Postgres
  }
  
makeLenses ''App
