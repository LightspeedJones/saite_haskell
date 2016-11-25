{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handlers.Login where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Text.Lucius
import Database.Persist.Postgresql

formLogin :: Form (Text, Text)
formLogin = renderDivs $ (,) <$>
             areq textField "Login" Nothing <*>
             areq textField "Senha" Nothing

getLoginR :: Handler Html
getLoginR = do
            (widget, enctype) <- generateFormPost formLogin
            defaultLayout [whamlet|
             <form method=post action=@{LoginR} enctype=#{enctype}>
                 ^{widget}
                 <input type="submit" value="Cadastrar">
           |]

postLoginR :: Handler Html
postLoginR = do
            ((result, _), _) <- runFormPost formLogin
            case result of
                FormSuccess (login, pword) -> do
                   cara <- runDB $ selectFirst [ClienteLogin ==. login,
                                                ClientePword ==. pword] []
                   case cara of
                       Just (Entity pid cliente) -> do
                           setSession "_ID" (pack $ show $ fromSqlKey pid)
                           defaultLayout [whamlet|
                                Bem-vindo #{clienteLogin cliente}
                           |]
                           --redirect HomeR
                       Nothing -> redirect LoginR
                _ -> redirect HomeR

postLogoutR:: Handler Html
postLogoutR = do
    deleteSession "_ID"
    redirect HomeR