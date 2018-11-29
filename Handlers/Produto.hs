{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
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
import Text.Lucius

formPedido :: Form (Text, Text)
formPedido = renderDivs $ (,) <$>
             areq textField "Login" Nothing <*>
             pure "1"

getItens :: Text -> Handler Html
getItens nome = do
            (widget, enctype) <- generateFormPost formPedido
            card <- runDB $ selectList [ProdutoTipoprodutoid ==. (toSqlKey $ fromIntegral 1)] [Asc ProdutoNome]
            beb <- runDB $ selectList [ProdutoTipoprodutoid ==. (toSqlKey $ fromIntegral 2)] [Asc ProdutoNome]
            defaultLayout $ do
                toWidget $(juliusFile "templates/cardapio.julius")
                toWidget $(luciusFile "templates/cardapio.lucius")
                $(whamletFile "templates/cardapio.hamlet")
                
                --vatdadasddasdas
                -- pedidoId <- insert $ Pedido 10 $ 18.00
                

                
                
getItensVisitante :: Handler Html
getItensVisitante = do
            -- card <- runDB $ selectList [ProdutoTipoprodutoid ==. (toSqlKey $ fromIntegral 1)] [Asc ProdutoNome]
            -- beb <- runDB $ selectList [ProdutoTipoprodutoid ==. (toSqlKey $ fromIntegral 2)] [Asc ProdutoNome]
            -- defaultLayout $ do
            --     toWidget[lucius|
            --         table {
            --             margin-top: 20px;
            --             border-collapse: collapse;
            --             width: 100%;
            --         }

            --         th, td {
            --             text-align: left;
            --             padding: 8px;
            --             font-family: segoe ui light;
            --         }

            --         tr:nth-child(even){background-color: #f2f2f2}

            --         th {
            --             background-color: #555;
            --             color: white;
            --         }
                    
            --         ul {
            --             list-style-type: none;
            --             margin: 0;
            --             padding: 0;
            --             overflow: hidden;
            --             background-color: #333;
            --         }

            --         li {
            --             float: left;
            --         }

            --         li{
            --             display: block;
            --             color: white;
            --             text-align: center;
            --             padding: 14px 16px;
            --             text-decoration: none;
            --             font-family: segoe ui light;
            --         }
                
            --         a{
            --             color: white;
            --         }

            --         li a:hover:not(.active) {
            --             background-color: #111;
            --         }

            --         .active {
            --             background-color: #4CAF50;
            --         }
                    
            --         #cadastra{
            --             color: black;
            --         }

            --     |]
            --     [whamlet|
            --         <ul>
            --             <li> <a href=@{HomeR}>Home
            --             <li style="float:right"> <a href=@{LoginR}>Login </a>
            --             <li style="float:right"> eae visitante </ul>
                
            --          <table>
            --              <tr>
            --                  <th> Pratos
                             
            --              $forall Entity pid prod <- card
            --                  <tr input type="checkbox">
            --                      <td> #{produtoNome prod}
            --                      <td> R$ #{produtoValor prod}
                                 
            --          <table>
            --              <tr>
            --                  <th> Bebidas
                             
            --              $forall Entity pid prod <- beb
            --                  <tr input type="checkbox">
            --                      <td> #{produtoNome prod}
            --                      <td> R$ #{produtoValor prod}
                                 
            --          <h3> <a id="cadastra" href=@{ClienteR}> Cadastre-se </a> para fazer o seu pedido
            --     |]
                
            --     toWidget [julius|
            --         var table = document.getElementsByTagName("table")[0];
            --         var tbody = table.getElementsByTagName("tbody")[0];
            --         tbody.onclick = function (e) {
            --             e = e || window.event;
            --             var foi = [];
            --             var target = e.srcElement || e.target;
            --             while (target && target.nodeName !== "TR") {
            --                 target = target.parentNode;
            --             }
            --             if (target) {
            --                 var cells = target.getElementsByTagName("td");
            --                 for (var i = 0; i < cells.length; i++) {
            --                     foi.push(cells[i].innerHTML);
            --                 }
            --             }
                        
            --             alert(foi);
            --         };
            --     |]
            defaultLayout $ do
                [whamlet|
                    nem
                |]
      
getCardapioR :: Handler Html
getCardapioR = do
    maybeid <- lookupSession "_ID"
    maybenome <- lookupSession "_NOME"
    
    case maybenome of
        Nothing -> (getItensVisitante)
        (Just nome) -> (getItens nome)

postCardapioR :: Handler Html
postCardapioR = undefined
-- postCardapioR = do
--             ((result, _), _) <- runFormPost formPedido
--             case result of
--                 FormSuccess (pid, _) -> do
--                     x <- fmap (\w -> read w::(Int,Double)) (words pid)
--                     pedido <- runDB $ insert $ Pedido 
--                   cara <- runDB $ selectFirst [ClienteLogin ==. login,
--                                                 ClientePword ==. pword] []
--                   case cara of
--                       Just (Entity pid cliente) -> do
--                           setSession "_ID" (pack $ show $ fromSqlKey pid)
--                           setSession "_NOME" (pack $ show $ clienteNome cliente)
--                         --   defaultLayout [whamlet|
--                         --         Bem-vindo #{clienteLogin cliente}
--                         --   |]
--                           redirect HomeR
--                       Nothing -> redirect LoginR
--                 _ -> redirect CardapioR