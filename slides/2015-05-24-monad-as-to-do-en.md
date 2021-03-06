---
title: Monad as "Things to Do"
author: Yuji Yamamoto
date: 2015-05-24

---

This slide was planned to be used for the Lightning Talk of LambdaConf 2015.  
But I missed the chance.😞

# Nice to meet you!

- [Yuji Yamamoto](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) age 26.
    - Remember this avator:
    - ![](/imgs/avator-twitter.png)

# Nice to meet you!

- [Yuji Yamamoto](https://plus.google.com/u/0/+YujiYamamoto_igrep/about)([\@igrep](https://twitter.com/igrep)) age 26.
- Japanese Ruby engineer working at [Sansan, Inc.](http://www.corp-sansan.com/)
- Hobby Haskeller.
- Holding [workshop of Haskell (Japanese)](http://connpass.com/series/754/) per month.

# I'm gonna talk about...

- Describe Monad **in Haskell** from a my point of view.
    - This↓
    ```haskell
    class Monad m where
      return :: a -> m a
      (>>=) :: m a -> (a -> m b) -> m b
      -- snip. --
    ```
- I don't know much about Monad **in category theory**.
- Disclaimer: it'd sound too natural for people who already know Monad.

# In short,

- I got **fairy sure** of Monad in Haskell by interpreting it as \
  "*things to do* every time a function returns a value."

# Monad is a type class

- Like this (reprinted) ↓

    ```haskell
    class Monad m where
      return :: a -> m a
      (>>=) :: m a -> (a -> m b) -> m b
      -- snip. --
    ```

# Recall what a type class is:

- something like...
    - Interface in Java and C# etc.
    - Module providing mix-in in Ruby.
- =\> Provides a way to put **types with same behavior altogether!**

# Why type class is useful

- When creating a type, get various functions available for the type class \
  **only by defining the required methods**.
- The only thing to do is to write all the computation unique to the new type in the required (undefined) methods!

# Then, how about Monad?

- By defining only `return` and `>>=` method,
    - `do` notation available!
- And more!
- Write only computation unique to a new Monad (its instance) \
  in the required (and undefined) method!

# Let's see \>\>= method!

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

- Like the other type classes, Monad abstracts types  \
  by defining the unique computation in the required `>>=` method.

# Let's see \>\>= method!

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

- For example...
    - In `Maybe`, `>>=` *checks Just a or Nothing* \
      before passing `a` of `m a` to `(a -> m b)`.
    - In `Reader`, `>>=` *supplies the missing argument to the reader function* \
      before passing `a` of `m a` to `(a -> m b)`.
    - In `Parser`, `>>=` *consumes the given string* \
      before passing `a` of `m a` to `(a -> m b)`.

# Let's see \>\>= method!

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

- In both types,
    - `>>=` has *some required computation* \
      to pass `a` of `m a` to `(a -> m b)`.
- In addition,
    - `>>=` is implemented so that \
      the required computation can be repeated by passing `m b` of `(a -> m b)` to another function.

# In other words,

- Monad's `>>=` has all things to do \
  in the part of passing `a` of `m a` to `(a -> m b)`
- Monad assigns `>>=` things to do \
  to pass a value (not wrapped by a Monad) to a `(a -> m b)` function \
  each time the source `(a -> m b)` function returns a value.

# That is!

- Monad is useful \
  when you have many functions of type `(a -> m b)`
  with *things to do*.

# For example!!

- For functions that force you to check if successful each time executing. \
  **=\> Maybe Monad**
- For functions that force you to append the result log each time executing. \
  **=\> Writer Monad**
- For functions that force you to make a side effect (e.g. I/O) each time executing. \
  **=\> IO Monad**

# Then, what's the merit of this idea?

- I've seen many metaphors describing Monads (in Japanese), \
- But all of them are too abstract to grasp.

# Then, what's the merit of this idea?

- By contrast, "things to do each time a function returns a value" makes
    - it easier to imagine at least for us programmers (probably).
    - it possilbe to describe Monad based **only on its property as a type class**.
    - them find Monad's merit more naturally.
        - Especially for those who are careful about DRYness \
          by telling "Monad packs things to do every time into one method".
    - it unnecessay to classify Monads into smaller kinds.
        - e.g. "failure monads", "stateful monads" etc.

# Conclusion

- Monad in Haskell is a type class.
- Type classes abstract types with same behavior.
- Monad abstracts "things to do each time a function returns a value".
- Thus, I've appended a new page of the history of the numerous Monad tutorials...
