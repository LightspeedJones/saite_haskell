{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Application where

import Foundation
import Yesod
import Handlers.Cliente
import Handlers.Login
import Handlers.Cardapio
import Handlers.Admin
import Handlers.Produto
import Handlers.Pedido
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Text.Lucius

------------------
mkYesodDispatch "App" resourcesApp

getLayoutLogado :: Text -> Handler Html
getLayoutLogado x = defaultLayout $ do
            toWidget $(luciusFile "templates/home.lucius")
            [whamlet|
                <ul>
                    <li style="float:right"> <a href=@{LogoutR}>Sair </a>
                    <li style="float:right"> eae #{x} </ul>
                
                <h1> RESTAURANTE RESTAURANTOSO
                <h2> <a id="card" href=@{MenuR}> Cardapio
            |]

getLayoutVisitante :: Handler Html
getLayoutVisitante = defaultLayout $ do
            toWidget $(luciusFile "templates/home.lucius")
    
            [whamlet|
                <ul>
                    <li style="float:right"> <a href=@{LoginR}>Login </a>
                    <li style="float:right"> eae visitante </ul>
            
                <h1> RESTAURANTE RESTAURANTOSO
                <h2> <a id="cadastro" href=@{ClienteR}> Faça seu cadastro!
            |]
            
getLayoutAdmin :: Handler Html
getLayoutAdmin = defaultLayout $ do
            toWidget $(luciusFile "templates/home.lucius")
            
            [whamlet|
                <ul>
                    <li style="float:right"> <a href=@{LoginR}>Login </a>
                    <li style="float:right"> eae visitante </ul>
            
                <h1> RESTAURANTE RESTAURANTOSO
                <h2> <a id="prod" href=@{ClienteR}> Produtos
                <h2> <a id="prod" href=@{ClienteR}> Pedidos
            |]

getHomeR :: Handler Html
getHomeR  = do
    maybenome <- lookupSession "_NOME"
    
    case maybenome of
        Nothing -> (getLayoutVisitante)
        (Just nome) -> (getLayoutLogado nome)
        (Just "admin") -> (getLayoutLogado "admin")
        
    

