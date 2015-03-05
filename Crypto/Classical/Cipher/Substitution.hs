{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Crypto.Classical.Cipher.Substitution where

import           Control.Applicative
import           Crypto.Classical.Types
import           Crypto.Classical.Util
import qualified Data.ByteString.Lazy.Char8 as B
import           Data.Char
import           Data.Map.Lazy (Map)
import qualified Data.Map.Lazy as M

---

data Substitution a = Substitution { substitution :: a }
                    deriving (Eq,Show,Functor)

instance Applicative Substitution where
  pure = Substitution
  Substitution f <*> Substitution a = Substitution $ f a

instance Monad Substitution where
  return = pure
  Substitution a >>= f = f a

instance Cipher (Map Char Char) Substitution where
  encrypt m = Substitution . B.map f
    where f c | isLower c = f $ toUpper c
              | otherwise = M.findWithDefault c c m

  decrypt m = encrypt (mapInverse m)