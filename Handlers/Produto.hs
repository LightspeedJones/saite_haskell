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
                
                --vatdadasddasdasdasddasddasddasdddasddasd
                -- pedidoId <- insert $ Pedido 10 $ 18.00
                
coisoCoiso :: ClienteId -> Handler Html
coisoCoiso coisa = do
            (widget, enctype) <- generateFormPost formPedido
            -- now <- liftIO getCurrentTime
            pid <- runDB $ insert $ coisa Pedido 0 19 False
            defaultLayout [whamlet|
                foi
            |]
                
getItensVisitante :: Handler Html
getItensVisitante = do
            defaultLayout $ do
                redirect LoginR
      
getCardapioR :: Handler Html
getCardapioR = do
    maybeid <- lookupSession "_ID"
    maybenome <- lookupSession "_NOME"
    
    case maybenome of
        Nothing -> (getItensVisitante)
        (Just nome) -> (getItens nome)

postCardapioR :: Handler Html
postCardapioR = do
    prodName <- "pastel"
    prodVl <- 20
    prodTipo <- 1
    produtoid <- runDB $ insert $ Produto prodName prodVl prodTipo
    redirect HomeR


-- postCardapioR :: Text -> Handler
-- postCardapioR prod = do
--     runDB $ insert $ Produto prod 3 1
    -- clienteid <- lookupSession "_ID"
    -- --vltot 
    -- item <- runDB $ selectFirst [ProdutoId ==. prodid] []
    -- runDB $ insert $ Pedido clienteid 30 19:48 0 
    

-- postCardapioR :: ProdutoId
-- postCardapioR prodid = do
--     item <- runDB $ selectField [ProdutoId ==. prodid] []
--     runDB $ insert item

-- postCardapioR :: ProdutoId
-- postCardapioR prodid = do
--     runDB $ insert prodid



-- main :: IO ()
-- main = runResourceT $ withSqliteConn ":memory:" $ runSqlConn $ do
--     runMigration migrateAll

--     ids <- forM input insert
--     liftIO $ print ids

--   where
--     input = [Person "John Doe", Person "Jane Doe"]


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