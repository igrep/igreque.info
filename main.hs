{-
Copyright 2019 Yuji Yamamoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-}

{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Monoid ((<>))
import Control.Applicative ((<$>))

import Network.URL (encString)

import Data.Binary (Binary)
import Data.Typeable (Typeable)

import Debug.Trace
import Hakyll

-- general function for debugging
inspect :: Show a => String -> a -> a
inspect msg x = trace ( msg ++ ": " ++ show x ) x
--

inspectTags :: Show a => a -> a
inspectTags = inspect "tags"

main :: IO ()
main = hakyll $ do
  tags <- buildTags postsPattern (fromCapture "tags/*.html")

  cssRules
  -- ^ Compressed CSS
  idRules "fonts/**"
  -- ^ Fonts
  idRules "imgs/**"
  -- ^ Images
  postRulesOf postsPattern tags
  -- ^ Render posts
  postRulesOf hiddenPostsPattern tags
  -- ^ Render WIP posts
  postsListRules
  -- ^ Render posts list
  indexRules tags
  -- ^ Index
  taggedPostsRules tags
  -- ^ Display posts tagged as a praticular tag
  atomRules
  -- ^ Atom feed
  templateRules
  -- ^ Template
  slideRules
  slidesListRules
  idRules "slides/styles/*.css"
  idRules "slides/scripts/*.js"
  -- ^ For slides written in HTML
  idRules "other/**"

  idRules "_redirects"

idRules :: Pattern -> Rules ()
idRules pat =
  match pat $ do
    route idRoute
    compile copyFileCompiler

templateRules :: Rules ()
templateRules = match "templates/**.html" $ compile templateCompiler

cssRules :: Rules ()
cssRules =
  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

postRulesOf :: Pattern -> Tags -> Rules ()
postRulesOf ptn tags =
  match ptn $ do
    route   $ setExtension ".html"
    compile $ do
      let loadWithTags = loadTemplateIn (postContext tags)
      pandocCompiler
        >>= loadWithTags "templates/post.html"
        >>= saveSnapshot "content"
        >>= loadWithTags "templates/default.html"
        >>= relativizeUrls

postsListRules :: Rules ()
postsListRules =
  create ["posts.html"] $ do
    route idRoute
    compile $ do
      posts <- allPostsByRecentFirst
      itemTemplate <- loadBody "templates/postitem.html"
      list <- applyTemplateList itemTemplate datedContext posts
      makeItem list
        >>= loadWithAllPosts "templates/posts.html"
        >>= loadWithAllPosts "templates/default.html"
        >>= relativizeUrls
 where
  loadWithAllPosts = loadTemplateIn allPostsContext
  allPostsContext = constField "title" "All posts" <> datedContext

slideRules :: Rules ()
slideRules = match slidesPattern $ do
  route   $ setExtension ".html"
  compile $
    getResourceString >>=
      -- FIXME: use pandocCompilerWith
      withItemBody (unixFilter "pandoc" ["-t", "slidy", "-i", "-s", "-V", "slidy-url=."])

slidesListRules :: Rules ()
slidesListRules = create ["slides/index.html"] $ do
  route idRoute
  compile $ do
    slides <- recentFirst =<< loadAll slidesPattern
    itemTemplate <- loadBody "templates/postitem.html"
    list <- applyTemplateList itemTemplate datedContext slides
    makeItem list
      >>= loadAndApplyTemplate "templates/slides/index.html" defaultContext
      >>= loadDefaultTemplateAs "Slides"
      >>= relativizeUrls

indexRules :: Tags -> Rules ()
indexRules tags =
  create ["index.html"] $ do
    route idRoute
    compile $ do
      posts <- indexPostsByRecentFirst
      itemTemplate <- loadBody "templates/postitem.html"
      list <- applyTemplateList itemTemplate datedContext posts
      makeItem list
        >>= loadAndApplyTemplate "templates/index.html" (indexContext tags)
        >>= loadDefaultTemplateAs "Index"
        >>= relativizeUrls
      where
        indexContext t =
          field "tagcloud" (\_ -> renderTagCloud 90 120 t)
          <> defaultContext

taggedPostsRules :: Tags -> Rules ()
taggedPostsRules tags =
  tagsRules tags $ \tag ptn -> do
    route idRoute
    let title = "Posts tagged " ++ tag
    compile $ do
      list <- postList tags ptn recentFirst
      makeItem ""
        >>= loadAndApplyTemplate "templates/posts.html"
            ( constField "title" title
              <> constField "body" list
              <> defaultContext )
        >>= loadDefaultTemplateAs title
        >>= relativizeUrls

atomRules :: Rules ()
atomRules =
  create ["atom.xml"] $ do
    route idRoute
    compile $ do
      posts <- take 10 <$> (recentFirst =<< loadAllSnapshots postsPattern "content")
      renderAtom feedConfig feedContext posts
 where
  feedContext = bodyField "description" <> datedContext
  feedConfig = FeedConfiguration
    { feedTitle       = "igreque : Info -> RSS"
    , feedDescription = "RSS feed of igreque : Info, generated by Hakyll."
    , feedAuthorName  = "Yuji Yamamoto"
    , feedAuthorEmail = "whosekiteneverfly@gmail.com"
    , feedRoot        = "http://the.igreque.info"
    }

taggedContext :: Tags -> Context String
taggedContext tags = tagsField "prettytags" tags <> datedContext

loadTemplateIn :: Context a -> Identifier -> Item a -> Compiler (Item String)
loadTemplateIn = flip loadAndApplyTemplate

loadDefaultTemplateAs :: String -> Item String -> Compiler (Item String)
loadDefaultTemplateAs title =
  loadAndApplyTemplate "templates/default.html" (constField "title" title <> defaultContext)

datedContext :: Context String
datedContext = dateField "date" "%B %e, %Y" <> defaultContext

postContext :: Tags -> Context String
postContext tags = taggedContext tags <> field "encodedTitle" getEncodedTitle
  where getEncodedTitle item = encodeUrlComponent <$> getMetadataField' (itemIdentifier item) "title"

allPostsByRecentFirst :: (Binary a, Typeable a) => Compiler [Item a]
allPostsByRecentFirst = recentFirst =<< loadAll postsPattern

indexPostsByRecentFirst :: (Binary a, Typeable a) => Compiler [Item a]
indexPostsByRecentFirst = take 10 <$> allPostsByRecentFirst

postsPattern :: Pattern
postsPattern = "posts/**"

slidesPattern :: Pattern
slidesPattern = "slides/*.md"

hiddenPostsPattern :: Pattern
hiddenPostsPattern = "wip/**"

encodeUrlComponent :: String -> String
encodeUrlComponent = encString True (`elem` safeCharacters)
  where safeCharacters = ['A'..'Z'] ++ ['a'..'z'] ++ "-_.,"

-- any better concrete name?
postList ::
  Tags -> Pattern -> ([Item String] -> Compiler [Item String])
    -> Compiler String
postList tags ptn preprocessor = do
  postItemTemplate <- loadBody "templates/postitem.html"
  posts <- preprocessor =<< loadAll ptn
  applyTemplateList postItemTemplate (taggedContext tags) posts
