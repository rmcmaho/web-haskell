-- For makeLenses
{-# Language TemplateHaskell #-}

module Application where

import Control.Lens
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import Snap.Snaplet.Heist

data App = App
  { _pg :: Snaplet Postgres
  , _heist :: Snaplet (Heist App)
  }
  
makeLenses ''App
