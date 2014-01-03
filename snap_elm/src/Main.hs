{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative((<|>))
import Control.Monad(forM_)
import Snap.Core(Snap)
import Snap.Util.FileServe(serveDirectoryWith,fancyDirectoryConfig,simpleDirectoryConfig)
import Snap.Http.Server(quickHttpServe)
import System.Directory(setCurrentDirectory,getDirectoryContents)
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
  serveDirectoryWith fancyDirectoryConfig "public/build"
  <|> serveDirectoryWith simpleDirectoryConfig "resources"

precompile :: IO ()
precompile =
  setCurrentDirectory "public" >>
  getFiles ".elm" "." >>= \files ->
  forM_ files externalCompile >>
  setCurrentDirectory ".."

getFiles :: String -> FilePath -> IO [FilePath]
getFiles ext directory =
  map (directory </>) `fmap` getDirectoryContents directory >>= \contents ->
  return (filter ((ext ==) . takeExtension) contents)

externalCompile :: FilePath -> IO ()
externalCompile file =
  rawSystem "elm" ["--make", "--runtime=/elm-runtime.js", file] >>
  return ()

getRuntime :: IO ()
getRuntime = writeFile "resources/elm-runtime.js" =<< readFile Elm.runtime