{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative((<|>))
import Control.Monad(forM_)
import Control.Monad.IO.Class(liftIO)
import Snap.Core(Snap,route,writeBS)
import Snap.Util.FileServe(serveDirectoryWith,fancyDirectoryConfig,simpleDirectoryConfig)
import Snap.Http.Server(quickHttpServe)
import System.Directory(getDirectoryContents)
import System.FilePath((</>),takeExtension)
import System.Process(rawSystem)
import qualified Elm.Internal.Paths as Elm

main :: IO ()
main = 
  precompile >>
  getRuntime >>
  quickHttpServe site

site :: Snap ()
site =
  route [ ("reload", reload) ]
  <|> serveDirectoryWith fancyDirectoryConfig elmBuildFolder
  <|> serveDirectoryWith simpleDirectoryConfig "resources"

reload :: Snap ()
reload = liftIO precompile >> writeBS "Reload complete."

precompile :: IO ()
precompile =
  getFiles ".elm" elmSourceFolder >>= \files ->
  forM_ files externalCompile

getFiles :: String -> FilePath -> IO [FilePath]
getFiles ext directory =
  map (directory </>) `fmap` getDirectoryContents directory >>= \contents ->
  return (filter ((ext ==) . takeExtension) contents)

externalCompile :: FilePath -> IO ()
externalCompile file = 
  putStrLn ("Processing " ++ file ++ "...") >>
  rawSystem "elm" [ "--make"
                  , "--runtime=/elm-runtime.js"
                  , "--build-dir=" ++ elmBuildFolder
                  , "--cache-dir=" ++ elmCacheFolder
                  , file] >>
  return ()

getRuntime :: IO ()
getRuntime = writeFile "resources/elm-runtime.js" =<< readFile Elm.runtime

elmSourceFolder :: FilePath
elmSourceFolder = "public"

elmBuildFolder :: FilePath
elmBuildFolder = elmSourceFolder </> "build"

elmCacheFolder :: FilePath
elmCacheFolder = elmSourceFolder </> "cache"
