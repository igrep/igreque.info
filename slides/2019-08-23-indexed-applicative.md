---
title: Simulate Bind with IxApplicative
author: Yuji Yamamoto (山本悠滋)
date: 2019-08-23 HIW 2019

---

# Nice to meet you! (\^-\^)

- [Yuji Yamamoto](https://twitter.com/igrep) ([\@igrep](https://twitter.com/igrep))
- Software Developer at [IIJ Innovation Institute, Inc.](https://www.iij-ii.co.jp/) 😄
- One of the founders of [Japan Haskell User Group (a.k.a. Haskell-jp)](https://haskell.jp/)

# Topics and Summary

- What `Monad` can do but `Applicative` cannot, and vice versa.
- Simulate bind `(>>=)` with `IxState` and keep your EDSL Monad-free.
    - Represent reference to (the result of) an action by [`Symbol`](http://hackage.haskell.org/package/base-4.12.0.0/docs/GHC-TypeLits.html#t:Symbol).
    - Interpret the actions as `IxState` with an extensible record when executing.
- Example: Tiny EDSL with a monadic interpreter and a static analyzer.

# What `Monad` Can Do But `Applicative` Cannot

- Bind `>>=`
- ![Applicative can't bind!](/imgs/2019-08-23-no-bind.png)

# What `Applicative` Can Do But `Monad` Cannot

Several things. Today I focus on:

- Traverse all execution paths!

# What `Applicative` Can Do But `Monad` Cannot

Why?

```haskell
do
  x <- fa
  -- ... x can be used anywhere!
```

# What `Applicative` Can Do But `Monad` Cannot

Why?

```haskell
do
  x <- fa
  -- `x` can be used to decide whether `fb` or `fc` is executed.
  -- But your EDSL interpreter (e.g. Free Monad) doesn't know
  -- *both* `fb` and `fc` can be executed.
  y <- if x >= 0 then fb else fc
```

# What `Applicative` Can Do But `Monad` Cannot

Why?

```haskell
do
  x <- fa
  -- Actions following `fa` can be decided dynamically by `x`.
  -- So your EDSL interpreter (e.g. Free Monad) has
  -- completely no idea of what's executed next.
  -- nextActionsTable :: [(x, m ())]
  case lookup x nextActionsTable of
      Just nextAction -> nextAction
      Nothing -> defaultAction
```

# What `Applicative` Can Do But `Monad` Cannot

Why?

- `Monad` can choose which execution paths to go by the results of the actions, thanks to `>>=`.
- In other words, `Monad` can't grasp **all possibly-executed actions**.
    - But `Applicative` can do that!

# What `Applicative` Can Do But `Monad` Cannot

Traversing all paths is useful for...

- [optparse-applicative](http://hackage.haskell.org/package/optparse-applicative):
    - Generate `--help` of the *all* available options by traversing them.
- [regex-applicative](http://hackage.haskell.org/package/regex-applicative) (Regex as an EDSL in Haskell):
    - Compile *all* operations of a regular expression into an NFA by traversing them.

# Goal🏁

I want to add some bind-like feature to those `Applicative`s anyway!

# Simulate `(>>=)` with IxApplicative and Extensible Record

Required Types etc:

- [`IxApplicative`](https://hackage.haskell.org/package/indexed-0.1.3/docs/Control-Monad-Indexed.html#t:IxApplicative)
- [`IxStateT`](https://hackage.haskell.org/package/indexed-extras-0.2/docs/Control-Monad-Indexed-State.html#t:IxStateT) if you write a monadic interpreter for the EDSL.
- Some extensible record library.
    - Here I use [extensible](https://hackage.haskell.org/package/extensible) package.
- `RebindableSyntax` if you make the EDSL available with `do` syntax.

# Simulate `(>>=)` with IxApplicative and Extensible Record

Example: Not very useful expression language.

```haskell
data Exp a where
  Hask :: a -> Exp a
  -- ^ Literal value.
  Succ :: Exp Int -> Exp Int
  -- ^ `succ` function.
  (:<) :: Exp Int -> Exp Int -> Exp Bool
  -- ^ Comparison operator.
```

<small><a href="https://gitlab.com/igrep/bind-in-indexed-applicative">Executable project is here.</a></small>

# Simulate `(>>=)` with IxApplicative and Extensible Record

Add value constructors for `Applicative` instance.

```haskell
data Exp a where
  -- ...
  Fmap :: (a -> b) -> Exp a -> Exp b
  -- ^ For `fmap`
  Ap   :: Exp (a -> b) -> Exp a -> Exp b
  -- ^ For `<*>`
  Then :: Exp a -> Exp b -> Exp b
  -- ^ For `*>`
```

# Simulate `(>>=)` with IxApplicative and Extensible Record

Add extensible records as type arguments:

```haskell
data Exp (xs :: [Assoc Symbol Type]) (ys :: [Assoc Symbol Type]) a where
  Hask :: a -> Exp xs xs a
  Succ :: Exp xs xs Int -> Exp xs xs Int
  (:<) :: Exp xs xs Int -> Exp xs xs Int -> Exp xs xs Bool

  Fmap :: (a -> b) -> Exp xs ys a -> Exp xs ys b
  Ap   :: Exp xs ys (a -> b) -> Exp ys zs a -> Exp xs zs b
  Then :: Exp xs ys a -> Exp ys zs b -> Exp xs zs b
```

# Simulate `(>>=)` with IxApplicative and Extensible Record

Add extensible records as type arguments:

- Now, `Exp` is an [`IxApplicative`](https://hackage.haskell.org/package/indexed-0.1.3/docs/Data-Functor-Indexed.html#t:IxApplicative)
- Then the value constructors below stand for operators of `IxApplicative` and `IxFunctor`.

```haskell
Fmap :: (a -> b) -> Exp xs ys a -> Exp xs ys b
Ap   :: Exp xs ys (a -> b) -> Exp ys zs a -> Exp xs zs b
Then :: Exp xs ys a -> Exp ys zs b -> Exp xs zs b
```

# Simulate `(>>=)` with IxApplicative and Extensible Record

Add operators to update associated extensible records:

```haskell
data Exp (xs :: [Assoc Symbol Type]) (ys :: [Assoc Symbol Type]) a where
  -- ...
  Let  :: KnownSymbol k =>
    FieldName k -> Exp xs xs a -> Exp xs (k >: a ': xs) ()
  -- ^ Introduce a new variable.
  Ref  :: (Lookup xs k v, KnownSymbol k) =>
    FieldName k -> Exp xs xs v
  -- ^ Read an already introduced variable.
  (:=) :: (Lookup xs k v, KnownSymbol k) =>
    FieldName k -> Exp xs xs v -> Exp xs xs ()
  -- ^ Update an already introduced variable.
```

# Simulate `(>>=)` with IxApplicative and Extensible Record

Add more operators to refer the bound variables.

```haskell
data Exp (xs :: [Assoc Symbol Type]) (ys :: [Assoc Symbol Type]) a where
  -- ...
  If    :: Exp xs xs Bool -> Exp xs ys a -> Exp xs ys a -> Exp xs ys a
  While :: Exp xs xs Bool -> Exp xs xs () -> Exp xs xs ()
```

# Stay Monad-free 🚳!

Now I turned a tiny expression EDSL into an imperative EDSL which can update variables.

- Add type arguments of extensible records to represent *the namespace*.
    - Invalid variable references are statically detected thanks to extensible records.
- Add operators to define/read/update variables.
- Add operators to use the actual value of variables.
    - Actually we have to define operators for each one that requires to use the actual value of variables.

# Stay Monad-free 🚳!

- Even with the feature, the expressions can be composed **only with Applicative APIs**.
- No bind `>>=` operator!

# Example Expression in the EDSL

```haskell
    Let #var (Hask 0)
*>> Let #var2 (Hask (1 :: Int))
*>> While (Ref #var :< Hask 10)
      (   (#var := Succ (Ref #var))
      *>> If (Ref #var :< Hask (5 :: Int))
            (#var2 := Succ (Ref #var2))
            (ireturn ())
      )
```

# Example Expression in the EDSL

Bonus: using `RebindableSyntax`

```haskell
Let #var 0
Let #var2 1
While (Ref #var :< 10) $ do
  #var := Succ (Ref #var)
  If (Ref #var :< 5)
    (#var2 := Succ (Ref #var2))
    (ireturn ())
```

# Example Evaluator 1 (Excerpt)

```haskell
run :: Exp '[] ys a -> (a, Record ys)
run = (`runIxState` nil) . toIxState
 where
  -- ...
  toIxState (Let k mx) = toIxState mx >>>= \x -> imodify (k @== x <:)
  toIxState (Ref k) = igets (^. itemAssoc (fieldNameToProxy k))
  toIxState (k := mx) =
    toIxState mx >>>= imodify . set (itemAssoc (fieldNameToProxy k))
  toIxState (If cond t f) =
    toIxState cond >>>= bool (toIxState f) (toIxState t)
  -- ...
```

# Example Evaluator 2 (Excerpt)

Count how many times every variable is referred.

```haskell
collectStats :: Exp xs ys a -> Map.Map String Int
-- ...
collectStats (Let _ mx) = collectStats mx
collectStats (Ref k) = one k
collectStats (k := mx) = one k `merge` collectStats mx
collectStats (If cond t f) =
  collectStats cond `merge` collectStats t `merge` collectStats f
-- ...
merge = Map.unionWith (+)
one k = Map.singleton (symbolVal $ fieldNameToProxy k) 1
```

# Running the Examples

Demonstrate here!

# More Useful Examples

<small>I failed to implement in time...😞</small>

- Back reference for regex-applicative.
- EDSL with pretty-printer and interpreter.
    - Requires restricted indexed Applicative instead of the standard indexed Applicative. Because not arbitrary Haskell functions can be printed.
- All of these can be implemented by traversing all execution path of the EDSL!

# ✅Summary

- With `IxApplicative`, we can add a bind-like feature to our DSLs.
- Even with the bind-like feature, the EDSL still have **execution path entirely traversable**.
