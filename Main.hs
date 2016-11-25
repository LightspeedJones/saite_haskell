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

connStr = "dbname=d7f2o1s09j6k37 host=ec2-107-22-238-96.compute-1.amazonaws.com user=euiflrvvoqtphn password=cneAb8rnPXLKltdvfac-6G6dLU port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       warp 8080 (App pool)