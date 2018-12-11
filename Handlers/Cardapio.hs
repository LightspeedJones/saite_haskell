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
            card <- runDB $ selectList [ProdutoTipoprodutoid ==. "1"] [Asc ProdutoNome]
            beb <- runDB $ selectList [ProdutoTipoprodutoid ==. "2"] [Asc ProdutoNome]
            defaultLayout $ do
                toWidget $(juliusFile "templates/cardapio.julius")
                toWidget $(luciusFile "templates/cardapio.lucius")
                $(whamletFile "templates/cardapio.hamlet")

postCardapioR :: ProdutoId -> Handler Html
postCardapioR pid = do
    (Just usrid) <- lookupSession "_ID"
    --postCoisa usrid "Pastel"
    runDB $ insert $ Pedido usrid 0 19 False
    prod <- runDB $ selectFirst [ProdutoId ==. pid] []
    case prod of
        Just (Entity prod produto) -> do
            runDB $ insert $ ItemPedido "1" prod 20
    redirect HomeR
                
getItensVisitante :: Handler Html
getItensVisitante = do
            defaultLayout $ do
                redirect LoginR
      
getMenuR :: Handler Html
getMenuR = do
    maybenome <- lookupSession "_NOME"
    
    case maybenome of
        Nothing -> (getItensVisitante)
        (Just nome) -> (getItens nome)
        Just "admin" -> (getItens "admin")