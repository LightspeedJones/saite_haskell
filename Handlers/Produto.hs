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
import Text.Julius
--import Text.Julius.ToJavascript

getItens :: Text -> Handler Html
getItens nome = do
            --maybenome <- lookupSession "_NOME"
            card <- runDB $ selectList [] [Asc ProdutoNome]
            defaultLayout $ do
                toWidget[lucius|
                    table {
                        border-collapse: collapse;
                        width: 100%;
                    }

                    th, td {
                        text-align: left;
                        padding: 8px;
                        font-family: segoe ui light;
                    }

                    tr:nth-child(even){background-color: #f2f2f2}

                    th {
                        background-color: #4CAF50;
                        color: white;
                    }

                |]
                [whamlet|
                     <table id="cardapio" border="2">
                         <tr>
                             <th> Produto
                             <th> Valor
                         $forall Entity pid prod <- card
                             <tr>
                                 <td> #{produtoNome prod}
                                 <td> R$ #{produtoValor prod}
                |]
                
                toWidget [julius|
                    var table = document.getElementsByTagName("table")[0];
                    var tbody = table.getElementsByTagName("tbody")[0];
                    tbody.onclick = function (e) {
                        e = e || window.event;
                        var foi = [];
                        var target = e.srcElement || e.target;
                        while (target && target.nodeName !== "TR") {
                            target = target.parentNode;
                        }
                        if (target) {
                            var cells = target.getElementsByTagName("td");
                            for (var i = 0; i < cells.length; i++) {
                                foi.push(cells[i].innerHTML);
                            }
                        }
                        
                        alert(foi);
                    };
                |]
                
                
getCardapioR :: Handler Html
getCardapioR = do
    maybeid <- lookupSession "_ID"
    
    case maybeid of
        Nothing -> (getItens "")
        (Just id) -> (getItens id)

postCardapioR :: Handler Html
postCardapioR = undefined