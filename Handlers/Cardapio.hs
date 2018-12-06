{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Handlers.Cardapio where

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
                
                --adaddadsdadssadsdadsdddaddaasddadasadaddadadsdsadasddaddasaddadsdadadaddadads
                -- pedidoId <- insert $ Pedido 10 $ 18.00
                
                
-- postCoisa :: Text -> Text -> Handler Html
-- postCoisa coisa treco = do
--                     -- ((result, _), _) <- runFormPost formPedido
--                     runDB $ insert $ Pedido coisa 0 19 False
--                     prod <- runDB $ selectFirst [ProdutoNome ==. treco] []
--                     case prod of
--                         Just (Entity prod produto) -> do
--                             runDB $ insert $ ItemPedido "1" prod 20
                            
--                     redirect HomeR

postCardapioR :: Handler Html
postCardapioR = do
    (Just usrid) <- lookupSession "_ID"
    --postCoisa usrid "Pastel"
    runDB $ insert $ Pedido usrid 0 19 False
    prod <- runDB $ selectFirst [ProdutoNome ==. "coiso"] []
    case prod of
        Just (Entity prod produto) -> do
            runDB $ insert $ ItemPedido "1" prod 20
    redirect CardapioR
                
getItensVisitante :: Handler Html
getItensVisitante = do
            defaultLayout $ do
                redirect LoginR
      
getCardapioR :: Handler Html
getCardapioR = do
    maybenome <- lookupSession "_NOME"
    
    case maybenome of
        Nothing -> (getItensVisitante)
        (Just nome) -> (getItens nome)