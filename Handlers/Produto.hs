{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Handlers.Produto where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Data.Maybe
import Data.Monoid
import Text.Hamlet (HtmlUrl, hamlet)

getCardapioR :: Handler Html
getCardapioR = do
            card <- runDB $ selectList [] [Asc ProdutoNome]
            defaultLayout $ do
                [whamlet|
                     <table border="2">
                         <tr>
                             <td> Nome
                             <td> Valor
                         $forall Entity pid prod <- card
                             <tr>
                                 <td> #{produtoNome prod}
                                 <td> R$ #{produtoValor prod}
                         
                |]
                
                