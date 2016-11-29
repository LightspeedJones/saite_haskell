{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Application where

import Foundation
import Yesod
import Handlers.Cliente
import Handlers.Login
import Handlers.Produto
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text
import Text.Lucius

------------------
mkYesodDispatch "App" resourcesApp

getLayoutLogado :: Text -> Handler Html
getLayoutLogado x = defaultLayout $ do
            toWidget[lucius|
                h1{
                    font-size: 30px;
                    font-family: segoe ui light;
                    text-align: center;
                }
                
                ul {
                    list-style-type: none;
                    margin: 0;
                    padding: 0;
                    overflow: hidden;
                    background-color: #333;
                }

                li {
                    float: left;
                    font-family: segoe ui light;
                    display: block;
                    color: white;
                    text-align: center;
                    padding: 14px 16px;
                    text-decoration: none;
                    font-color: white;
                }

                li :hover {
                    background-color: #111;
                }
                
                
            |]
            [whamlet|
                <ul>
                    <li> <a href=@{ClienteR}>Cadastro 
                    <li> <a href=@{CardapioR}>Cardapio 
                    <li style="float:right"> <a href=@{LogoutR}>Sair </a></ul>
                
                
                <h1> RESTAURANTE RESTAURANTOSO
                <h1> #{x}
            |]
            
            

getLayoutVisitante :: Handler Html
getLayoutVisitante = defaultLayout $ do
            toWidget[lucius|
                h1{
                    font-size: 30px;
                    margin-top: 40px;
                    margin-bottom: 40px;
                    font-family: segoe ui light;
                    text-align: center;
                }
                #teste {
                    list-style-type: none;
                    margin: 0;
                    padding: 0;
                    width: 200px;
                    background-color: #f1f1f1;
                }

                li a {
                    display: block;
                    color: #000;
                    padding: 8px 16px;
                    text-decoration: none;
                    font-family: segoe ui;
                    text-align: center;

                }

                li a:hover {
                    background-color: #555;
                    color: white;
                }
                
                h2 {
                    font-family: segoe ui light;
                    text-align: right;
                }
            |]
    
            [whamlet|
                <h1> RESTAURANTE RESTAURANTOSO
                <ul id="teste">
                    <li> <a href=@{ClienteR}> Cadastro
                    <li> <a href=@{CardapioR}> Cardapio
                    <li> <a href=@{LoginR}> Login
            
            |]
            
            --LoginR

getHomeR :: Handler Html
getHomeR  = do
    maybenome <- lookupSession "_NOME"
    
    case maybenome of
        Nothing -> (getLayoutVisitante)
        (Just nome) -> (getLayoutLogado nome)
    

-- getHomeR = defaultLayout $ do

--     toWidget[lucius|
--         h1{
--             font-size: 30px;
--             margin-top: 40px;
--             margin-bottom: 40px;
--             font-family: segoe ui light;
--             text-align: center;
--         }
--         ul {
--             list-style-type: none;
--             margin: 0;
--             padding: 0;
--             width: 200px;
--             background-color: #f1f1f1;
--         }

--         li a {
--             display: block;
--             color: #000;
--             padding: 8px 16px;
--             text-decoration: none;
--             font-family: segoe ui;
--             text-align: center;

--         }

--         li a:hover {
--             background-color: #555;
--             color: white;
--         }
--     |]
    
--     [whamlet|
--         <h1> RESTAURANTE RESTAURANTOSO
        
--         <ul>
--             <li> <a href=@{ClienteR}> Cadastro
--             <li> <a href=@{CardapioR}> Cardapio
--             <li> <a href=@{LoginR}> Login
            
--     |]
    
    -- [whamlet|
    --      <h1> Sistema academico
    --      <ul>
    --         <li> <a href=@{ProfR}> prof
    --         <li> <a href=@{CursoR}> curso
    --         <li> <a href=@{ListProfR}> lista prof
    --         <li> <a href=@{ListCursoR}> lista curso
    -- |]