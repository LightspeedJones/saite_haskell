{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Handlers.Admin where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Data.Maybe
import Data.Monoid
import Text.Hamlet (HtmlUrl, hamlet)
import Text.Julius
import Text.Lucius

getAdminR :: Handler Html
getAdminR = defaultLayout $ do
            toWidget $(luciusFile "templates/home.lucius")
            
            [whamlet|
                <ul>
                    <li style="float:right"> <a href=@{LogoutR}>Sair </a>
                    <li style="float:right"> ola ademir </ul>
            
                <h1> RESTAURANTE RESTAURANTOSO
                <h2> <a id="prod" href=@{ProdutoR}> Produtos
                <h2> <a id="ped" href=@{ClienteR}> Pedidos
            |]