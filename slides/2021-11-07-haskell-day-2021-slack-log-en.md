---
title: Introduction to Slack-log
author: YAMAMOTO Yuji (山本悠滋)
date:  2021-11-07 Haskell Day 2021

---

# Nice to meet you! 👋😄

- [YAMAMOTO Yuji](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Haskell fan for about 9 yrs
- Writing TypeScript @ [IIJ-II](https://www.iij-ii.co.jp/)
- No relation with igrep.el, an Emacs plugin

# 📝Topics

- Introduce "[slack-log](https://github.com/haskell-jp/slack-log/)", a CLI app written in Haskell by Haskell-jp
    - Background of the project,
    - Features,
    - Implementation, etc.
        - Nothing new to experienced Haskellers. Sorry!
- For newbies: this would be an good example CLI app in Haskell

# 🤖What's slack-log?

A command line app which automatically makes [this](https://haskell.jp/slack-log/)👇:

- <img src="/imgs/2021-11-07-haskell-day-2021-slack-log/slack-log-index.png" />

# 🤖What's slack-log? (cont.)

- Saves the posted messages in a Slack Workspace with the Web API
- Convert saved JSON files into HTMLs with user-configured templates
- Currently only used for saving the messages in [Haskell-jp's Slack Workspace](https://haskell.jp/signin-slack.html) incrementally
    - The generated HTMLs are available at <https://haskell.jp/slack-log/>

# Why?

- 🔥By the free version of Slack, older messages get inaccessible if the total number of the messages in a Workspace is greater than 10,000
- 💸No free and open online community can afford the premium version
    - Yes, I know we shouldn't use Slack in such a case, but...
- 🗃Anyway, we want to save and publish the exchanged messages because they are beneficial!

# 😤Pros of slack-log

Compared to [Slack Archive](https://github.com/dutchcoders/slackarchive), whose goal is same:

- No always-running server required to save
    - Slack Archive has to join in the Workspace as a bot, which must respond as a server
- Good for publishing the gnerated HTMLs on GitHub Pages
- Still developing💪
    - The last commit to Slack Archive is 3 years ago!

# 😕Cons of slack-log

- Collect messages only within the rate limit of Slack's Web API
    - Workspaces with few messages (like Haskell-jp) wouldn't have the problem, but Workspaces with very frequent messages might exceed the limit
- Not so complete:
    - Saves only extremely limited fields of the JSONs returned by Slack's Web API
        - No emoji reactions
    - No documents

# ✍️Usage

- ⚠️Create config files in advance!
- `slack-log save`:
    - ⏬Save messages as JSONs in the configured channels and then generate HTMLs
- `slack-log generate-html`:
    - 🎨Regnerate HTMLs from the configured templates

# 🗼Implementation Overview

Look into the [cabal file](https://github.com/haskell-jp/slack-log/blob/3280a8dd6accf9ff8c1104e55f9662cb8f774a26/slack-log.cabal)!

- (As an ordinary Haskell application) Consist of a library, an executable, and a test suite
- The `app` directory contains [`slack-log` command's source code, and there is `Main.hs`, which contains the `main` function](https://github.com/haskell-jp/slack-log/blob/3280a8dd6accf9ff8c1104e55f9662cb8f774a26/slack-log.cabal#L71-L77)
    - Let's read `Main.hs` from the beginning by the first line of Slack Web API calls

# ⚙️Implementation Details: Main.hs

First of all, open [`app/Main.hs`](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs):

```haskell
import UI.Butcher.Monadic ({- ... snip ... -})

main :: IO ()
main = do
  -- ... snip ...
  mainFromCmdParserWithHelpDesc $ \helpDesc -> do
    addHelpCommand helpDesc
    addCmd "save" $ addCmdImpl saveCmd
    addCmd "generate-html" $ do
      -- ... snip ...
      addCmdImpl $ generateHtmlCmd onlyIndex
    addCmd "paginate-json" $ addCmdImpl paginateJsonCmd
```

# ⚙️Implementation Details: Main.hs (cont.)

- Parse command line arguments with [butcher](https://hackage.haskell.org/package/butcher)
    - Detect and parse command line options and subcommands
    - Switch available options by subcommand
    - Build a help message

# ⚙️Implementation Details: `slack-log save`

Add the subcommand `save` here

```haskell
addCmd "save" $ addCmdImpl saveCmd
```

- 💁‍♂Makes the `slack-log save` command available
- `saveCmd` is the actually executed `IO` action

# ⚙️`saveCmd` Function (Overview)

Divided into 3 parts:

1. [Load config files](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs#L107-L111)
1. [Save messages](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs#L112-L124)
    - It calls Slack's Web API here!
1. [Convert JSONs into HTMLs](https://github.com/haskell-jp/slack-log/blob/9b95e155571e015409cbc1aa22f4f08e7e3afaf0/app/Main.hs#L126-L136)

# ⚙️ `saveCmd` Function (Load Config 1)

```haskell
saveCmd = do
  config <- Yaml.decodeFileThrow "slack-log.yaml"
  -- ... --
```

- By the [yaml](https://hackage.haskell.org/package/yaml) package, get most of the settings from slack-log.yaml

# ⚙️ `saveCmd` Function (Load Config 2)

```haskell
saveCmd = do
  -- ... --
  apiConfig <- Slack.mkSlackConfig . slackApiToken =<< failWhenLeft =<< decodeEnv
  -- ... --
```

- Get secret of Slack's Web API from the environment variable
- Using the [envy](https://hackage.haskell.org/package/envy) package
    - Provides an easy way to combine several environment variables to build any value you want

# ⚙️ `saveCmd` Function (Load Config 3)

```haskell
ws <- loadWorkspaceInfo config "json"
```

- Pick up settings related to generating HTMLs from slack-log.yaml
- Then compile HTML template files
    - Using [mustache](https://hackage.haskell.org/package/mustache) as the template engine

# ⚙️ `saveCmd` Function (Save Users List)

```haskell
(`runReaderT` apiConfig) $ do
  saveUsersList
  -- ... Other functions dependent on apiConfig ...
```

- Get and save all users' information in the Workspace by calling Slack's Web API in the `saveUsersList` function
    - Necessary to write users' screennames on HTMLs because messages returned by Slack's Web API include only user IDs instead of the users' screennames
- Let's dig into `saveUsersList` to see how slack-log calls Slack's Web API

# ⚙️ `saveUsersList` Function

```haskell
saveUsersList :: ReaderT Slack.SlackConfig IO ()
saveUsersList = do
  result <- Slack.usersList
  -- ... Save users list extracted from the `result` ...
```

- `Slack.usersList` is the function imported from the slack-web package
    - Directly calls Slack's Web API
    - Actually named `usersList` though it's referred to as `Slack.usersList` by Haskell's `qualified` import feature

# 📝`ReaderT`・`runReaderT` (1)

The point here is:

- `ReaderT` automatically passes the argument given by `runReaderT` to all functions listed in the `do` expressions

# 📝`ReaderT`・`runReaderT` (2)

Expressions using `ReaderT` I referred before are typed as following:

```haskell
runReaderT    :: ReaderT r IO a
                   -> r -> IO a
usersList     :: ReaderT r IO (Response ListRsp)
saveUsersList :: ReaderT r IO ()
```

- `runReaderT` receives `r` <small>(in slack-log, instantiated as `SlackConfig`)</small>, then transforms a Monad called <small>(somewhat longer named)</small> "`ReaderT r IO`" into just `IO`

# 📝`ReaderT`・`runReaderT` (3)

Expressions using `ReaderT` I referred before are typed as following:

```haskell
runReaderT    :: ReaderT r IO a
                   -> r -> IO a
usersList     :: ReaderT r IO (Response ListRsp)
saveUsersList :: ReaderT r IO ()
```

- Like `usersList`, all functions to call Slack's Web API are typed as a "`ReaderT r IO`" Monad function
    - `saveUsersList` is also typed as a "`ReaderT r IO`" function too
    - ℹ️Rough rule: To call a `Monad` function, the caller needs to be the same type of `Monad` function too

# 📝What's `ReaderT`?

- A kind of Monad Transformers
    - Provides a way to use several `Monad`s' features in a single `do` syntax by creating a composed `Monad`
        - Ref. (Japanese) [Maybe と IO を一緒に使いたくなったら - ryota-ka's blog](https://ryota-ka.hatenablog.com/entry/2018/05/26/193220)
        - E.g. In the `do` syntax of "`ReaderT r IO`", both "`Reader r`" and `IO` are available
- 💁‍♂Tips: To understand a Monad, learn the usage of every concrete Monad
    - By learning each Monad's feature, you'll get how to use composed Monad Transformers
    - `IO` would be popular enough. How about "`Reader r`"?

# 📝Then, what's `Reader`?

"`Reader r a`" is just an equivalent (`newtype`-ed) type of "`r -> a`":

- ➡️Makes ordinary functions available in `do` as a Monad!
- How does "`Reader r`" make functions a Monad?
    - 💁‍♂Tips: To understand an instance of Monad, get what happens/can be done when using it in `do`

# 📝Define a function WITHOUT `Reader`'s `do`

Example: A function defined NOT using `do` of "Reader r":

```haskell
someFunc :: Arg -> [Result]
someFunc arg =
  let r1 = f1 arg
      r2 = f2 arg
      r3 = f3 arg
   in r1 ++ r2 ++ r3

-- To use it, just apply to an argument👇
someFunc arg
```

# 📝Define a function WITH `Reader`'s `do`

Example: Define a function equivalent to the last slide's using `do` of "Reader r":

```haskell
someFunc :: Reader Arg [Result]
someFunc = do
  r1 <- f1
  r2 <- f2
  r3 <- f3
  return $ r1 ++ r2 ++ r3

-- To use it, apply runReader to it with an argument👇
runReader someFunc arg
```

- 🔆Now, we have to pass `arg` **only once** to use `runReader`!

# 📝What `Reader` does in `do`

- Just pass the argument given by `runReader` to every function listed in the `do`
    - Only the matter of style: we can achieve the same goal without `Reader` by manually passing `arg`s
    - But the merit in "style" `Reader` provides is sometimes important: e.g. Creating a embedded DSL

# 👀Revisit the `usersList` function

```haskell
usersList :: ReaderT SlackConfig IO (Response ListRsp)
```

👆 is virtually same with 👇

```haskell
usersList :: SlackConfig -> IO (Response ListRsp)
```

# 🤔Why does slack-web use `ReaderT`?

- We don't have to pass `SlackConfig` to every function calling Slack's Web API such as `usersList`
    - Similar to React's Context feature
    - slack-log calls Slack's Web API at various lines, so I decided to use `ReaderT SlackConfig IO` where possible
- `ReaderT` is used for the "`ReaderT` Pattern", the most popular use case of Monad Transformers
    - The API-calling functions in slack-web (including `usersList`) are typed to use with the "`ReaderT` Pattern"
        - I have no slides to explain the "`ReaderT` Pattern". Sorry!

# 😕IMO: Should slack-web really use `ReaderT`?

- It's easy enough to convert between "`ReaderT SlackConfig IO a`" and "`SlackConfig -> IO a`"
- Libraries not directly related to the "`ReaderT` Pattern" should NOT force users to use `ReaderT` so that newbies don't get confused
- Actual type of `usersList`:

  ```haskell
  usersList :: (MonadReader env m, HasManager env, HasToken env, MonadIO m)
    => m (Response ListRsp)
  ```
- Its simplified version:

  ```haskell
  usersList :: SlackConfig -> IO (Response ListRsp)
  ```

# ⚙️Saving users list with `ReaderT` (Recap 1)

Lines to save users list (repeated):

```haskell
(`runReaderT` apiConfig) $ do
  saveUsersList
  -- ... Other functions dependent on apiConfig ...
```

```haskell
saveUsersList :: ReaderT Slack.SlackConfig IO ()
saveUsersList = do
  result <- Slack.usersList
  -- ... Save users list extracted from the `result` ...
```

# ⚙️Saving users list with `ReaderT` (Recap 2)

With `runReaderT` and `ReaderT`,

```haskell
do
  saveUsersList apiConfig
  -- ... Other functions dependent on apiConfig ...
```

becomes:

```haskell
(`runReaderT` apiConfig) $ do
  saveUsersList
  -- ... Other functions dependent on apiConfig ...
```

# ⚙️Saving users list with `ReaderT` (Recap 3)

With `runReaderT` and `ReaderT`,

```haskell
saveUsersList :: Slack.SlackConfig -> IO ()
saveUsersList apiConfig = do
  result <- Slack.usersList apiConfig
  -- ... Save users list extracted from the `result` ...
```

becomes:

```haskell
saveUsersList :: ReaderT Slack.SlackConfig IO ()
saveUsersList = do
  result <- Slack.usersList
  -- ... Save users list extracted from the `result` ...
```

# Future Steps

- Release as an application
    - Make a separate repository for the application code:
        - Currently only one repository contains saved messages and code of the app
    - Then upload the executable on GitHub Releases
- If I refactor:
    - Use the `rio` package?
        - Adopt the "`ReaderT` Pattern" more easily!
    - Use the `path` package?
        - Distinguish relative paths between absolute paths, and paths to directories between paths to  files at type level

# Conclusion

- slack-log is an application to save messages in your Slack workspace
    - Can generate HTMLs to see the messages on GitHub Pages etc.
- Thanks to the `butcher` package, it easily parses command line arguments
- To use Slack's Web API with the `slack-web` package, learn how to use the `ReaderT` Monad Transformer!
    - But you can call them just by writing the idiom ``(`runReaderT` apiConfig) someApiFunc`` without understanding `ReaderT`
- 👍Contribution Welcome!
    - <https://github.com/haskell-jp/slack-log/>
