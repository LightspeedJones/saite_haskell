{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handlers.Cliente where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Data.Maybe
import Data.Monoid

formCliente :: Form Cliente
formCliente = renderDivs $ Cliente
    <$> areq textField "Nome" Nothing
    <*> areq textField "Endereco" Nothing
    <*> areq textField "Telefone" Nothing
    <*> areq textField "Login" Nothing
    <*> areq textField "Senha" Nothing
    
getClienteR :: Handler Html
getClienteR = do
           (widget, enctype) <- generateFormPost formCliente
           defaultLayout [whamlet|
             <form method=post action=@{ClienteR} enctype=#{enctype}>
                 ^{widget}
                 <input type="submit" value="Cadastrar">
           |]
           
postClienteR :: Handler Html
postClienteR = do
                ((result, _), _) <- runFormPost formCliente
                case result of
                    FormSuccess cliente -> do
                       unicoLogin <- runDB $ getBy $ UniqueLogin (clienteLogin cliente)
                       case unicoLogin of
                           Just _ -> do
                              defaultLayout [whamlet|
                                Login já cadastrado
                              |]
                           Nothing -> do 
                              pid <- runDB $ insert cliente
                              defaultLayout [whamlet|
                                Cliente cadastrado com sucesso!
                              |]
                              --redirect (ClienteR pid)
                    _ -> redirect HomeR