{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}
{-# LANGUAGE QuasiQuotes       #-}

module Application where

import Foundation
import Yesod

-- AQUI MORAM OS HANDLERS
-- import Add
-- PARA CADA NOVO GRUPO DE HANDLERS, CRIAR UM AQUIVO
-- DE HANDLER NOVO E IMPORTAR AQUI
import Curso
import Professor
------------------
mkYesodDispatch "App" resourcesApp

getHomeR :: Handler Html
getHomeR = defaultLayout $ do

    toWidget[lucius|
        h1{
            color:red;
            
        }
        ul li{
           display:inline; 
        }
    |]
    [whamlet|
         <h1> Sistema academico
         <ul>
            <li> <a href=@{ProfR}> prof
            <li> <a href=@{CursoR}> curso
            <li> <a href=@{ListProfR}> lista prof
            <li> <a href=@{ListCursoR}> lista curso
    |]