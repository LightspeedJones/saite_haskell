{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handlers.Produto where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Data.Maybe
import Data.Monoid
import Text.Julius

formProduto :: Form Produto
formProduto = renderDivs $ Produto <$> 
    areq textField "Nome: " Nothing <*> 
    areq doubleField "Valor: " Nothing <*>
    areq textField "Tipo: " Nothing
    
getProdutoR :: Handler Html
getProdutoR = do
          (widget, enctype) <- generateFormPost formProduto
          
          defaultLayout [whamlet|
             <form method=post action=@{ProdutoR} enctype=#{enctype}>
                 ^{widget}
                 <input type="submit" value="Cadastrar">
          |]
          
-- listaProd = do
--       entidades <- runDB $ selectList [] [Asc TipoProdutoNometipo] 
--       optionsPairs $ fmap (\ent -> (TipoProdutoId $ entityVal ent, entityKey ent)) entidades       
          
          
postProdutoR :: Handler Html
postProdutoR = do 
    ((res,_),_) <- runFormPost formProduto
    case res of 
        FormSuccess prod -> do 
            did <- runDB $ insert prod
            -- setMessage [shamlet|
            --     <h1>
            --         Produto inserida!
            -- |]
            redirect ProdutoR
        _ -> redirect HomeR