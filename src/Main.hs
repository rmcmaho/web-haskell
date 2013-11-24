{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Snap

import Site

main :: IO ()
main = serveSnaplet defaultConfig siteInit