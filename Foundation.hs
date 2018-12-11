{-# LANGUAGE OverloadedStrings, TypeFamilies, QuasiQuotes,
             TemplateHaskell, GADTs, FlexibleContexts,
             MultiParamTypeClasses, DeriveDataTypeable, EmptyDataDecls,
             GeneralizedNewtypeDeriving, ViewPatterns, FlexibleInstances #-}
module Foundation where

import Yesod
import Data.Text
import Database.Persist.Quasi
import Database.Persist.Postgresql
    ( ConnectionPool, SqlBackend, runSqlPool)

data App = App {connPool :: ConnectionPool }

share [mkPersist sqlSettings, mkMigrate "migrateAll"] $(persistFileWith lowerCaseSettings "config/models")

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App where
    isAuthorized AdminR _ = isAdmin
    isAuthorized HomeR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized (CardapioR _) _ = return Authorized
    isAuthorized MenuR _ = return Authorized
    isAuthorized LogoutR _ = return Authorized
    isAuthorized ProdutoR _ = isAdmin

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage
    
isAdmin = do
    logado <- lookupSession "_NOME"
    case logado of
        Just "admin" -> return Authorized
        Just _ -> return $ Unauthorized "sai"
        Nothing -> return AuthenticationRequired