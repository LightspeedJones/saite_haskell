{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Main where
import Application
import Yesod
--import Yesod.Static
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Database.Persist.Postgresql

connStr = "dbname=d2u93juttrkmet host=ec2-54-225-76-201.compute-1.amazonaws.com user=vqfphlebxqsdmn password=d3437208dc39b23262ba0aa9cc0d17e7a08c0d4b847dcb656c89bad866e73f53 port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       warp 8080 (App pool)