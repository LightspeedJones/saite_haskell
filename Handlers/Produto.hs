{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handlers.Produto where

import Foundation
import Yesod

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
          
postProdutoR :: Handler Html
postProdutoR = do 
    ((res,_),_) <- runFormPost formProduto
    case res of 
        FormSuccess prod -> do 
            runDB $ insert prod
            redirect ProdutoR
        _ -> redirect HomeR