{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Handlers.Pedido where

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

getPedidoR :: Handler Html
getPedidoR = do
    order <- runDB $ selectList [] [Asc PedidoId]
    defaultLayout $ do
        toWidget $(luciusFile "templates/cardapio.lucius")
        -- $(whamletFile "templates/pedidos.hamlet")